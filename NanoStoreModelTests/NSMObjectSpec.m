//
//  NanoStoreModel - NSMObjectSpec.m
//  Copyright 2013 Ignition Soft. All rights reserved.
//
//  Created by: Francis Chong
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "NSMObject.h"
#import "NSFNanoStore+NanoStoreModelAdditions.h"

SpecBegin(NSMObject)

describe(@"NSMObject", ^{
    describe(@"+store", ^{
        it(@"should return default store (memory) by default", ^{
            expect([NSMObject store]).to.equal([NSFNanoStore defaultStore]);
        });
    });

    describe(@"+setStore:", ^{
        it(@"should set store to a different store", ^{
            NSFNanoStore* store = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
            [NSMObject setStore:store];

            expect([NSMObject store]).to.equal(store);
            expect([NSMObject store]).toNot.equal([NSFNanoStore defaultStore]);
        });
    });
});

SpecEnd
