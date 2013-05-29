//
//  NSMDynamicAdditions.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSMObjectMetadata;

NSMObjectMetadata * NSMSetMetadataForClass(Class klass,void(^definition)(NSMObjectMetadata *));
void NSMInitializeClass(Class klass);