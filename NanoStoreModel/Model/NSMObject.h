//
//  NSMObject.h
//  NanoStoreModel
//
//  Created by Francis Chong on 29/5/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "NSFNanoObject.h"
#import "NSMObjectMetadata.h"

@interface NSMObject : NSFNanoObject

@property (nonatomic, strong) NSDictionary* nsmBags;

// save this objects, and all bags related to this object
-(BOOL) saveStoreAndReturnError:(NSError * __autoreleasing *)error;

// The store used to save this object
+(NSFNanoStore*) store;

// Set the store used to save this object
+(void) setStore:(NSFNanoStore*)store;

+(id) modelWithDictionary:(NSDictionary*)dictionary;

+(id) model;

@end

@interface NSMObject (Dynamic)

+(NSMObjectMetadata*) metadata;

@end

@interface NSMObject (Callbacks)

// call before the saveStoreAndReturnError: is actually call, if return NO, the model will not save, optionally return error to indicate the cause
-(BOOL) modelShouldSaveAndReturnError:(NSError * __autoreleasing *)error;

// call before the saveStoreAndReturnError: is actually saving the data
-(void) modelWillSave;

// call after the saveStoreAndReturnError: save the data successfully
-(void) modelDidSave;

@end
