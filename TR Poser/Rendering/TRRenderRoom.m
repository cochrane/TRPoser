//
//  TRRenderRoom.m
//  TR Poser
//
//  Created by Torsten Kammer on 21.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderRoom.h"

#import "TR1Room.h"
#import "TR1RoomFace.h"
#import "TR1MeshFace+TRRenderCategories.h"
#import "TR1StaticMesh.h"
#import "TR1StaticMeshInstance.h"
#import "TRRenderLevel.h"
#import "TRRenderMesh.h"

@interface TRRenderRoom ()
{
	SCNGeometry *roomGeometry;
}

@end

@implementation TRRenderRoom

- (id)initWithRoom:(TR1Room *)room inRenderLevel:(TRRenderLevel *)level;
{
	if (!(self = [super init])) return nil;
	
	_room = room;
	_level = level;
	
	return self;
}

- (SCNGeometry *)roomGeometry;
{
	if (!roomGeometry)
	{
		NSUInteger numVertices = self.room.rectangles.count * 4 + self.room.triangles.count * 3;
		
		// Setup geometry sources
		
		CGPoint *textureCoords = malloc(sizeof(CGPoint) * numVertices);
		SCNVector3 *positions = malloc(sizeof(SCNVector3) * numVertices);
		SCNVector3 *colors = malloc(sizeof(SCNVector3) * numVertices);
		
		NSUInteger doublesidedTriangles = 0;
		NSUInteger alphaTriangles = 0;
		
		NSUInteger i = 0;
		for (TR1RoomFace *face in self.room.rectangles)
		{
			if (face.isTwoSided) doublesidedTriangles += 2;
			if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 4 : 2;
			
			CGPoint faceTexCoords[4];
			[self.level getTextureCoords:faceTexCoords forObjectTexture:face.texture];
			
			for (NSUInteger j = 0; j < 4; j++, i++)
			{
				textureCoords[i] = faceTexCoords[j];
				positions[i] = [face positionAtCorner:j];
				colors[i] = [face lightAtCorner:j];
			}
		}
		for (TR1RoomFace *face in self.room.triangles)
		{
			if (face.isTwoSided) doublesidedTriangles += 1;
			if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 2 : 1;
			
			CGPoint faceTexCoords[4];
			[self.level getTextureCoords:faceTexCoords forObjectTexture:face.texture];
			
			for (NSUInteger j = 0; j < 3; j++, i++)
			{
				textureCoords[i] = faceTexCoords[j];
				positions[i] = [face positionAtCorner:j];
				colors[i] = [face lightAtCorner:j];
			}
		}
		
		SCNGeometrySource *positionSource = [SCNGeometrySource geometrySourceWithData:[NSData dataWithBytesNoCopy:positions length:numVertices*sizeof(SCNVector3)]
																			 semantic:SCNGeometrySourceSemanticVertex
																		  vectorCount:numVertices
																	  floatComponents:YES
																  componentsPerVector:3
																	bytesPerComponent:sizeof(CGFloat)
																		   dataOffset:0
																		   dataStride:0];
		SCNGeometrySource *texCoordSource = [SCNGeometrySource geometrySourceWithData:[NSData dataWithBytesNoCopy:textureCoords length:numVertices*sizeof(CGPoint)]
																			 semantic:SCNGeometrySourceSemanticTexcoord
																		  vectorCount:numVertices
																	  floatComponents:YES
																  componentsPerVector:2
																	bytesPerComponent:sizeof(CGFloat)
																		   dataOffset:0
																		   dataStride:0];
		SCNGeometrySource *colorsSource = [SCNGeometrySource geometrySourceWithData:[NSData dataWithBytesNoCopy:colors length:numVertices*sizeof(SCNVector3)]
																					semantic:SCNGeometrySourceSemanticColor
																				 vectorCount:numVertices
																			 floatComponents:YES
																		 componentsPerVector:3
																		   bytesPerComponent:sizeof(CGFloat)
																				  dataOffset:0
																				  dataStride:0];
		
		// Setup geometry elements
		NSUInteger triangleCount = self.room.rectangles.count * 2 + self.room.triangles.count * 1;
		NSUInteger standardTriangleCount = triangleCount - alphaTriangles;
		
		uint16_t *standardElements = (uint16_t *) malloc(sizeof(uint16_t) * standardTriangleCount * 3);
		uint16_t *alphaElements = (alphaTriangles > 0) ? malloc(sizeof(NSUInteger) * alphaTriangles * 3) : NULL;
		
		NSUInteger index = 0, element = 0;
		for (TR1MeshFace *face in self.room.rectangles)
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
		for (TR1MeshFace *face in self.room.triangles)
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
		
		SCNGeometryElement *standardElement = [SCNGeometryElement geometryElementWithData:[NSData dataWithBytesNoCopy:standardElements
																											   length:sizeof(uint16_t) * 3 * standardTriangleCount]
																			primitiveType:SCNGeometryPrimitiveTypeTriangles
																		   primitiveCount:standardTriangleCount
																			bytesPerIndex:sizeof(uint16_t)];
		SCNGeometryElement *alphaElement = (alphaTriangles > 0) ? [SCNGeometryElement geometryElementWithData:[NSData dataWithBytesNoCopy:alphaElements
																																   length:sizeof(uint16_t) * 3 * standardTriangleCount]
																								primitiveType:SCNGeometryPrimitiveTypeTriangles
																							   primitiveCount:alphaTriangles
																								bytesPerIndex:sizeof(uint16_t)] : nil;
		
		NSMutableArray *sources = [[NSMutableArray alloc] initWithCapacity:3];
		[sources addObject:positionSource];
		[sources addObject:texCoordSource];
		[sources addObject:colorsSource];
		
		NSMutableArray *elements = [[NSMutableArray alloc] initWithCapacity:2];
		[elements addObject:standardElement];
		if (alphaElement) [elements addObject:alphaElement];
		
		SCNGeometry *geometry = [SCNGeometry geometryWithSources:sources elements:elements];
		
		[geometry insertMaterial:self.level.meshInternalLightingMaterial atIndex:0];
		
		if (alphaElement > 0)
			[geometry insertMaterial:self.level.meshAlphaInternalLightingMaterial atIndex:1];
		
		roomGeometry = geometry;
	}
	return roomGeometry;
}

- (SCNNode *)createNodeWithStaticGeometry;
{
	SCNNode *node = [SCNNode nodeWithGeometry:self.roomGeometry];
	
	for (TR1StaticMeshInstance *instance in self.room.staticMeshes)
	{
		TR1StaticMesh *staticMesh = instance.mesh;
		TRRenderMesh *mesh = [self.level.meshes objectAtIndex:staticMesh.meshIndex];
		
		SCNVector3 offset = SCNVector3Make((CGFloat) (instance.x - self.room.x) / 1024.0, (CGFloat) instance.y / 1024.0, (CGFloat) (instance.z - self.room.z) / 1024.0);
		
		SCNNode *meshNode = [SCNNode nodeWithGeometry:mesh.meshGeometry];
		meshNode.position = offset;
		meshNode.rotation = SCNVector4Make(0.0, 1.0, 0.0, instance.rotationInRad);
		
		[node addChildNode:meshNode];
	}
	return node;
}

@end
