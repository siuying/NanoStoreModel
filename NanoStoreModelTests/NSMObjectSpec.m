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

#import "User.h"
#import "Car.h"

@interface UserObserver : NSObject
@property (nonatomic, assign) BOOL notified;
@end

@implementation UserObserver
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    self.notified = YES;
}
@end

SpecBegin(NSMObject)

describe(@"NSMObject", ^{
    before(^{
        [NSFNanoStore setDefaultStore:nil];
    });
    
    describe(@"store", ^{
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
        });
    });

    describe(@"-saveStoreAndReturnError:", ^{
        it(@"should persists attribute", ^{
            User* user = [User model];
            user.name = @"Jone";
            [user.cars addObject:[Car modelWithDictionary:@{@"name": @"Honda"}] error:nil];
            [user.cars addObject:[Car modelWithDictionary:@{@"name": @"Nessan"}] error:nil];
            [user saveStoreAndReturnError:nil];
            expect(user.store).toNot.beNil();
            
            NSFNanoSearch *search = [NSFNanoSearch searchWithStore:user.store];
            search.attribute = @"name";
            search.match = NSFEqualTo;
            search.value = @"Jone";
            
            // Returns a dictionary with the UUID of the object (key) and the NanoObject (value).
            NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
            NSArray* users = [searchResults allValues];
            expect(users).haveCountOf(1);
            
            User* user2 = [users objectAtIndex:0];
            expect([user2.cars count]).to.equal(2);
        });
    });

    describe(@"+metadata", ^{
        it(@"should return model metadata", ^{
            NSMObjectMetadata* metadata = [User metadata];
            expect(metadata.attributes).haveCountOf(3);
            expect(metadata.attributes).to.contain(@"name");
            expect(metadata.attributes).to.contain(@"age");
            expect(metadata.attributes).to.contain(@"createdAt");
            expect(metadata.bags).haveCountOf(1);
            expect(metadata.bags).to.contain(@"cars");
        });        
    });

    describe(@"KVO", ^{
        it(@"should notify KVO observer", ^{
            UserObserver* observer = [[UserObserver alloc] init];
            User* user = [User model];
            [user addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];

            user.name = @"Jone";
            expect(observer.notified).to.beTruthy();
            [user removeObserver:observer forKeyPath:@"name"];
        });
    });

    describe(@"callbacks", ^{
        it(@"should call the callbacks in lifecycle", ^{
            User* user = [User model];
            user.name = @"Jone";
            [user saveStoreAndReturnError:nil];
        });

        describe(@"-modelShouldSaveAndReturnError:", ^{
            it(@"should not save if modelShouldSaveAndReturnError: return NO", ^{
                User* user = [User model];
                expect([user modelShouldSaveAndReturnError:nil]).to.beFalsy();
                expect([user saveStoreAndReturnError:nil]).to.beFalsy();
            });
        });
    });
});

SpecEnd
