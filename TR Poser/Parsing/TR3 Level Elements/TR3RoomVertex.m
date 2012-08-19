//
//  TR3RoomVertex.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR3RoomVertex.h"

@implementation TR3RoomVertex

- (id)initFromDataStream:(TRInDataStream *)stream;
{
	self.colorField = self.lighting2;
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	self.lighting2 = self.colorField;
	
	[super writeToStream:stream];
}

- (NSColor *)color
{
	NSUInteger alpha = (self.colorField & 0x8000) >> 0xF;
	NSUInteger red = (self.colorField & 0x7C00) >> 0xA;
	NSUInteger green = (self.colorField & 0x03E0) >> 0x5;
	NSUInteger blue = (self.colorField & 0x001F) >> 0x0;
	
	return [NSColor colorWithCalibratedRed:(CGFloat) red / 31.0 green:(CGFloat) green / 31.0 blue:(CGFloat) blue / 31.0 alpha:(CGFloat) alpha];
}

- (void)setColor:(NSColor *)color
{
	NSUInteger alpha = color.alphaComponent > 0.0;
	NSUInteger red = color.redComponent * 31.0;
	NSUInteger green = color.greenComponent * 31.0;
	NSUInteger blue = color.blueComponent * 31.0;
	
	self.colorField = (alpha << 0xF) | (red << 0xA) | (green << 0x5) | (blue << 0x0);
}

@end
