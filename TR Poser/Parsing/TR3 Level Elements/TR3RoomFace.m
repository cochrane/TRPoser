//
//  TR3RoomFace.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR3RoomFace.h"

#import "TROutDataStream.h"

@implementation TR3RoomFace

- (id)initFromDataStream:(TRInDataStream *)stream inRoom:(TR1Room *)room corners:(NSUInteger)corners;
{
	if (!(self = [super initFromDataStream:stream inRoom:room corners:corners])) return nil;
	
	self.isTwoSided = (self.surfaceIndex & 0x8000) != 0;
	self.surfaceIndex = self.surfaceIndex & 0x7FFF;
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	for (NSNumber *number in self.indices)
		[stream appendUint16:number.unsignedShortValue];
	
	[stream appendUint16:(self.surfaceIndex & 0x7FFF) | self.isTwoSided << 15];
}

@end
