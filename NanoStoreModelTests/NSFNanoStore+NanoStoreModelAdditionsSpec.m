//
//  NanoStoreModel - NSFNanoStoreAdditionsSpec.m
//  Copyright 2013 Ignition Soft. All rights reserved.
//
//  Created by: Francis Chong
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "NSMObject.h"
#import "NSFNanoStore+NanoStoreModelAdditions.h"

SpecBegin(NSFNanoStoreNanoStoreModelAdditions)

describe(@"NSFNanoStoreNanoStoreModelAdditions", ^{
    describe(@"+defaultStore", ^{
        it(@"should return default store (memory) by default", ^{
            expect([NSFNanoStore defaultStore]).to.beInstanceOf([NSFNanoStore class]);
        });
    });
    
    describe(@"+setDefaultStore:", ^{
        it(@"should set default store to a different store", ^{
            NSFNanoStore* defaultStore = [NSFNanoStore defaultStore];
            NSFNanoStore* store = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
            [NSFNanoStore setDefaultStore:store];
            expect([NSFNanoStore defaultStore]).to.equal(store);
            expect([NSFNanoStore defaultStore]).toNot.equal(defaultStore);
        });
    });
});

SpecEnd
