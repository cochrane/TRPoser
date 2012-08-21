//
//  TR1MeshFace.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1MeshFace.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1Mesh.h"
#import "TR1Level.h"
#import "TR1Texture.h"

@implementation TR1MeshFace

+ (NSSet *)keyPathsForValuesAffectingTexture
{
	return [NSSet setWithObjects:@"surfaceIndex", @"isTextured", nil];
}

- (id)initFromDataStream:(TRInDataStream *)stream inMesh:(TR1Mesh *)mesh corners:(NSUInteger)corners isTextured:(BOOL)isTextured;
{
	if (!(self = [super init])) return nil;
	
	_mesh = mesh;
	self.isTextured = isTextured;
	
	_indices = [[NSMutableArray alloc] initWithCapacity:corners];
	for (NSUInteger i = 0; i < corners; i++)
		[_indices addObject:@( [stream readUint16 ])];
	
	self.surfaceIndex = [stream readUint16];
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
	for (NSNumber *number in self.indices)
		[stream appendUint16:number.unsignedShortValue];
	
	[stream appendUint16:self.surfaceIndex];
}

- (BOOL)hasAlpha;
{
	return NO;
}

- (NSUInteger)shininess
{
	return 0;
}

- (BOOL)isTwoSided;
{
	return NO;
}

- (TR1Texture *)texture
{
	if (!self.isTextured) return nil;
	return [[self.mesh.level valueForKey:@"objectTextures"] objectAtIndex:self.surfaceIndex];
}

- (void)setTexture:(TR1Texture *)texture
{
	if (!self.isTextured) return;
	
	//self.surfaceIndex = texture.index;
}

- (NSUInteger)colorIndex8
{
	return self.surfaceIndex & 0x00FF;
}
- (NSUInteger)colorIndex16
{
	return (self.surfaceIndex & 0xFF00) >> 8;
}

- (void)setColorIndex8:(NSUInteger)colorIndex8
{
	self.surfaceIndex = (self.surfaceIndex & 0xFF00) | (colorIndex8 & 0x00FF);
}
- (void)setColorIndex16:(NSUInteger)colorIndex16
{
	self.surfaceIndex = (self.surfaceIndex & 0x00FF) | ((colorIndex16 & 0x00FF) << 8);
}

@end
