//
//  TR1Mesh.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Mesh.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1Level.h"
#import "TR1MeshFace.h"
#import "TR1MeshVertex.h"

@interface TR1Mesh ()

- (void)readCollisionSphereFrom:(TRInDataStream *)stream;
- (void)readVertexDataFrom:(TRInDataStream *)stream;

@end

@implementation TR1Mesh

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level error:(NSError * __autoreleasing *)error;
{
	if (!(self = [super init])) return nil;
	
	_level = level;
	
	_collisionSphereX = [stream readInt16];
	_collisionSphereY = [stream readInt16];
	_collisionSphereZ = [stream readInt16];
	_collisionSphereRadius = [stream readUint16];
	
	NSUInteger verticesCount = [stream readUint16];
	_vertices = [[NSMutableArray alloc] initWithCapacity:verticesCount];
	for (NSUInteger i = 0; i < verticesCount; i++)
		[_vertices addObject:[[TR1MeshVertex alloc] initFromDataStream:(TRInDataStream *)stream]];
	
	NSUInteger normalCount = [stream readUint16];
	if (normalCount != verticesCount)
	{
		// Use internal lighting: An array of values follows
		_lightIntensities = [[NSMutableArray alloc] initWithCapacity:verticesCount];
		for (NSUInteger i = 0; i < verticesCount; i++)
			[_lightIntensities addObject:@([stream readUint16])];
	}
	else
	{
		// External lighting: Read normal values
		_normals = [[NSMutableArray alloc] initWithCapacity:verticesCount];
		for (NSUInteger i = 0; i < verticesCount; i++)
			[_normals addObject:[[TR1MeshVertex alloc] initFromDataStream:stream]];
	}
	
	NSUInteger texturedTrianglesCount = [stream readUint16];
	_texturedTriangles = [[NSMutableArray alloc] initWithCapacity:texturedTrianglesCount];
	for (NSUInteger i = 0; i < texturedTrianglesCount; i++)
		[_texturedTriangles addObject:[[TR1MeshFace alloc] initFromDataStream:stream inMesh:self corners:3 isTextured:YES]];
	
	NSUInteger texturedRectangleCount = [stream readUint16];
	_texturedRectangles = [[NSMutableArray alloc] initWithCapacity:texturedRectangleCount];
	for (NSUInteger i = 0; i < texturedRectangleCount; i++)
		[_texturedRectangles addObject:[[TR1MeshFace alloc] initFromDataStream:stream inMesh:self corners:4 isTextured:YES]];
	
	NSUInteger coloredTrianglesCount = [stream readUint16];
	_coloredTriangles = [[NSMutableArray alloc] initWithCapacity:coloredTrianglesCount];
	for (NSUInteger i = 0; i < coloredTrianglesCount; i++)
		[_coloredTriangles addObject:[[TR1MeshFace alloc] initFromDataStream:stream inMesh:self corners:3 isTextured:NO]];
	
	NSUInteger coloredRectangleCount = [stream readUint16];
	_coloredRectangles = [[NSMutableArray alloc] initWithCapacity:coloredRectangleCount];
	for (NSUInteger i = 0; i < coloredRectangleCount; i++)
		[_coloredRectangles addObject:[[TR1MeshFace alloc] initFromDataStream:stream inMesh:self corners:4 isTextured:NO]];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendInt16:self.collisionSphereX];
	[stream appendInt16:self.collisionSphereY];
	[stream appendInt16:self.collisionSphereZ];
	[stream appendUint16:self.collisionSphereRadius];
	
	[stream appendUint16:self.vertices.count];
	for (TR1MeshVertex *vertex in self.vertices)
		[vertex writeToStream:stream];
	
	if (self.usesInternalLighting)
	{
		[stream appendInt16:-self.vertices.count];
		for (NSNumber *intensity in self.lightIntensities)
			[stream appendUint16:intensity.unsignedShortValue];
	}
	else
	{
		[stream appendInt16:self.vertices.count];
		for (TR1MeshVertex *normal in self.normals)
			[normal writeToStream:stream];
	}
	
	[stream appendUint16:self.texturedTriangles.count];
	for (TR1MeshFace *face in self.texturedTriangles)
		[face writeToStream:stream];
	
	[stream appendUint16:self.texturedRectangles.count];
	for (TR1MeshFace *face in self.texturedRectangles)
		[face writeToStream:stream];
	
	[stream appendUint16:self.coloredTriangles.count];
	for (TR1MeshFace *face in self.coloredTriangles)
		[face writeToStream:stream];
	
	[stream appendUint16:self.coloredRectangles.count];
	for (TR1MeshFace *face in self.coloredRectangles)
		[face writeToStream:stream];
}

- (NSUInteger)number
{
	return [self.level indexOfMesh:self];
}

- (BOOL)usesInternalLighting
{
	return (self.lightIntensities != nil) && (self.normals == nil);
}

@end
