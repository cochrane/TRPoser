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

- (void)setPop:(BOOL)pop
{
	self.flags = (self.flags & 0xFFFE) | (pop << 0);
}
- (BOOL)pop
{
	return (self.flags & 0x0001) != 0;
}

- (void)setPush:(BOOL)push
{
	self.flags = (self.flags & 0xFFFD) | (push << 1);
}
- (BOOL)push
{
	return (self.flags & 0x0002) != 0;
}

@end
