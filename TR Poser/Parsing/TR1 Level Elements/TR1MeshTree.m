//
//  TR1MeshTree.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1MeshTree.h"

@implementation TR1MeshTree

+ (NSString *)structureDescriptionSource
{
	return @"bitu32 flags;\
	bit32 offsetX;\
	bit32 offsetY;\
	bit32 offsetZ;";
}

@dynamic push, pop;

@end
