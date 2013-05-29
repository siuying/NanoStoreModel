NanoStoreModel
==============

Quick and easy way to use NanoStore as your model. 

NanoStoreModel composite of two parts: a model DSL and a thin layer of Objective-C classes provide dynamic attributes accessor, initializer, finders, helpers and KVO.

Stage: Concept stage only.

## How It Works

1. Define your model class in the ruby DSL.
2. Use the model class directly or subclass them.

### Define a Model

```objective-c
@interface User : NSModelObject
@property (strong) NSString* user;
@property (strong) NSString* age;
@property (strong) NSDate* createdAt;
@property (strong) NSFNanoBag* cars;
@end

@implementation User

@dynamic user, age, createdAt, cars;

MODEL(^(NanoStoreModelMetadata* metadata){
  [metadata field:@"name"];
  [metadata field:@"age"];
  [metadata field:@"createdAt"];
  [metadata bag:@"cars"];
})

@end
```

### Using the Model

```objective-c
// Instantiate a NanoStore and open it
NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

// Create an User
User *user = [User user];
user.name = @"Joe";
user.age = @20;
user.createdAt = [NSDate date];

// Add it to the document store
[nanoStore addObject:user error:nil];

// Close the document store
[nanoStore closeWithError:nil];
```

### Association

```objective-c
User *user = [User userWithDictionary:@{@"name": @"Joe", @"age": @20, @"createdAt": [NSDate date]}];
Cat *car = [Cat carWithDictionary:@{@"name": @"Mini", @"age": @0}];
[user.cars addObject:car error:nil];
user.cars # => #<NanoStore::Bag:0x7411410> 
```

