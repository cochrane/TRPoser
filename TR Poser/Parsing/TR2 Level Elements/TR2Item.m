//
//  TR2Item.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2Item.h"

@implementation TR2Item

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 objectID;\
	bitu16 roomIndex;\
	bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 angle;\
	bitu16 intensity1;\
	bitu16 intensity2;\
	bitu16 flags;";
}

@end
