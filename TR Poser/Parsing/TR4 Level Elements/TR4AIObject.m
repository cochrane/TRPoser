//
//  TR4AIObject.m
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4AIObject.h"

@implementation TR4AIObject

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 objectID;\
	bitu16 roomIndex;\
	bit32 positionX;\
	bit32 positionY;\
	bit32 positionZ;\
	bitu16 ocb;\
	bitu16 flags;\
	bit32 angle;";
}

@end
