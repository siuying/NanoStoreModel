//
//  NSMObject.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMObject.h"
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

@interface NSMObject ()
@end

@implementation NSMObject

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
                }
            }];
        }
    }
    free(propertyArray);
}

+ (void) initialize {
    [self setupAccessors];
}

@end
