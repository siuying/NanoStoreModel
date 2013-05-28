NanoStoreModel
==============

Quick and easy way to use NanoStore as your model. 

This is set of tools: a model DSL, a Objective-C model class generator and a thin layer of Objective-C classes provide dynamic attributes accessor, initializer, finders, helpers and KVO.

Something like [NanoStoreInMotion](https://github.com/siuying/NanoStoreInMotion) but in Objective-C, and more powerful.

Stage: Concept stage only.

## How It Works

1. Define your model class in the ruby DSL.
2. Generate Objective-C classes on compile time.
3. Use the generated Obejctive-C classes, or subclass them.

### Define a Model

```ruby
class User < NanoStore::Model
  attribute :name, :type => :string
  attribute :age, :type => :number
  attribute :created_at, :type => :date
  bag :cars
end
```

### Generated Model

```objective-c
@interface User : NSMNanoObject
@property (strong) NSString *name;
@property (strong) NSNumber *age;
@property (strong) NSDate *createdAt;
@property (strong) NSFNanoBag *cars;
@end
```

```objective-c
@implementation User
@dynamic name, age, createdAt, cars;
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

