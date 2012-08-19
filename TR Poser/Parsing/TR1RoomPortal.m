//
//  TR1RoomPortal.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomPortal.h"

@implementation TR1RoomPortal

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 otherRoomIndex;\
	TR1Vertex normal;\
	TR1Vertex vertices[4];\
	@derived otherRoom=level.rooms[otherRoomIndex];";
}

@dynamic otherRoom;

@end
