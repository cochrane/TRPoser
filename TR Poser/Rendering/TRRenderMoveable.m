//
//  TRRenderMoveable.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderMoveable.h"

@implementation TRRenderMoveable

- (id)initWithMoveable:(TR1Moveable *)moveable inRenderLevel:(TRRenderLevelResources *)level;
{
	if (!(self = [super init])) return nil;
	
	_moveable = moveable;
	_level = level;
	
	return self;
}

@end
