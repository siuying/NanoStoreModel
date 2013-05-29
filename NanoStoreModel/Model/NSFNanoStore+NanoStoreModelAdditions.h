//
//  NSFNanoStore+NanoStoreModelAdditions.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NanoStore.h"

@interface NSFNanoStore (NanoStoreModelAdditions)

// The default store used to save this object
+(NSFNanoStore*) defaultStore;

// Set the default store used to save this object
+(void) setDefaultStore:(NSFNanoStore*)store;

@end
