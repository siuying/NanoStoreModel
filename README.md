NanoStoreModel
==============

Quick and easy way to use [NanoStore](https://github.com/tciuro/NanoStore) objects as your model. 

NanoStoreModel composite of two parts: a model DSL and a thin layer of Objective-C classes provide dynamic attributes accessor, initializer, finders, helpers and KVO.

Stage: Proof of concept. Don't use it in production yet, but try it out and see if it works!

## How It Works

1. Define your model.
2. Use the model class directly or subclass them.

### Define a Model

Define property normally as you would for your subclass of NSMObject. 


- For the properties that are of supported types (NSArray, NSDictionary, NSString, NSData, NSDate, NSNumber), the values will be persisted. 
- For the properties that are NSFNanoBag, the key of the bag will be persisted.
- Other properties are ignored.

```objective-c
@interface User : NSMObject
@property (strong) NSString* name;
@property (strong) NSNumber* age;
@property (strong) NSDate* createdAt;
@property (strong) NSFNanoBag* cars;
@end

@implementation User
@dynamic name, age, createdAt;
@end
```

### Using the Model

```objective-c
// Instantiate a NanoStore and open it
NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

// Create an User
User *user = [User model];
user.name = @"Joe";
user.age = @20;
user.createdAt = [NSDate date];
ts:@"jdoe@foo.com", @"jdoe@bar.com", nil] forKey:@"kEmails"];

// Add it to the document store
[nanoStore addObject:object error:nil];

// Close the document store
[nanoStore closeWithError:nil];
```

### Using Bags

