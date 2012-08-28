//
//  TR1Animation.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Animation.h"

#import "TR1Level.h"
#import "TR1FrameData.h"

@interface TR1Animation ()

@end

@implementation TR1Animation

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
	bitu16 frameStart;\
	bitu16 frameEnd;\
	bitu16 nextAnimationIndex;\
	bitu16 nextFrameIndex;\
	bitu16 stateChangesCount;\
	bitu16 stateChangesOffset;\
	bitu16 animCommandCount;\
	bitu16 animCommandOffset;\
	@derived nextAnimation=level.animations[nextAnimationIndex];";
}

@dynamic nextAnimation;

- (NSUInteger)countOfStateChanges;
{
	return self.stateChangesCount;
}
- (TR1StateChange *)objectInStateChangesAtIndex:(NSUInteger)index;
{
	return [self.level.stateChanges objectAtIndex:index + self.stateChangesOffset];
}

- (TRFrame *)frameAtIndex:(NSUInteger)index object:(TR1Moveable *)moveable;
{
	NSAssert(index >= self.frameStart && index <= self.frameEnd, @"Frame has to be in [%lu, %lu], is %lu", self.frameStart, self.frameEnd, index);
	TR1FrameData *data = self.level.frames;
	return [data frameAtIndex:index offset:self.frameOffset/2 forObject:moveable];
}

@end
