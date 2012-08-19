//
//  TR2Palette16.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2Palette16.h"

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
- (void)writeToDataStream:(TROutDataStream *)stream
{
	[stream appendUint8Array:data count:sizeof(data)];
}

- (NSUInteger)countOfColors;
{
	return 256;
}
- (NSColor *)objectInColorsAtIndex:(NSUInteger)index;
{
	float red = ((float) data[index*4 + 0]) / ((float) UINT8_MAX);
	float blue = ((float) data[index*4 + 1]) / ((float) UINT8_MAX);
	float green = ((float) data[index*4 + 2]) / ((float) UINT8_MAX);
	
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
}

@end
