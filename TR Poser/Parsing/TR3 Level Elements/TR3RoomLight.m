//
//  TR3RoomLight.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR3RoomLight.h"

#import <AppKit/NSColorSpace.h>

@implementation TR3RoomLight

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu8 red; \
	bitu8 green; \
	bitu8 blue; \
	bitu8 unused; \
	bitu32 fade1;\
	bitu32 fade2;";
}

- (NSColor *)color
{
	return [NSColor colorWithCalibratedRed:(CGFloat) self.red / 255.0f green:(CGFloat) self.green / 255.0f blue:(CGFloat) self.blue / 255.0f alpha:1.0f];
}

- (void)setColor:(NSColor *)color
{
	NSColor *rgbColor = [color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
	
	self.red = rgbColor.redComponent * 255.0f;
	self.green = rgbColor.greenComponent * 255.0f;
	self.blue = rgbColor.blueComponent * 255.0f;
	self.unused = 0;
}

@end
