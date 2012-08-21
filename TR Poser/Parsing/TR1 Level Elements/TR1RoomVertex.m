//
//  TR1RoomVertex.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomVertex.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"
#import "TR1Level.h"

#import "TR1Vertex.h"

@implementation TR1RoomVertex

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	_level = level;
	
	self.position = [[TR1Vertex alloc] initFromDataStream:stream];
	
	self.lighting1 = [stream readUint16];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[self.position writeToStream:stream];
	[stream appendUint16:self.lighting1];
}

- (void)setColor:(NSColor *)color
{
	NSColorSpace *graySpace = [NSColorSpace genericGrayColorSpace];
	NSColor *grayScaleColor = [color colorUsingColorSpace:graySpace];
	
	float lightValue = [grayScaleColor whiteComponent];
	self.lighting1 = [self.level lightValueFromBrightness:lightValue];
}

- (NSColor *)color
{
	float lightValue = [self.level normalizeLightValue:self.lighting1];
	return [NSColor colorWithDeviceWhite:lightValue alpha:1.0];
}

@end
