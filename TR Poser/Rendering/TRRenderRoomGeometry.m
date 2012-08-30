//
//  TRRenderRoomGeometry.m
//  
//
//  Created by Torsten Kammer on 23.08.12.
//
//

#import "TRRenderRoomGeometry.h"

#import "TR1Room.h"
#import "TR1RoomFace.h"
#import "TR1RoomVertex.h"
#import "TR1Vertex.h"

#import "TRRenderElement.h"
#import "TRRenderLevelResources.h"
#import "TRRenderTexture.h"
#import "TRRenderIndexUtilities.h"

@interface TRRenderRoomGeometry ()
{
	NSUInteger doublesidedTriangles;
	NSUInteger alphaTriangles;
}

- (void)fillElement:(TRRenderElement *)element fromTexturedFace:(TR1RoomFace *)face corner:(NSUInteger)corner;

@end

@implementation TRRenderRoomGeometry

- (id)initWithRoom:(TR1Room *)room resources:(TRRenderLevelResources *)resources;
{
	if (!(self = [super init])) return nil;
	
	_room = room;
	_resources = resources;
	
	doublesidedTriangles = NSNotFound;
	alphaTriangles = NSNotFound;
	
	return self;
}

- (void)fillElement:(TRRenderElement *)element fromTexturedFace:(TR1RoomFace *)face corner:(NSUInteger)corner;
{
	NSUInteger index = [face.indices[corner] unsignedIntegerValue];
	TR1RoomVertex *vertex = self.room.vertices[index];
	element->position[0] = vertex.position.x / 1024.0f;
	element->position[1] = vertex.position.y / 1024.0f;
	element->position[2] = vertex.position.z / 1024.0f;
	
	[self.resources.renderTexture getTextureCoords:element->texCoord forTexture:face.texture corner:corner];
	
	NSColor *lightColor = vertex.color;
	NSColor *rgbLightColor = [lightColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
	CGFloat r, g, b;
	[rgbLightColor getRed:&r green:&g blue:&b alpha:NULL];
	element->normalOrColor[0] = r;
	element->normalOrColor[1] = g;
	element->normalOrColor[2] = b;
}

- (NSData *)createVertexDataVectorCount:(NSUInteger *)vectorCount;
{
	NSUInteger numVertices = self.room.rectangles.count * 4 + self.room.triangles.count * 3;
	
	*vectorCount = numVertices;
	
	TRRenderElement *elements = malloc(sizeof(TRRenderElement) * numVertices);
	
	doublesidedTriangles = 0;
	alphaTriangles = 0;
	
	NSUInteger i = 0;
	for (TR1RoomFace *face in self.room.rectangles)
	{
		if (face.isTwoSided) doublesidedTriangles += 2;
		if (face.hasAlpha) alphaTriangles += face.isTwoSided ? 4 : 2;
		
		for (NSUInteger j = 0; j < 4; j++, i++)
			[self fillElement:&elements[i] fromTexturedFace:face corner:j];
	}
	for (TR1RoomFace *face in self.room.triangles)
	{
		if (face.isTwoSided) doublesidedTriangles += 1;
		if (face.hasAlpha) alphaTriangles += face.isTwoSided ? 2 : 1;
		
		for (NSUInteger j = 0; j < 3; j++, i++)
			[self fillElement:&elements[i] fromTexturedFace:face corner:j];
	}
	
	return [NSData dataWithBytesNoCopy:elements length:sizeof(TRRenderElement) * numVertices freeWhenDone:YES];
}

- (NSData *)createElementsNormalCount:(NSUInteger *)normalCount alphaCount:(NSUInteger *)alphaCount;
{
	if (alphaTriangles == NSNotFound)
		[self createVertexDataVectorCount:NULL];
	
	NSUInteger triangleCount = self.room.rectangles.count * 2 + self.room.triangles.count + doublesidedTriangles;
	NSUInteger standardTriangleCount = triangleCount - alphaTriangles;
	
	uint16_t *elements = malloc(sizeof(uint16_t) * triangleCount*3);
	uint16_t *standardElements = elements;
	uint16_t *alphaElements = &elements[standardTriangleCount*3];
	
	*normalCount = standardTriangleCount*3;
	*alphaCount = alphaTriangles*3;
	
	NSUInteger index = 0, element = 0, alphaElement = 0;
	for (TR1RoomFace *face in self.room.rectangles)
	{
		if (face.hasAlpha)
			TRFillRectangle(alphaElements, &alphaElement, &index, face.isTwoSided);
		else
			TRFillRectangle(standardElements, &element, &index, face.isTwoSided);
	}
	for (TR1RoomFace *face in self.room.triangles)
	{
		if (face.hasAlpha)
			TRFillTriangle(alphaElements, &alphaElement, &index, face.isTwoSided);
		else
			TRFillTriangle(standardElements, &element, &index, face.isTwoSided);
	}
	
	return [NSData dataWithBytesNoCopy:elements length:sizeof(uint16_t) * triangleCount*3 freeWhenDone:YES];
}

@end
