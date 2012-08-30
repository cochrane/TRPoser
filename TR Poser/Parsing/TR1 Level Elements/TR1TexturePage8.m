//
//  TR1TexturePage8.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1TexturePage8.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1Level.h"
#import "TR1Palette8.h"

@interface TR1TexturePage8 ()
{
	uint8_t indices[256*256];
	
	NSData *transformedPixels;
}

@end

@implementation TR1TexturePage8

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super initFromDataStream:stream inLevel:level])) return nil;
	
	[stream readUint8Array:indices count:256*256];
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream
{
	[stream appendUint8Array:indices count:256*256];
}

- (NSData *)pixels32Bit;
{
	if (!transformedPixels)
	{
		// We only need the transformed palettized texture
		// on TR1, and there, the only palette is the 8-bit
		// one anyway.
		TR1Palette8 *palette = self.level.palette8;
		uint8_t rgba[256*256*4];
		for (NSUInteger i = 0; i < 256*256; i++)
		{
			if (indices[i] == 0)
			{
				rgba[i*4+0] = 0;
				rgba[i*4+1] = 0;
				rgba[i*4+2] = 0;
				rgba[i*4+3] = 0;
			}
			else
			{
				rgba[i*4+0] = 255;
				[palette getColor:&rgba[i*4+1] atIndex:indices[i]];
			}
		}
		transformedPixels = [NSData dataWithBytes:rgba length:sizeof(rgba)];
	}
	return transformedPixels;
}

@end
