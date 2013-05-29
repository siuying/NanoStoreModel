//
//  NSMDynamicAdditions.m
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSMDynamicAdditions.h"
#import "NSMObjectMetadata.h"
#import "NSMObject.h"
#import "NSFNanoBag.h"

#import <objc/runtime.h>

void * NSMObjectMetadataKey = &NSMObjectMetadataKey;

// Implementation of attribute setter (set<AttributeName>:)
void NSMObjectAttributeSetter(id self, SEL _cmd, id val) {
    NSMObject* object = self;
    NSString* selector = NSStringFromSelector(_cmd);
    NSString *key = [[selector substringWithRange:NSMakeRange(3, selector.length-4)] lowercaseString];
    [self willChangeValueForKey:key];
    [object setObject:val forKey:key];
    [self didChangeValueForKey:key];
}

// Implementation of attribute getter (<AttributeName>)
id NSMObjectAttributeGetter(id self, SEL _cmd) {
    NSMObject* object = self;
    NSString *key = [NSStringFromSelector(_cmd) lowercaseString];
    return [object objectForKey:key];
}

// Implementation of bag getter (<AttributeName>)
id NSMObjectBagGetter(id self, SEL _cmd) {
    NSMObject* object = self;
    NSString *key = [NSStringFromSelector(_cmd) lowercaseString];
    if ([[object nsmBags] objectForKey:key]) {
        return [[object nsmBags] objectForKey:key];
    }

    NSString* bagKey = [object objectForKey:key];
    NSFNanoBag* bag;
    if (bagKey) {
        NSArray* bags = [[object store] bagsWithKeysInArray:@[bagKey]];
        if ([bags count] > 0) {
            bag = [bags objectAtIndex:0];
        }
    } else {
        bag = [NSFNanoBag bag];
        [object setObject:bag.key forKey:key];
    }

    [[object nsmBags] setValue:bag forKey:key];
    return bag;
}

NSMObjectMetadata * NSMSetMetadataForClass(Class klass,void(^definition)(NSMObjectMetadata*)) {
    NSMObjectMetadata* metadata = (NSMObjectMetadata *)objc_getAssociatedObject(klass, &NSMObjectMetadataKey);
    if (!metadata) {
        metadata = [[NSMObjectMetadata alloc] init];
        objc_setAssociatedObject (
                                  klass,
                                  &NSMObjectMetadataKey,
                                  metadata,
                                  OBJC_ASSOCIATION_RETAIN
                                  );
        definition(metadata);
    }
    return metadata;
}

void NSMInitializeClass(Class klass) {
    NSMObjectMetadata *metadata = [klass performSelector:@selector(metadata)];
    for (NSString *attribute in metadata.attributes) {
        NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [[attribute substringWithRange:NSMakeRange(0, 1)] uppercaseString], [attribute substringWithRange:NSMakeRange(1, attribute.length-1)]];
        class_addMethod(klass, NSSelectorFromString(setterName), (IMP) NSMObjectAttributeSetter, "v@:@");
        class_addMethod(klass, NSSelectorFromString(attribute), (IMP) NSMObjectAttributeGetter, "@@:");
    }
    
    for (NSString *bag in metadata.bags) {
        class_addMethod(klass, NSSelectorFromString(bag), (IMP) NSMObjectBagGetter, "@@:");
    }
}