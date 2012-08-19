//
//  TR4MeshFace.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4MeshFace.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@implementation TR4MeshFace

- (id)initFromDataStream:(TRInDataStream *)stream inMesh:(TR1Mesh *)mesh corners:(NSUInteger)corners isTextured:(BOOL)isTextured;
{
	if (!(self = [super initFromDataStream:stream inMesh:mesh corners:corners isTextured:isTextured])) return nil;
	
	uint16_t alphaAndShininess = [stream readUint16];
	self.hasAlpha = alphaAndShininess & 0x1;
	self.shininess = alphaAndShininess >> 1;
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
	[super writeToStream:stream];
	[stream appendUint16:self.hasAlpha & (self.shininess << 1)];
}


@end
