//
//  TR4RoomLight.m
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4RoomLight.h"

@implementation TR4RoomLight

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu8 red;\
	bitu8 green;\
	bitu8 blue;\
	bitu8 lightType;\
	bitu8 unknown;\
	bitu8 intensity1;\
	float32 in;\
	float32 out;\
	float32 length;\
	float32 cutoff;\
	float32 directionX;\
	float32 directionY;\
	float32 directionZ;";
}

@end
