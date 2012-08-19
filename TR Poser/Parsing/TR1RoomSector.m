//
//  TR1RoomSector.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomSector.h"

#import "TR1Level.h"
#import "TR1Room.h"

@implementation TR1RoomSector

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 floorDataIndex;\
	bitu16 boxIndex;\
	bitu8 roomBelowIndex;\
	bitu8 floorHeight;\
	bitu8 roomAboveIndex;\
	bitu8 ceilingHeight;";
}

+ (NSSet *)keyPathsForValuesAffectingRoomAbove
{
	return [NSSet setWithObjects:@"roomAboveIndex", @"level.rooms", nil];
}
+ (NSSet *)keyPathsForValuesAffectingRoomBelow
{
	return [NSSet setWithObjects:@"roomBelowIndex", @"level.rooms", nil];
}
+ (NSSet *)keyPathsForValuesAffectingWorldCeiling
{
	return [NSSet setWithObjects:@"ceilingHeight", nil];
}
+ (NSSet *)keyPathsForValuesAffectingWorldFloor
{
	return [NSSet setWithObjects:@"floorHeight", nil];
}

- (void)setRoomBelow:(TR1Room *)roomBelow
{
	if (roomBelow == nil)
		self.roomBelowIndex = UINT8_MAX;
	else
		self.roomBelowIndex = roomBelow.number;
}
- (TR1Room *)roomBelow
{
	if (self.roomBelowIndex == UINT8_MAX)
		return nil;
	else
		return [[self.level valueForKey:@"rooms"] objectAtIndex:self.roomBelowIndex];
}

- (void)setRoomAbove:(TR1Room *)roomAbove
{
	if (roomAbove == nil)
		self.roomAboveIndex = UINT8_MAX;
	else
		self.roomAboveIndex = roomAbove.number;
}
- (TR1Room *)roomAbove
{
	if (self.roomAboveIndex == UINT8_MAX)
		return nil;
	else
		return [[self.level valueForKey:@"rooms"] objectAtIndex:self.roomAboveIndex];
}

@end
