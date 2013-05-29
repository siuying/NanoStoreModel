//
//  NSMDynamicAdditions.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSMObjectMetadata;

// setup metadata for class
NSMObjectMetadata * NSMSetMetadataForClass(Class klass,void(^definition)(NSMObjectMetadata *));

// add class method to the model class
void NSMInitializeClass(Class klass);