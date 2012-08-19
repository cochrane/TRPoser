//
//  TR2Box.m
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2Box.h"

@implementation TR2Box

+ (NSString *)structureDescriptionSource
{
	return @"bitu8 minSectorZ;\
	bitu8 maxSectorZ;\
	bitu8 minSectorX;\
	bitu8 maxSectorX;\
	bit16 floorHeight;\
	bitu16 overlapIndex;\
	@factor(unsigned) minWorldX=minSectorX*1024;\
	@factor(unsigned) maxWorldX=maxSectorX*1024;\
	@factor(unsigned) minWorldZ=minSectorZ*1024;\
	@factor(unsigned) maxWorldZ=maxSectorZ*1024;\
	";
}

@synthesize minSectorX, maxSectorX, minSectorZ, maxSectorZ;
@dynamic minWorldX, maxWorldX, minWorldZ, maxWorldZ;

@end
