//
//  NSMObjectMetadata.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMObjectMetadata : NSObject

@property (nonatomic, strong, readonly) NSSet *attributes;
@property (nonatomic, strong, readonly) NSSet *bags;

- (void) attribute:(NSString*)attrName;
- (void) bag:(NSString*)bagName;

@end