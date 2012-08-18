//
//  TRStructureDescriptionConstField.h
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionField.h"

#import "TRSTructureDescriptionPrimitiveType.h"

@class TRStructure;

@interface TRStructureDescriptionConstField : TRStructureDescriptionField

- (id)initWithString:(NSString *)fieldDescription;

@property (nonatomic, assign, readonly) TRStructureDescriptionPrimitiveType type;
@property (nonatomic, copy, readonly) NSNumber *expectedValue;

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;

@end
