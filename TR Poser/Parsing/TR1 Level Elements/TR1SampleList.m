//
//  TR1SampleList.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1SampleList.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR1SampleList ()
{
	NSUInteger numSamples;
	uint8_t *samples;
}

@end

@implementation TR1SampleList

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;

	numSamples = [stream readUint32];
	samples = malloc(numSamples * sizeof(uint16_t));
	[stream readUint8Array:samples count:numSamples];
	
	return self;
}

- (void)dealloc
{
	free(samples);
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint32:(uint32_t) numSamples];
	[stream appendUint8Array:samples count:numSamples];
}

@end
