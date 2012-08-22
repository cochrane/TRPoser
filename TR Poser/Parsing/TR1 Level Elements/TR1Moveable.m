//
//  TR1Moveable.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Moveable.h"

@implementation TR1Moveable

+ (NSString *)structureDescriptionSource
{
	return @"bitu32 objectID;\
	bitu16 meshCount;\
	bitu16 meshStart;\
	bitu32 meshTreeOffset;\
	bitu32 frameOffset;\
	bitu16 animationOffset;\
	@derived firstAnimation=level.animations[animationOffset]";
}

@dynamic firstAnimation;

@end
