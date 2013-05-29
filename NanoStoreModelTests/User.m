//
//  User.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic name, age, createdAt, cars;

MODEL(^(NSMObjectMetadata* meta){
    [meta attribute:@"name"];
    [meta attribute:@"age"];
    [meta attribute:@"createdAt"];
    [meta bag:@"cars"];
})

-(BOOL) shouldSaveAndReturnError:(NSError * __autoreleasing *)error {
    if (!self.name) {
        if (error) {
            *error = [NSError errorWithDomain:@"User" code:0 userInfo:@{@"description": @"missing required field"}];
        }
        return NO;
    }
    return YES;
}

@end

