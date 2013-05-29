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
@property (strong) NSNumber* age;
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

@interface Car : NSMObject
@property (strong) NSString* name;
@end

@implementation Car
@dynamic name;
MODEL(^(NSMObjectMetadata* meta){
    [meta attribute:@"name"];
})

@end

#pragma - End Sample Model Definition

SpecBegin(NanoStoreModelMacro)

describe(@"NanoStoreModelMacro", ^{
    before(^{
        [NSFNanoStore setDefaultStore:nil];
    });

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
        
        it(@"should setup attribute getter and setter", ^{
            User* user = [User model];
            user.name = @"Joe";
            user.age = @36;
            NSDate* now = [NSDate date];
            user.createdAt = now;
            expect(user.name).to.equal(@"Joe");
            expect(user.age).to.equal(@36);
            expect(user.createdAt).to.equal(now);
        });

        it(@"should setup bag getter and can use it to persists data", ^{
            User* user = [User model];
            user.name = @"Joe";
            expect(user.cars).to.beInstanceOf([NSFNanoBag class]);
            [user.cars addObject:[Car modelWithDictionary:@{@"name": @"Honda"}] error:nil];
            expect([user.cars count]).to.equal(1);

            [user.cars addObject:[Car modelWithDictionary:@{@"name": @"Nessan"}] error:nil];
            expect([user.cars count]).to.equal(2);
            [user saveStoreAndReturnError:nil];

            NSFNanoSearch *search = [NSFNanoSearch searchWithStore:user.store];
            search.attribute = @"name";
            search.match = NSFEqualTo;
            search.value = @"Joe";
            
            // Returns a dictionary with the UUID of the object (key) and the NanoObject (value).
            NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
            NSArray* users = [searchResults allValues];
            expect(users).haveCountOf(1);

            User* user2 = [users objectAtIndex:0];
            expect([user2.cars count]).to.equal(2);
        });
    });
});

SpecEnd
