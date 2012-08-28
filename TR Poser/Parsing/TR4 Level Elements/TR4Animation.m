//
//  TR4Animation.m
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4Animation.h"

@implementation TR4Animation

+ (NSString *)structureDescriptionSource
{
	return @"bitu32 frameOffset;\
	bitu8 frameRate;\
	bitu8 frameSize;\
	bitu16 stateID;\
	bitu16 unknown1;\
	bit16 speed;\
	bitu16 accelLo;\
	bit16 accelHi;\
	bitu32 unknown2;\
	bitu32 unknown3;\
	bitu16 frameStart;\
	bitu16 frameEnd;\
	bitu16 nextAnimationIndex;\
	bitu16 nextFrameIndex;\
	bitu16 stateChangesCount;\
	bitu16 stateChangesOffset;\
	bitu16 animCommandCount;\
	bitu16 animCommandOffset;";
}

@end
