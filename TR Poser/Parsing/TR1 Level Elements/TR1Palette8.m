//
//  TR1Palette8.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Palette8.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR1Palette8 ()
{
	uint8_t data[768];
}

@end

@implementation TR1Palette8

- (id)initFromDataStream:(TRInDataStream *)stream
{
	if (!(self = [super init])) return nil;
	
	[stream readUint8Array:data count:sizeof(data)];
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream
{
	[stream appendUint8Array:data count:sizeof(data)];
}

- (NSUInteger)countOfColors;
{
	return 256;
}
- (NSColor *)objectInColorsAtIndex:(NSUInteger)index;
{
	float red = ((float) data[index*3 + 0]) / ((float) UINT8_MAX);
	float blue = ((float) data[index*3 + 1]) / ((float) UINT8_MAX);
	float green = ((float) data[index*3 + 2]) / ((float) UINT8_MAX);
	
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
}

- (void)getColor:(uint8_t *)rgb atIndex:(NSUInteger)index;
{
	memcpy(rgb, &data[index*3], 3);
}

@end
