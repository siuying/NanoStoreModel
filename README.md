NanoStoreModel
==============

Quick and easy way to use [NanoStore](https://github.com/tciuro/NanoStore) objects as your model. 

NanoStoreModel composite of two parts: a model DSL and a thin layer of Objective-C classes provide dynamic attributes accessor, initializer, finders, helpers and KVO.

Stage: Proof of concept. Don't use it in production yet, but try it out and see if it works!

## How It Works

1. Define your model.
2. Use the model class directly or subclass them.

### Define a Model

```objective-c
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
```

### Using the Model

```objective-c
// Instantiate a NanoStore and open it
NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

// Make the User class use the NanoStore
[User setStore:nanoStore];

// Create an User
User *user = [User model];
user.name = @"Joe";
user.age = @20;
user.createdAt = [NSDate date];

// Save the user
[user saveStoreAndReturnError:nil];

// Close the document store
[nanoStore closeWithError:nil];
```

### Association

Light weight association with Bags.

```objective-c
User *user = [User modelWithDictionary:@{@"name": @"Joe", @"age": @20, @"createdAt": [NSDate date]}];
Cat *car = [Cat modelWithDictionary:@{@"name": @"Mini", @"age": @0}];
[user.cars addObject:car error:nil];
user.cars // => #<NanoStore::Bag:0x7411410> 
```

### Lifecycle Callbacks

Override lifecycle callbacks for custom validation or events.

```objective-c
-(BOOL) shouldSaveAndReturnError:(NSError * __autoreleasing *)error {
    if (!self.name) {
        if (error) {
            *error = [NSError errorWithDomain:@"User" code:0 userInfo:@{@"description": @"missing required field"}];
        }
        return NO;
    }
    return YES;
}

-(void) willSave {
  NSLog(@"will save: %@", self);
}

-(void) didSave {
  NSLog(@"did save: %@", self.key);
}

```

