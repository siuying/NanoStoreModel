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
    before(^{
    });
    
    describe(@"getter and setters", ^{
        it(@"should create getter and setters", ^{
            User* user = (User*) [User nanoObject];
            expect([user respondsToSelector:@selector(name)]).to.beTruthy();
            expect([user respondsToSelector:@selector(setName:)]).to.beTruthy();

            NSDate *now = [NSDate date];
            user.name = @"Joe";
            user.age = @30;
            user.createdAt = now;

            User* user2 = (User*) [User nanoObjectWithDictionary:[user nanoObjectDictionaryRepresentation]];
            expect(user2.name).to.equal(user.name);
            expect(user2.age).to.equal(user.age);
            expect(user2.createdAt).to.equal(user.createdAt);
        });
    });
    
    describe(@"KVO", ^{
        it(@"should notify KVO observer", ^{
            UserObserver* observer = [[UserObserver alloc] init];
            User* user = (User*) [User nanoObject];
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
