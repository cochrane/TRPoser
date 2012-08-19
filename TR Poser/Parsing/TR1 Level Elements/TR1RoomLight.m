//
//  TR1RoomLight.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomLight.h"

@implementation TR1RoomLight

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 intensity1;\
	bitu32 fade1;";
}

@end
