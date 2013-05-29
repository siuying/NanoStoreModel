//
//  NSMDynamicAdditions.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMDynamicAdditions.h"
#import "NSMObject.h"
#import "NSFNanoBag.h"

#import <objc/runtime.h>

// Implementation of attribute setter (set<AttributeName>:)
void NSMObjectAttributeSetter(id self, SEL _cmd, id val) {
    NSMObject* object = self;
    NSString* selector = NSStringFromSelector(_cmd);
    NSString *key = [[selector substringWithRange:NSMakeRange(3, selector.length-4)] lowercaseString];
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
    NSString *key = [NSStringFromSelector(_cmd) lowercaseString];
    return [object objectForKey:key];
}

void NSMInitializeClass(Class klass) {
    NSSet* supportedType = [NSSet setWithArray:@[@"NSArray", @"NSDictionary", @"NSString", @"NSData", @"NSDate", @"NSNumber"]];
    NSRegularExpression* typeExpr = [NSRegularExpression regularExpressionWithPattern:@"T@\"([a-zA-Z]+)\""
                                                                              options:0
                                                                                error:nil];

    // iterate all properties
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList(klass, &numberOfProperties);
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
            NSString* type = [attributesString substringWithRange:range];
            
            // for each supported property type
            if ([supportedType containsObject:type]) {
                NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [[attribute substringWithRange:NSMakeRange(0, 1)] uppercaseString], [attribute substringWithRange:NSMakeRange(1, attribute.length-1)]];
                class_addMethod(klass, NSSelectorFromString(setterName), (IMP) NSMObjectAttributeSetter, "v@:@");
                class_addMethod(klass, NSSelectorFromString(attribute), (IMP) NSMObjectAttributeGetter, "@@:");
            }
        }
    }
    free(propertyArray);
}