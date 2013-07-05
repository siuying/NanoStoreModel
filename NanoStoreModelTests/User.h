//
//  User.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMObject.h"
#import "NanoStoreModel.h"

@interface User : NSMObject

@property (strong) NSString* name;
@property (strong) NSNumber* age;
@property (strong) NSString* socialNetworkNickname;
@property (strong) NSDate* createdAt;


@property (strong) NSFNanoBag* cars;
@property (strong) NSFNanoBag* soldCars;

@end

