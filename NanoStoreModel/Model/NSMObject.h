//
//  NSMObject.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSFNanoObject.h"

@interface NSMObject : NSFNanoObject

// The store used to save this object
+(NSFNanoStore*) store;

// Set the store used to save this object
+(void) setStore:(NSFNanoStore*)store;

@end
