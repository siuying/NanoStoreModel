//
//  NSMObject.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSFNanoObject.h"

@interface NSMObject : NSFNanoObject

+(id) model;

+(id) modelWithDictionary:(NSDictionary*)dictionary;

+(id) modelWithDictionary:(NSDictionary*)dictionary key:(NSString*)key;

@end