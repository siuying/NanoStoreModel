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

@implementation NSMObject

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
