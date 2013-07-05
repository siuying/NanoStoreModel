//
//  NSMObject.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMObject.h"
#import <objc/runtime.h>

void * NSMObjectBagsKey = &NSMObjectBagsKey;

// Implementation of attribute setter (set<AttributeName>:)
void NSMObjectAttributeSetter(id self, SEL _cmd, id val) {
    NSMObject* object = self;
    NSString* selector = NSStringFromSelector(_cmd);
    NSMutableString *key = [NSMutableString string];
    [key appendString:[[selector substringWithRange:NSMakeRange(3, 1)] lowercaseString]];
    if ([selector length] > 4) {
        [key appendString:[selector substringWithRange:NSMakeRange(4, selector.length-5)]];
    }

    [self willChangeValueForKey:key];
    if (val) {
        [object setObject:val forKey:key];
    } else {
        [object removeObjectForKey:key];
    }
    [self didChangeValueForKey:key];
}

// Implementation of attribute getter (<AttributeName>)
id NSMObjectAttributeGetter(id self, SEL _cmd) {
    NSMObject* object = self;
    NSString *key = NSStringFromSelector(_cmd);
    return [object objectForKey:key];
}

// Implementation of bag getter (<AttributeName>)
id NSMObjectBagGetter(id self, SEL _cmd) {
    NSMObject* object = self;
    NSString *key = [NSStringFromSelector(_cmd) lowercaseString];
    NSString* bagKey = [object objectForKey:key];
    if (bagKey) {
        NSFNanoBag* bag = [[object performSelector:@selector(nsmBags)] objectForKey:key];
        if (bag) {
            return bag;
        }

        NSArray* bags = [[object store] bagsWithKeysInArray:@[bagKey]];
        if ([bags count] > 0) {
            return [bags objectAtIndex:0];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

// Implementation of bag setter (set<AttributeName>:)
void NSMObjectBagSetter(id self, SEL _cmd, id val) {
    NSAssert([[val class] isSubclassOfClass:[NSFNanoBag class]], @"value must be a NSFNanoBag");

    NSMObject* object = self;
    NSFNanoBag* bag = val;
    NSString* selector = NSStringFromSelector(_cmd);
    NSString *key = [[selector substringWithRange:NSMakeRange(3, selector.length-4)] lowercaseString];
    [self willChangeValueForKey:key];
    if (val) {
        [object setObject:bag.key forKey:key];
        [[object performSelector:@selector(nsmBags)] setObject:bag forKey:key];
    } else {
        [object removeObjectForKey:key];
        [[object performSelector:@selector(nsmBags)] removeObjectForKey:key];
    }
    [self didChangeValueForKey:key];
}

@interface NSMObject ()
-(NSMutableDictionary*) nsmBags;
@end

@implementation NSMObject

-(NSMutableDictionary*) nsmBags {
    NSMutableDictionary* bags = (NSMutableDictionary *) objc_getAssociatedObject([self class], &NSMObjectBagsKey);
    if (!bags) {
        bags = [NSMutableDictionary dictionary];
        objc_setAssociatedObject (
                                  [self class],
                                  &NSMObjectBagsKey,
                                  bags,
                                  OBJC_ASSOCIATION_RETAIN
                                  );
    }
    return bags;
}

+ (void) setupAccessors {
    NSSet* supportedType = [NSSet setWithArray:@[[NSArray class], [NSDictionary class], [NSString class], [NSData class], [NSDate class], [NSNumber class]]];
    NSRegularExpression* typeExpr = [NSRegularExpression regularExpressionWithPattern:@"T@\"([a-zA-Z]+)\""
                                                                              options:0
                                                                                error:nil];
    
    // iterate all properties
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *attribute = [[NSString alloc] initWithUTF8String:property_getName(property)];
        NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        NSTextCheckingResult *firstMatch;
        if ((firstMatch = [typeExpr firstMatchInString:attributesString
                                               options:0
                                                 range:NSMakeRange(0, attributesString.length)])) {
            
            NSRange range = [firstMatch rangeAtIndex:1];
            NSString* clazzName = [attributesString substringWithRange:range];
            Class clazz = NSClassFromString(clazzName);
            
            // for each supported property type
            [supportedType enumerateObjectsUsingBlock:^(Class supportedClazz, BOOL *stop) {
                if ([clazz isSubclassOfClass:supportedClazz]) {
                    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [[attribute substringWithRange:NSMakeRange(0, 1)] uppercaseString], [attribute substringWithRange:NSMakeRange(1, attribute.length-1)]];
                    class_addMethod([self class], NSSelectorFromString(setterName), (IMP) NSMObjectAttributeSetter, "v@:@");
                    class_addMethod([self class], NSSelectorFromString(attribute), (IMP) NSMObjectAttributeGetter, "@@:");
                    *stop = YES;
                }
            }];
            
            // for Bag
            if ([clazz isSubclassOfClass:[NSFNanoBag class]] || [clazzName isEqualToString:@"NSFNanoBag"]) {
                NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [[attribute substringWithRange:NSMakeRange(0, 1)] uppercaseString], [attribute substringWithRange:NSMakeRange(1, attribute.length-1)]];
                class_addMethod([self class], NSSelectorFromString(setterName), (IMP) NSMObjectBagSetter, "v@:@");
                class_addMethod([self class], NSSelectorFromString(attribute), (IMP) NSMObjectBagGetter, "@@:");
            }
        }
    }
    free(propertyArray);
}

+ (void) initialize {
    [self setupAccessors];
}

+(id) model {
    return [self nanoObject];
}

+(id) modelWithDictionary:(NSDictionary*)dictionary {
    return [self nanoObjectWithDictionary:dictionary];
}

+(id) modelWithDictionary:(NSDictionary*)dictionary key:(NSString*)key {
    return [self nanoObjectWithDictionary:dictionary key:key];
}

@end
