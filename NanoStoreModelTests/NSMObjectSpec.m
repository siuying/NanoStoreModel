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
    __block NSFNanoStore *nanoStore;

    before(^{
        nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    });
    
    after(^{
        [nanoStore closeWithError:nil];
    });
    
    describe(@"attributes", ^{
        it(@"should create getter and setters", ^{
            User* user = (User*) [User model];
            expect([user respondsToSelector:@selector(name)]).to.beTruthy();
            expect([user respondsToSelector:@selector(setName:)]).to.beTruthy();
            
            NSDate *now = [NSDate date];
            user.name = @"Joe";
            user.age = @30;
            user.createdAt = now;
            
            User* user2 = (User*) [User modelWithDictionary:[user nanoObjectDictionaryRepresentation]];
            expect(user2.name).to.equal(user.name);
            expect(user2.age).to.equal(user.age);
            expect(user2.createdAt).to.equal(user.createdAt);
        });
        
        it(@"should accept nil in getter", ^{
            User* user = (User*) [User modelWithDictionary:@{@"name": @"Joe", @"age": @20}];
            user.name = nil;
            expect(user.name).to.beNil();
            expect(user.age).to.equal(@20);
        });
    });

    describe(@"bags", ^{
        it(@"should create bags getter and setters", ^{
            User* user = [User model];
            user.name = @"Joe";
            expect([user respondsToSelector:@selector(cars)]).to.beTruthy();
            expect([user respondsToSelector:@selector(setCars:)]).to.beTruthy();

            NSFNanoBag* theBag = [NSFNanoBag bagWithName:@"hello"];
            user.cars = theBag;

            expect(user.cars.key).to.equal(theBag.key);
            expect([user nanoObjectDictionaryRepresentation][@"cars"]).to.equal(theBag.key);
        });
        
        it(@"should accept nil in getter", ^{
            User* user = [User modelWithDictionary:@{@"name": @"Joe", @"age": @20}];
            user.name = nil;
            expect(user.name).to.beNil();
            expect(user.age).to.equal(@20);
        });
    });
    
    describe(@"persistence", ^{
        it(@"should save attributes and bags", ^{
            User* user = [User modelWithDictionary:@{@"name": @"Joe", @"age": @18, @"createdAt": [NSDate date]}];
            user.cars = [NSFNanoBag bagWithName:@"hello"];
            [nanoStore addObject:user error:nil];
            [nanoStore addObject:user.cars error:nil];
            [nanoStore saveStoreAndReturnError:nil];

            NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
            search.attribute = @"name";
            search.match = NSFEqualTo;
            search.value = @"Joe";

            // Returns a dictionary with the UUID of the object (key) and the NanoObject (value).
            NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
            NSArray* users = [searchResults allValues];
            expect(users).haveCountOf(1);

            User* user2 = [users objectAtIndex:0];
            expect(user2.key).to.equal(user.key);
            expect(user2.name).to.equal(user.name);
            expect(user2.age).to.equal(user.age);
            expect(user2.createdAt).to.equal(user.createdAt);
            expect(user2.cars.key).to.equal(user.cars.key);
            expect([user2 nanoObjectDictionaryRepresentation][@"cars"]).to.equal(user.cars.key);
        });
    });
    
    describe(@"KVO", ^{
        it(@"should notify KVO observer", ^{
            UserObserver* observer = [[UserObserver alloc] init];
            User* user = (User*) [User model];
            [user addObserver:observer
                   forKeyPath:@"name"
                      options:NSKeyValueObservingOptionNew
                      context:nil];

            user.name = @"Jone";
            expect(observer.notified).to.beTruthy();
            [user removeObserver:observer forKeyPath:@"name"];
        });
    });
});

SpecEnd
