//
//  NanoStoreModel - NSMObjectMetadataSpec.m
//  Copyright 2013 Ignition Soft. All rights reserved.
//
//  Created by: Francis Chong
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "NSMObjectMetadata.h"

SpecBegin(NSMObjectMetadata)

describe(@"NSMObjectMetadata", ^{
    __block NSMObjectMetadata* metadata;
    
    before(^{
        metadata = [[NSMObjectMetadata alloc] init];
    });
    
    describe(@"-attribute:", ^{
        it(@"should add attribute to metadata", ^{
            expect([metadata attributes]).haveCountOf(0);
            [metadata attribute:@"name"];

            expect([metadata attributes]).haveCountOf(1);
            expect([metadata attributes]).to.contain(@"name");
        });
    });
    
    describe(@"-bag:", ^{
        it(@"should add bag to metadata", ^{
            expect([metadata bags]).haveCountOf(0);
            [metadata bag:@"cars"];
            
            expect([metadata bags]).haveCountOf(1);
            expect([metadata bags]).to.contain(@"cars");
        });
    });
});

SpecEnd
