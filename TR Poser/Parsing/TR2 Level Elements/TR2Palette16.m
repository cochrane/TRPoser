//
//  TR2Palette16.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2Palette16.h"

#import <Accelerate/Accelerate.h>

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR2Palette16 ()
{
	uint8_t data[1024];
}

@end

@implementation TR2Palette16

- (id)initFromDataStream:(TRInDataStream *)stream
{
	if (!(self = [super init])) return nil;
	
	[stream readUint8Array:data count:sizeof(data)];
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint8Array:data count:sizeof(data)];
}

- (NSColor *)objectInColorsAtIndex:(NSUInteger)index;
{
	float red = ((float) data[index*4 + 0]) / ((float) UINT8_MAX);
	float blue = ((float) data[index*4 + 1]) / ((float) UINT8_MAX);
	float green = ((float) data[index*4 + 2]) / ((float) UINT8_MAX);
	
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
}

- (NSData *)asTexturePage;
{
	uint8_t result[256*256*4];
	
	const NSUInteger rowBytes = 256*4;
	const NSUInteger squareEdge = 16;
	const NSUInteger squareRowBytes = squareEdge*rowBytes;
	const NSUInteger squareColumnBytes = squareEdge*4;
	
	for (NSUInteger row = 0, i = 0; row < 16; row++)
	{
		for (NSUInteger column = 0; column < 16; column++, i++)
		{
			vImage_Buffer square = { &result[row*squareRowBytes + column*squareColumnBytes], 16, 16, rowBytes };
			uint8_t color[4] = {(i == 0) ? 0 : 255,
				data[i*4+0],
				data[i*4+1],
				data[i*4+2]
			};
			vImageBufferFill_ARGB8888(&square, color, 0);
		}
	}
	
	return [NSData dataWithBytes:result length:sizeof(result)];
}

@end
