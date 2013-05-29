//
//  NSMObjectMetadata.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMObjectMetadata.h"

@interface NSMObjectMetadata ()
@property (nonatomic, strong) NSMutableSet *mutableAttributes;
@property (nonatomic, strong) NSMutableSet *mutableBags;
@end

@implementation NSMObjectMetadata

- (id)init {
    self = [super init];
    if (self) {
        _mutableAttributes = [[NSMutableSet alloc] init];
        _mutableBags = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void) attribute:(NSString*)attrName {
    [self.mutableAttributes addObject:attrName];
}

- (void) bag:(NSString*)bagName {
    [self.mutableBags addObject:bagName];
}

- (NSSet *)attributes {
    return _mutableAttributes.copy;
}

- (NSSet *)bags {
    return _mutableBags.copy;
}

@end
