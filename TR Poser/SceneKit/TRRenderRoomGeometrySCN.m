//
//  TRRenderRoomGeometry.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderRoomGeometrySCN.h"

#import "TR1Room.h"

#import "TRRenderLevelResourcesSCN.h"
#import "TRRenderElement.h"

@interface TRRenderRoomGeometrySCN ()
{
	SCNGeometry *geometry;
}

@end

@implementation TRRenderRoomGeometrySCN

- (SCNGeometry *)roomGeometry
{
	if (geometry) return geometry;
	
	NSUInteger numVertices;
	NSData *vertices = [self createVertexDataVectorCount:&numVertices];
	
	NSMutableArray *sources = [[NSMutableArray alloc] initWithCapacity:3];
	
	[sources addObject:[SCNGeometrySource geometrySourceWithData:vertices
														semantic:SCNGeometrySourceSemanticVertex
													 vectorCount:numVertices
												 floatComponents:YES
											 componentsPerVector:3
											   bytesPerComponent:sizeof(float)
													  dataOffset:offsetof(TRRenderElement, position)
													  dataStride:sizeof(TRRenderElement)]];
	[sources addObject:[SCNGeometrySource geometrySourceWithData:vertices
														semantic:SCNGeometrySourceSemanticTexcoord
													 vectorCount:numVertices
												 floatComponents:YES
											 componentsPerVector:2
											   bytesPerComponent:sizeof(float)
													  dataOffset:offsetof(TRRenderElement, texCoord)
													  dataStride:sizeof(TRRenderElement)]];
	[sources addObject:[SCNGeometrySource geometrySourceWithData:vertices
														semantic:SCNGeometrySourceSemanticColor
													 vectorCount:numVertices
												 floatComponents:YES
											 componentsPerVector:3
											   bytesPerComponent:sizeof(float)
													  dataOffset:offsetof(TRRenderElement, normalOrColor)
													  dataStride:sizeof(TRRenderElement)]];
	
	NSUInteger opaqueCount, alphaCount;
	NSData *indices = [self createElementsNormalCount:&opaqueCount alphaCount:&alphaCount];
	
	NSMutableArray *elements = [[NSMutableArray alloc] initWithCapacity:2];
	[elements addObject:[SCNGeometryElement geometryElementWithData:[indices subdataWithRange:NSMakeRange(0,
																										  opaqueCount*sizeof(uint16_t))]
													  primitiveType:SCNGeometryPrimitiveTypeTriangles
													 primitiveCount:opaqueCount/3
													  bytesPerIndex:2]];
	if (alphaCount > 0)
		[elements addObject:[SCNGeometryElement geometryElementWithData:[indices subdataWithRange:NSMakeRange(opaqueCount*sizeof(uint16_t),
																											  alphaCount*sizeof(uint16_t))]
														  primitiveType:SCNGeometryPrimitiveTypeTriangles
														 primitiveCount:alphaCount/3
														  bytesPerIndex:2]];
	
	geometry = [SCNGeometry geometryWithSources:sources elements:elements];
	TRRenderLevelResourcesSCN *scnResources = (TRRenderLevelResourcesSCN *) self.resources;
	
	[geometry insertMaterial:scnResources.meshInternalLightingMaterial atIndex:0];
	
	if (alphaCount > 0)
		[geometry insertMaterial:scnResources.meshAlphaInternalLightingMaterial atIndex:1];
	
	return geometry;
}

- (SCNVector3)offset
{
	return SCNVector3Make(self.room.x / 1024.0,
						  0.0,
						  self.room.z / 1024.0);
}

@end
