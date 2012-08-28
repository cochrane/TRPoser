//
//  TR4Mesh.m
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4Mesh.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"
#import "TR1Vertex.h"
#import "TR1Level.h"
#import "TR1MeshFace.h"

@implementation TR4Mesh

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	self.level = level;
	
	self.collisionSphereCenter = [[TR1Vertex alloc] initFromDataStream:stream];
	self.collisionSphereRadius = [stream readUint32];
	
	NSUInteger verticesCount = [stream readUint16];
	self.vertices = [[NSMutableArray alloc] initWithCapacity:verticesCount];
	for (NSUInteger i = 0; i < verticesCount; i++)
		[self.vertices addObject:[[TR1Vertex alloc] initFromDataStream:(TRInDataStream *)stream]];
	
	NSInteger normalCount = [stream readUint16];
	if (normalCount != (NSInteger) verticesCount)
	{
		// Use internal lighting: An array of values follows
		self.lightIntensities = [[NSMutableArray alloc] initWithCapacity:verticesCount];
		for (NSUInteger i = 0; i < verticesCount; i++)
			[self.lightIntensities addObject:@([stream readUint16])];
	}
	else
	{
		// External lighting: Read normal values
		self.normals = [[NSMutableArray alloc] initWithCapacity:verticesCount];
		for (NSUInteger i = 0; i < verticesCount; i++)
			[self.normals addObject:[[TR1Vertex alloc] initFromDataStream:stream]];
	}
	
	Class meshFaceClass = [self.level versionedClassForName:@"MeshFace"];
	
	NSUInteger texturedRectangleCount = [stream readUint16];
	self.texturedRectangles = [[NSMutableArray alloc] initWithCapacity:texturedRectangleCount];
	for (NSUInteger i = 0; i < texturedRectangleCount; i++)
		[self.texturedRectangles addObject:[[meshFaceClass alloc] initFromDataStream:stream inMesh:self corners:4 isTextured:YES]];
	
	NSUInteger texturedTrianglesCount = [stream readUint16];
	self.texturedTriangles = [[NSMutableArray alloc] initWithCapacity:texturedTrianglesCount];
	for (NSUInteger i = 0; i < texturedTrianglesCount; i++)
		[self.texturedTriangles addObject:[[meshFaceClass alloc] initFromDataStream:stream inMesh:self corners:3 isTextured:YES]];
		
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[self.collisionSphereCenter writeToStream:stream];
	[stream appendInt32:(int32_t) self.collisionSphereRadius];
	
	[stream appendUint16:self.vertices.count];
	for (TR1Vertex *vertex in self.vertices)
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
		for (TR1Vertex *normal in self.normals)
			[normal writeToStream:stream];
	}
	
	[stream appendUint16:self.texturedRectangles.count];
	for (TR1MeshFace *face in self.texturedRectangles)
		[face writeToStream:stream];
	
	[stream appendUint16:self.texturedTriangles.count];
	for (TR1MeshFace *face in self.texturedTriangles)
		[face writeToStream:stream];
	
	[stream appendUint16:self.coloredRectangles.count];
	for (TR1MeshFace *face in self.coloredRectangles)
		[face writeToStream:stream];
	
	[stream appendUint16:self.coloredTriangles.count];
	for (TR1MeshFace *face in self.coloredTriangles)
		[face writeToStream:stream];
}

@end
