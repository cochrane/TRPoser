//
//  TR1FloorDataList.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1FloorDataList.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR1FloorDataList ()
{
	NSUInteger numCodes;
	uint16_t *codes;
}

@end

@implementation TR1FloorDataList

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	_level = level;
	
	numCodes = [stream readUint32];
	codes = malloc(numCodes * sizeof(uint16_t));
	[stream readUint16Array:codes count:numCodes];
	
	return self;
}

- (void)dealloc
{
	free(codes);
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint32:(uint32_t) numCodes];
	[stream appendUint16Array:codes count:numCodes];
}

- (NSUInteger)countOfCodes;
{
	return numCodes;
}

- (NSNumber *)objectInCodesAtIndex:(NSUInteger)code;
{
	NSAssert(code < numCodes, @"Code has to be less than %lu, is %lu", numCodes, code);
	return @(codes[code]);
}

@end
