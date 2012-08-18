//
//  TRSimpleStructureDescriptionField.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionItem.h"

@class TRInDataStream;
@class TROutDataStream;
@class TRStructure;

@interface TRStructureDescriptionField : TRStructureDescriptionItem

- (id)initWithString:(NSString *)fieldDescription;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) BOOL isPrimitive;

// Only applicable for primitive types
@property (nonatomic, readonly, assign) BOOL isSigned;
@property (nonatomic, readonly, assign) NSUInteger bits;

// Only applicable for class types
@property (nonatomic, readonly, assign) BOOL isVersioned;
@property (nonatomic, readonly, copy) NSString *className;

// For arrays
@property (nonatomic, readonly, assign) NSUInteger fixedArrayLength;
@property (nonatomic, readonly, assign) NSUInteger countFieldBits;

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;

@end
