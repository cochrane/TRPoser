//
//  TR1StateChange.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1StateChange.h"

#import "TR1Level.h"

@implementation TR1StateChange

+ (NSString *)structureDescriptionSource
{
	return @"bit16 stateID;\
	bit16 numAnimDispatches;\
	bit16 firstAnimDispatch;";
}

- (NSUInteger)countOfAnimDispatches
{
	return self.numAnimDispatches;
}
- (TR1AnimationDispatch *)objectInAnimDispatchesAtIndex:(NSUInteger)index
{
	return [self.level.animationDispatches objectAtIndex:self.firstAnimDispatch + index];
}

@end
