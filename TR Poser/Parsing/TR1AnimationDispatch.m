//
//  TR1AnimDispatch.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1AnimationDispatch.h"

#import "TR1Animation.h"
#import "TR1Level.h"

@implementation TR1AnimationDispatch

+ (NSString *)structureDescriptionSource
{
	return @"bit16 low;\
	bit16 high;\
	bit16 nextAnimationIndex;\
	bit16 nextFrameIndex;\
	@derived nextAnimation=level.animations[nextAnimationIndex]";
}

@dynamic nextAnimation;

@end
