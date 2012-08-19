//
//  TR1Box.m
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Box.h"

@implementation TR1Box

+ (NSString *)structureDescriptionSource
{
	return @"bit32 minWorldZ;\
	bit32 maxWorldZ;\
	bit32 minWorldX;\
	bit32 maxWorldX;\
	bit16 floorHeight;\
	bitu16 overlapIndex;\
	@factor(unsigned) minSectorX=minWorldX/1024;\
	@factor(unsigned) maxSectorX=maxWorldX/1024;\
	@factor(unsigned) minSectorZ=minWorldZ/1024;\
	@factor(unsigned) maxSectorZ=maxWorldZ/1024;\
	";
}

@dynamic minSectorX, maxSectorX, minSectorZ, maxSectorZ;
@synthesize minWorldX, maxWorldX, minWorldZ, maxWorldZ;

@end
