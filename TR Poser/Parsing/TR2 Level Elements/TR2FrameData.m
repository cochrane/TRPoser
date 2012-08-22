//
//  TR2FrameData.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2FrameData.h"

#import "TRFrame.h"
#import "TR1Moveable.h"

@implementation TR2FrameData

- (NSUInteger)lengthOfFrameAtPosition:(NSUInteger)positionInShorts forObject:(TR1Moveable *)object;
{	
	NSUInteger result = 9; // bounding box + offset;
	NSUInteger pos = positionInShorts + 9;
	for (NSUInteger i = 0; i < object.meshCount; i++)
	{
		// One angle word or two, depending on flag
		NSUInteger angleFlag = self.frameData[pos];
		if (angleFlag == 0)
			result += 2;
		else
			result += 1;
	}
	
	return result;
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
	
	for (NSUInteger i = 0; i < object.meshCount; i++)
	{
		uint16_t frameword1 = self.frameData[position++];
		NSUInteger angleFlag = frameword1 & 0xC000;
		
		NSUInteger rotX = 0, rotY = 0, rotZ = 0;
		if (angleFlag == 0)
		{
			uint16_t frameword2 = self.frameData[position++];
			// Code from VT
			rotX = ((frameword1 & 0x3ff0) >> 4);
			rotY = (((frameword1 & 0x000f) << 6) | ((frameword2 & 0xfc00) >> 10));
			rotZ = (frameword2 & 0x03ff);
		}
		else if (angleFlag == 0x4000)
			rotX = (frameword1 & 0x03FF);
		else if (angleFlag == 0x8000)
			rotY = (frameword1 & 0x03FF);
		else if (angleFlag == 0xC000)
			rotZ = (frameword1 & 0x03FF);
		
		[frame setRotationX:rotX y:rotY z:rotZ atIndex:i];
	}
	
	return frame;
}

@end
