//
//  NSMObject.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMObject.h"
#import <objc/runtime.h>
#import "NSFNanoStore+NanoStoreModelAdditions.h"

void * NSMObjectStoreKey = &NSMObjectStoreKey;

@interface NSMObject () {
    NSMutableDictionary *_nsmMutableBags;
}
@end

@implementation NSMObject

-(NSMutableDictionary*) nsmMutableBags {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nsmMutableBags = [NSMutableDictionary dictionary];
    });
    return _nsmMutableBags;
}

-(NSDictionary*) nsmBags {
    return [self nsmMutableBags];
}

-(BOOL) saveStoreAndReturnError:(NSError *__autoreleasing *)outError {
    __block NSFNanoStore* store = self.store;

    if (!store) {
        store = [[self class] store];
    }
    
    __block BOOL success = [store beginTransactionAndReturnError:outError];
    if (!success) {
        return false;
    }
    
    success = [store addObject:self error:outError];
    if (success) {
        [[self nsmBags] enumerateKeysAndObjectsUsingBlock:^(id key, NSFNanoBag* bag, BOOL *stop) {
            success = [store addObject:bag error:outError];
            if (!success) {
                *stop = YES;
            }
        }];
    }
    success = [store saveStoreAndReturnError:outError];

    if (success) {
        success = [store commitTransactionAndReturnError:outError];
    } else {
        [store rollbackTransactionAndReturnError:nil];
    }
    return success;
}

// The default store used to save this object
+(NSFNanoStore*) store {
    NSFNanoStore* store = objc_getAssociatedObject([self class], &NSMObjectStoreKey);
    if (!store) {
        store = [NSFNanoStore defaultStore];
        [self setStore:store];
    }
    return store;
}

// Set the default store used to save this object
+(void) setStore:(NSFNanoStore*)store {
    objc_setAssociatedObject (
                              [self class],
                              &NSMObjectStoreKey,
                              store,
                              OBJC_ASSOCIATION_RETAIN
                              );
}

@end
