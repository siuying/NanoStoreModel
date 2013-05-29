//
//  NSFNanoStore+NanoStoreModelAdditions.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSFNanoStore+NanoStoreModelAdditions.h"

#import "NanoStore.h"

#import <objc/runtime.h>

void * NSMNanoStoreDefaultStoreKey = &NSMNanoStoreDefaultStoreKey;

@implementation NSFNanoStore (NanoStoreModelAdditions)

// The default store used to save this object
+(NSFNanoStore*) defaultStore {
    NSFNanoStore* store = objc_getAssociatedObject([self class], &NSMNanoStoreDefaultStoreKey);
    if (!store) {
        store = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
        [[self class] setDefaultStore:store];
    }
    return store;
}

// Set the default store used to save this object
+(void) setDefaultStore:(NSFNanoStore*)store {
    objc_setAssociatedObject (
                              [self class],
                              &NSMNanoStoreDefaultStoreKey,
                              store,
                              OBJC_ASSOCIATION_RETAIN
                              );
}

@end
