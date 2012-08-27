//
//  TRStructureDescriptionArrayLengthDescriptor.h
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructureDescriptionPrimitiveType.h"

@class TRInDataStream;
@class TRStructure;

@interface TRStructureDescriptionArrayLength : NSObject

- (id)initWithScanner:(NSScanner *)scanner;
- (id)initWithScanner:(NSScanner *)scanner inBrackets:(BOOL)requireBrackets;

@property (nonatomic, assign, readonly) NSUInteger fixedLength;
@property (nonatomic, copy, readonly) NSString *lengthKeyPath;
@property (nonatomic, assign, readonly) TRStructureDescriptionPrimitiveType countFieldType;
@property (nonatomic, assign, readonly) NSUInteger factor;
@property (nonatomic, assign, readonly) NSUInteger divisor;

- (NSUInteger)readLengthFromStream:(TRInDataStream *)stream object:(TRStructure *)object;
- (void)writeLengthToStream:(TROutDataStream *)stream object:(TRStructure *)object actual:(NSUInteger)actualLength;

@end
