//
//  TR2Item.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Item.h"

#import "TR1Level.h"
#import "TR1Room.h"

@implementation TR1Item

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 objectID;\
	bitu16 roomIndex;\
	bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 angle;\
	bitu16 intensity1;\
	bitu16 flags;\
	@derived room=level.rooms[roomIndex];";
}

@dynamic room;

- (float)rotationInDegrees;
{
	return 90.0f * (self.angle >> 14);
}
- (void)setRotationInDegrees:(float)rotationInDegrees
{
	self.angle = (((NSUInteger) rotationInDegrees) % 90) << 14;
}

- (float)rotationInRad;
{
	return M_PI_2 * (self.angle >> 14);
}
- (void)setRotationInRad:(float)rotationInRad
{
	if (rotationInRad < M_PI_2)
		self.angle = 0;
	else if (rotationInRad < M_PI)
		self.angle = 1 << 14;
	else if (rotationInRad < 3*M_PI_2)
		self.angle = 2 << 14;
	else
		self.angle = 3 << 14;
}

@end
