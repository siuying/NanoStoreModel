//
//  NSMDynamicAdditions.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMDynamicAdditions.h"
#import "NSMObjectMetadata.h"

#import <objc/runtime.h>

void * NSMObjectMetadataKey = &NSMObjectMetadataKey;

NSMObjectMetadata * NSMSetMetadataForClass(Class klass,void(^definition)(NSMObjectMetadata*)) {
    NSMObjectMetadata* metadata = (NSMObjectMetadata *)objc_getAssociatedObject(klass, &NSMObjectMetadataKey);
    if (!metadata) {
        metadata = [[NSMObjectMetadata alloc] init];
        objc_setAssociatedObject (
                                  klass,
                                  &NSMObjectMetadataKey,
                                  metadata,
                                  OBJC_ASSOCIATION_RETAIN
                                  );
        definition(metadata);
    }
    return metadata;
}

void NSMInitializeClass(Class klass) {
}
