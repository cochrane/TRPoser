//
//  TRRenderMesh.m
//  
//
//  Created by Torsten Kammer on 22.08.12.
//
//

#import "TRRenderMesh.h"

#import "TR1Level.h"
#import "TR1Mesh.h"
#import "TR1MeshFace.h"
#import "TR1Vertex.h"

#import "TRRenderElement.h"
#import "TRRenderLevelResources.h"
#import "TRRenderTexture.h"

@interface TRRenderMesh ()
{
	NSUInteger alphaTriangles;
	NSUInteger doublesidedTriangles;
}

@property (nonatomic, retain, readwrite) TR1Mesh *mesh;
@property (nonatomic, weak, readwrite) TRRenderLevelResources *resources;

- (void)fillElement:(TRRenderElement *)element fromTexturedFace:(TR1MeshFace *)face corner:(NSUInteger)corner;
- (void)fillElement:(TRRenderElement *)element fromColoredFace:(TR1MeshFace *)face corner:(NSUInteger)corner;

@end

@implementation TRRenderMesh

- (id)initWithMesh:(TR1Mesh *)mesh resources:(TRRenderLevelResources *)resources;
{
	if (!(self = [super init])) return nil;
	
	self.mesh = mesh;
	self.resources = resources;
	
	alphaTriangles = NSNotFound;
	doublesidedTriangles = NSNotFound;
	
	return self;
}

- (void)fillElement:(TRRenderElement *)element fromTexturedFace:(TR1MeshFace *)face corner:(NSUInteger)corner;
{
	NSUInteger index = [face.indices[corner] unsignedIntegerValue];
	TR1Vertex *vertex = self.mesh.vertices[index];
	element->position[0] = vertex.x / 1024.0f;
	element->position[1] = vertex.y / 1024.0f;
	element->position[2] = vertex.z / 1024.0f;
	
	[self.resources.renderTexture getTextureCoords:element->texCoord forTexture:face.texture corner:corner];
	
	if (self.mesh.usesInternalLighting)
	{
		NSNumber *value = self.mesh.lightIntensities[index];
		double lightValue = [self.mesh.level normalizeLightValue:value.unsignedIntegerValue];
		element->normalOrColor[0] = lightValue;
		element->normalOrColor[1] = lightValue;
		element->normalOrColor[2] = lightValue;
	}
	else
	{
		TR1Vertex *normal = self.mesh.normals[index];
		element->normalOrColor[0] = normal.x;
		element->normalOrColor[1] = normal.y;
		element->normalOrColor[2] = normal.z;
		float length = sqrtf(element->normalOrColor[0]*element->normalOrColor[0] +
							 element->normalOrColor[1]*element->normalOrColor[1] +
							 element->normalOrColor[2]*element->normalOrColor[2]);
		element->normalOrColor[0] /= length;
		element->normalOrColor[1] /= length;
		element->normalOrColor[2] /= length;
	}
}
- (void)fillElement:(TRRenderElement *)element fromColoredFace:(TR1MeshFace *)face corner:(NSUInteger)corner;
{
	NSUInteger index = [face.indices[corner] unsignedIntegerValue];
	TR1Vertex *vertex = self.mesh.vertices[index];
	element->position[0] = vertex.x / 1024.0f;
	element->position[1] = vertex.y / 1024.0f;
	element->position[2] = vertex.z / 1024.0f;
	
	[self.resources.renderTexture getTextureCoords:element->texCoord forColorIndex:face.colorIndex8];
	
	if (self.mesh.usesInternalLighting)
	{
		NSNumber *value = self.mesh.lightIntensities[index];
		double lightValue = [self.mesh.level normalizeLightValue:value.unsignedIntegerValue];
		element->normalOrColor[0] = lightValue;
		element->normalOrColor[1] = lightValue;
		element->normalOrColor[2] = lightValue;
	}
	else
	{
		TR1Vertex *normal = self.mesh.normals[index];
		element->normalOrColor[0] = normal.x;
		element->normalOrColor[1] = normal.y;
		element->normalOrColor[2] = normal.z;
		float length = sqrtf(element->normalOrColor[0]*element->normalOrColor[0] +
							 element->normalOrColor[1]*element->normalOrColor[1] +
							 element->normalOrColor[2]*element->normalOrColor[2]);
		element->normalOrColor[0] /= length;
		element->normalOrColor[1] /= length;
		element->normalOrColor[2] /= length;
	}
}

- (NSData *)createVertexDataVectorCount:(NSUInteger *)vectorCount;
{
	NSUInteger numVertices = self.mesh.coloredRectangles.count * 4 + self.mesh.coloredTriangles.count * 3 + self.mesh.texturedRectangles.count * 4 + self.mesh.texturedTriangles.count * 3;
	
	*vectorCount = numVertices;
	
	TRRenderElement *elements = malloc(sizeof(TRRenderElement) * numVertices);
	
	doublesidedTriangles = 0;
	alphaTriangles = 0;
		
	NSUInteger i = 0;
	for (TR1MeshFace *face in self.mesh.coloredRectangles)
	{
		if (face.isTwoSided) doublesidedTriangles += 2;
		if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 4 : 2;
		
		for (NSUInteger j = 0; j < 4; j++, i++)
			[self fillElement:&elements[i] fromColoredFace:face corner:j];
	}
	for (TR1MeshFace *face in self.mesh.coloredTriangles)
	{
		if (face.isTwoSided) doublesidedTriangles += 1;
		if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 2 : 1;
		
		for (NSUInteger j = 0; j < 3; j++, i++)
			[self fillElement:&elements[i] fromColoredFace:face corner:j];
	}
	for (TR1MeshFace *face in self.mesh.texturedRectangles)
	{
		if (face.isTwoSided) doublesidedTriangles += 2;
		if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 4 : 2;
		
		for (NSUInteger j = 0; j < 4; j++, i++)
			[self fillElement:&elements[i] fromTexturedFace:face corner:j];
	}
	for (TR1MeshFace *face in self.mesh.texturedTriangles)
	{
		if (face.isTwoSided) doublesidedTriangles += 1;
		if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 2 : 1;
		
		for (NSUInteger j = 0; j < 3; j++, i++)
			[self fillElement:&elements[i] fromTexturedFace:face corner:j];
	}
	
	return [NSData dataWithBytesNoCopy:elements length:sizeof(TRRenderElement) * numVertices freeWhenDone:YES];
}

- (NSData *)createElementsNormalCount:(NSUInteger *)normalCount alphaCount:(NSUInteger *)alphaCount;
{
	if (alphaTriangles == NSNotFound)
		[self createVertexDataVectorCount:NULL];
	
	NSUInteger triangleCount = self.mesh.coloredRectangles.count * 2 + self.mesh.coloredTriangles.count + self.mesh.texturedRectangles.count * 2 + self.mesh.texturedTriangles.count + doublesidedTriangles;
	NSUInteger standardTriangleCount = triangleCount - alphaTriangles;
	
	uint16_t *elements = malloc(sizeof(uint16_t) * triangleCount*3);
	uint16_t *standardElements = elements;
	uint16_t *alphaElements = &elements[standardTriangleCount*3];
	
	*normalCount = standardTriangleCount*3;
	*alphaCount = alphaTriangles*3;
	
	NSUInteger index = 0, element = 0;
	for (TR1MeshFace *face in self.mesh.coloredRectangles)
	{
		uint16_t *array = face.hasAlpha ? alphaElements : standardElements;
		array[element+0] = index + 0;
		array[element+1] = index + 2;
		array[element+2] = index + 1;
		array[element+3] = index + 2;
		array[element+4] = index + 0;
		array[element+5] = index + 3;
		element += 6;
		index += 4;
		
		if (face.isTwoSided)
		{
			array[element+0] = index + 0;
			array[element+1] = index + 1;
			array[element+2] = index + 2;
			array[element+3] = index + 2;
			array[element+4] = index + 3;
			array[element+5] = index + 0;
			element += 6;
			index += 4;
		}
	}
	for (TR1MeshFace *face in self.mesh.coloredTriangles)
	{
		uint16_t *array = face.hasAlpha ? alphaElements : standardElements;
		array[element+0] = index + 0;
		array[element+1] = index + 2;
		array[element+2] = index + 1;
		element += 3;
		index += 3;
		
		if (face.isTwoSided)
		{
			array[element+0] = index + 0;
			array[element+1] = index + 1;
			array[element+2] = index + 2;
			element += 3;
			index += 3;
		}
	}
	for (TR1MeshFace *face in self.mesh.texturedRectangles)
	{
		uint16_t *array = face.hasAlpha ? alphaElements : standardElements;
		array[element+0] = index + 0;
		array[element+1] = index + 2;
		array[element+2] = index + 1;
		array[element+3] = index + 3;
		array[element+4] = index + 2;
		array[element+5] = index + 0;
		element += 6;
		index += 4;
		
		if (face.isTwoSided)
		{
			array[element+0] = index + 0;
			array[element+1] = index + 1;
			array[element+2] = index + 2;
			array[element+3] = index + 2;
			array[element+4] = index + 3;
			array[element+5] = index + 0;
			element += 6;
			index += 4;
		}
	}
	for (TR1MeshFace *face in self.mesh.texturedTriangles)
	{
		uint16_t *array = face.hasAlpha ? alphaElements : standardElements;
		array[element+0] = index + 0;
		array[element+1] = index + 2;
		array[element+2] = index + 1;
		element += 3;
		index += 3;
		
		if (face.isTwoSided)
		{
			array[element+0] = index + 0;
			array[element+1] = index + 1;
			array[element+2] = index + 2;
			element += 3;
			index += 3;
		}
	}
	
	return [NSData dataWithBytesNoCopy:elements length:sizeof(uint16_t) * triangleCount*3 freeWhenDone:YES];
}

- (BOOL)internalLighting
{
	return self.mesh.usesInternalLighting;
}

@end
