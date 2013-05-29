//
//  Person.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMObject.h"

@interface Person : NSMObject

@property (strong) NSString* user;
@property (strong) NSString* age;
@property (strong) NSDate* createdAt;
@property (strong) NSFNanoBag* cars;

@end