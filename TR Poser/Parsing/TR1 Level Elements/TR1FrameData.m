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

#import "TRFrame.h"
#import "TR1Moveable.h"

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

- (void)dealloc
{
	free(frameData);
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint32:(uint32_t) frameDataLength];
	[stream appendUint16Array:frameData count:frameDataLength];
}

- (NSUInteger)lengthOfFrameAtPosition:(NSUInteger)positionInShorts forObject:(TR1Moveable *)object;
{
	// Tomb Raider 1:
	// bounding box (6 values), offset (3 values), num angles (1 value)
	// for each angle 2 values.
	uint16_t numAngles = self.frameData[positionInShorts + 9];
	return 6 + 3 + 1 + numAngles * 2;
}

- (const uint16_t *)frameData
{
	return frameData;
}

- (TRFrame *)frameAtIndex:(NSUInteger)index offset:(NSUInteger)position forObject:(TR1Moveable *)object;
{
	for (NSUInteger i = 0; i < index; i++)
		position += [self lengthOfFrameAtPosition:position forObject:object];
	
	return [self frameAtOffset:position forObject:object];
}

- (TRFrame *)frameAtOffset:(NSUInteger)position forObject:(TR1Moveable *)object;
{
	TRFrame *frame = [[TRFrame alloc] initWithCountOfAngles:object.meshCount];
	
	frame.boundingBoxMinX = self.frameData[position++];
	frame.boundingBoxMinY = self.frameData[position++];
	frame.boundingBoxMinZ = self.frameData[position++];
	
	frame.boundingBoxMaxX = self.frameData[position++];
	frame.boundingBoxMaxY = self.frameData[position++];
	frame.boundingBoxMaxZ = self.frameData[position++];
	
	frame.offsetX = self.frameData[position++];
	frame.offsetY = self.frameData[position++];
	frame.offsetZ = self.frameData[position++];
	
	NSUInteger numSpecifiedAngles = self.frameData[position++];
	
	for (NSUInteger i = 0; i < numSpecifiedAngles; i++)
	{
		// The order looks wrong, but it's not. Code comes from VT Project
		uint16_t frameword2 = self.frameData[position++];
		uint16_t frameword1 = self.frameData[position++];
		
		NSUInteger rotX = ((frameword1 & 0x3ff0) >> 4);
		NSUInteger rotY = (((frameword1 & 0x000f) << 6) | ((frameword2 & 0xfc00) >> 10));
		NSUInteger rotZ = (frameword2 & 0x03ff);
		
		[frame setRotationX:rotX y:rotY z:rotZ atIndex:i];
	}
	
	return frame;
}

@end
