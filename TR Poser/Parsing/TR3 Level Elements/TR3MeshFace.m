//
//  TR3MeshFace.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR3MeshFace.h"

#import "TROutDataStream.h"

@implementation TR3MeshFace

@synthesize isTwoSided;

- (id)initFromDataStream:(TRInDataStream *)stream inMesh:(TR1Mesh *)mesh corners:(NSUInteger)corners isTextured:(BOOL)isTextured;
{
	if (!(self = [super initFromDataStream:stream inMesh:mesh corners:corners isTextured:isTextured])) return nil;
		
	// Split up
	self.isTwoSided = (self.surfaceIndex & 0x8000) != 0;
	self.surfaceIndex = self.surfaceIndex & 0x7FFF;
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
	for (NSNumber *number in self.indices)
		[stream appendUint16:number.unsignedShortValue];
	
	[stream appendUint16:(self.isTwoSided << 15) & (0x7FFF & self.surfaceIndex)];
}


@end
