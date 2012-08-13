//
//  TR1MeshVertex.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1MeshVertex.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR1MeshVertex ()
{
	int16_t coords[3];
}

@end

@implementation TR1MeshVertex

- (id)initFromDataStream:(TRInDataStream *)stream;
{
	if (!(self = [super init])) return nil;
	
	[stream readUint16Array:(uint16_t *) coords count:3];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint16Array:(uint16_t *) coords count:3];
}

- (void)setX:(NSInteger)x
{
	coords[0] = x;
}
- (NSInteger)x
{
	return coords[0];
}

- (void)setY:(NSInteger)y
{
	coords[1] = y;
}
- (NSInteger)y
{
	return coords[1];
}

- (void)setZ:(NSInteger)z
{
	coords[2] = z;
}
- (NSInteger)z
{
	return coords[2];
}

@end
