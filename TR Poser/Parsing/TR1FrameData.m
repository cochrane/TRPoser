//
//  TRFrameData.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1FrameData.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR1FrameData ()
{
	NSUInteger frameDataLength;
	uint16_t *frameData;
}

@end

@implementation TR1FrameData

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	_level = level;
	
	frameDataLength = [stream readUint32];
	frameData = malloc(frameDataLength * sizeof(uint16_t));
	[stream readUint16Array:frameData count:frameDataLength];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint32:(uint32_t) frameDataLength];
	[stream appendUint16Array:frameData count:frameDataLength];
}

@end
