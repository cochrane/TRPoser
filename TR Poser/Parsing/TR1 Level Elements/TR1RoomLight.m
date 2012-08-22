//
//  TR1RoomLight.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomLight.h"

#import "TR1Level.h"

@implementation TR1RoomLight

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 intensity1;\
	bitu32 fade1;";
}

- (void)setColor:(NSColor *)color
{
	if (!color)
		self.intensity1 = UINT16_MAX;
	else
	{
		NSColorSpace *graySpace = [NSColorSpace genericGrayColorSpace];
		NSColor *grayScaleColor = [color colorUsingColorSpace:graySpace];
		
		float lightValue = [grayScaleColor whiteComponent];
		self.intensity1 = [self.level lightValueFromBrightness:lightValue];
	}
}

- (NSColor *)color
{
	if (self.intensity1 == UINT16_MAX) return nil;
	
	float lightValue = [self.level normalizeLightValue:self.intensity1];
	return [NSColor colorWithCalibratedWhite:lightValue alpha:1.0];
}

@end
