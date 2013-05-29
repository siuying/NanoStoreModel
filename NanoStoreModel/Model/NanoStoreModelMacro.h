//
//  NanoStoreModelMacro.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#ifndef NanoStoreModel_NanoStoreModelMacro_h
#define NanoStoreModel_NanoStoreModelMacro_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define MODEL(definition) \
\
+(NSMObjectMetadata*) metadata {\
    return NSMSetMetadataForClass(self, definition);\
}\
\
+ (void) initialize {\
    NSMInitializeClass(self);\
}

#endif
