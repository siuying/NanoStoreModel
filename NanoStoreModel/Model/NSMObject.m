//
//  NSMObject.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMObject.h"
#import <objc/runtime.h>
#import "NSMDynamicAdditions.h"

@interface NSMObject ()
@end

@implementation NSMObject

+ (void) initialize {
    NSMInitializeClass(self);
}

@end
