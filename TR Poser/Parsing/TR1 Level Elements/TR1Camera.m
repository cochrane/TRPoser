//
//  TR1Camera.m
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Camera.h"

@interface TR1Camera ()

@property (nonatomic, assign) NSUInteger unknown1;

@end

@implementation TR1Camera

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 roomIndex;\
	bitu16 unknown1;\
	@derived room=level.rooms[roomIndex]";
}

@dynamic room;

@end
