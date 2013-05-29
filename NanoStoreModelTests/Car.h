//
//  Car.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMObject.h"
#import "NanoStoreModel.h"

@interface Car : NSMObject

@property (strong) NSString* name;

+(NSMObjectMetadata*) metadata;

@end
