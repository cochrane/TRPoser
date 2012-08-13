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

- (float)shininess
{
	return 0.0f;
}

- (TR1Texture *)texture
{
	if (!self.isTextured) return nil;
	return [[self.mesh.level valueForKey:@"textures"] objectAtIndex:self.surfaceIndex];
}

- (void)setTexture:(TR1Texture *)texture
{
	if (!self.isTextured) return;
	
	self.surfaceIndex = texture.index;
}

@end
