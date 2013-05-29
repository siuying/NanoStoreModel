//
//  NanoStoreMacro.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#ifndef NanoStoreModel_NanoStoreMacro_h
#define NanoStoreModel_NanoStoreMacro_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define NS_MODEL(definition) \
\
+(NSMObjectMetadata*) metadata {\
    NSMSetMetadataForClass(self, definition);\
}\
\
+ (void) initialize {\
    NSMInitializeClass(self);\
}

#endif
