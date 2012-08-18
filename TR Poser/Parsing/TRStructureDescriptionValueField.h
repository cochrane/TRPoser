//
//  TRSimpleStructureDescriptionField.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionField.h"

#import "TRStructureDescriptionArrayLength.h"
#import "TRStructureDescriptionPrimitiveType.h"

@class TRInDataStream;
@class TROutDataStream;
@class TRStructure;

@interface TRStructureDescriptionValueField : TRStructureDescriptionField

- (id)initWithString:(NSString *)fieldDescription;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) BOOL isPrimitive;

// Only applicable for primitive types
@property (nonatomic, readonly, assign) TRStructureDescriptionPrimitiveType primitiveType;

// Only applicable for class types
@property (nonatomic, readonly, assign) BOOL isVersioned;
@property (nonatomic, readonly, copy) NSString *className;

// For arrays
@property (nonatomic, retain) TRStructureDescriptionArrayLength *arrayLength;

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;

@end
