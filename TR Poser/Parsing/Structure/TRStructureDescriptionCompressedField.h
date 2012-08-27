//
//  TRStructureDescriptionCompressedField.h
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionField.h"

#import "TRStructureDescriptionArrayLength.h"

@interface TRStructureDescriptionCompressedField : TRStructureDescriptionField

- (id)initWithString:(NSString *)fieldDescription;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, retain, readonly) TRStructureDescriptionArrayLength *compressedLength;
@property (nonatomic, retain, readonly) TRStructureDescriptionArrayLength *uncompressedLength;
@property (nonatomic, assign, readonly) BOOL compressedComesFirst;

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure substreams:(NSDictionary *__autoreleasing*)substreams;
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure substreams:(NSDictionary *)substreams;


@end
