//
//  TR2RoomLight.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2RoomLight.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@implementation TR2RoomLight

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 intensity1;\
	bitu16 intensity2;\
	bitu32 fade1;\
	bitu32 fade2;";
}

@end
