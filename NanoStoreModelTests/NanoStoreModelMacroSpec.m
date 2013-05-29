//
//  NanoStoreModel - NSMObjectSpec.m
//  Copyright 2013 Ignition Soft. All rights reserved.
//
//  Created by: Francis Chong
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "NanoStoreModel.h"

#pragma - Begin Sample Model Definition

@interface User : NSMObject
@property (strong) NSString* name;
@property (strong) NSString* age;
@property (strong) NSDate* createdAt;
@property (strong) NSFNanoBag* cars;
@end

@implementation User
@dynamic name, age, createdAt, cars;
MODEL(^(NSMObjectMetadata* meta){
    [meta attribute:@"name"];
    [meta attribute:@"age"];
    [meta attribute:@"createdAt"];
    [meta bag:@"cars"];
})

@end

#pragma - End Sample Model Definition

SpecBegin(NanoStoreModelMacro)

describe(@"NanoStoreModelMacro", ^{
    it(@"should define model metadata", ^{
        NSMObjectMetadata* metadata = [User metadata];
        expect(metadata.attributes).haveCountOf(3);
        expect(metadata.attributes).to.contain(@"name");
        expect(metadata.attributes).to.contain(@"age");
        expect(metadata.attributes).to.contain(@"createdAt");
        expect(metadata.bags).haveCountOf(1);
        expect(metadata.bags).to.contain(@"cars");
    });
    
    describe(@"+modelWithDictionary:", ^{
        it(@"should define model initializer", ^{
            User* user = [User modelWithDictionary:@{@"name": @"Joe", @"age": @20}];
            expect(user).toNot.beNil();
        });
        
        it(@"should set values with initializer", ^{
            User* user = [User modelWithDictionary:@{@"name": @"Joe", @"age": @20}];
            expect(user.name).to.equal(@"Joe");
            expect(user.age).to.equal(@20);
        });
    });
});

SpecEnd
