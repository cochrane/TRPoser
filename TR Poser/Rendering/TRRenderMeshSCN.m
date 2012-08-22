//
//  TRRenderMesh.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderMeshSCN.h"

#import "TR1Mesh.h"
#import "TR1MeshFace.h"
#import "TRRenderLevelResourcesSCN.h"
#import "TRRenderCategoriesSCN.h"

@interface TRRenderMeshSCN ()
{
	SCNGeometry *geometry;
}

@end

@implementation TRRenderMeshSCN

- (SCNGeometry *)meshGeometry
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
													  dataOffset:0
													  dataStride:sizeof(float [8])]];
	[sources addObject:[SCNGeometrySource geometrySourceWithData:vertices
														semantic:SCNGeometrySourceSemanticTexcoord
													 vectorCount:numVertices
												 floatComponents:YES
											 componentsPerVector:2
											   bytesPerComponent:sizeof(float)
													  dataOffset:sizeof(float [6])
													  dataStride:sizeof(float [8])]];
	if (self.internalLighting)
		[sources addObject:[SCNGeometrySource geometrySourceWithData:vertices
															semantic:SCNGeometrySourceSemanticColor
														 vectorCount:numVertices
													 floatComponents:YES
												 componentsPerVector:3
												   bytesPerComponent:sizeof(float)
														  dataOffset:sizeof(float [6])
														  dataStride:sizeof(float [8])]];
	else
		[sources addObject:[SCNGeometrySource geometrySourceWithData:vertices
															semantic:SCNGeometrySourceSemanticNormal
														 vectorCount:numVertices
													 floatComponents:YES
												 componentsPerVector:3
												   bytesPerComponent:sizeof(float)
														  dataOffset:sizeof(float [6])
														  dataStride:sizeof(float [8])]];
	
	NSUInteger opaqueCount, alphaCount;
	NSData *indices = [self createElementsNormalCount:&opaqueCount alphaCount:&alphaCount];
	
	NSMutableArray *elements = [[NSMutableArray alloc] initWithCapacity:2];
	[elements addObject:[SCNGeometryElement geometryElementWithData:[indices subdataWithRange:NSMakeRange(0,
																										   opaqueCount*sizeof(uint16_t))]
													  primitiveType:SCNGeometryPrimitiveTypeTriangles
													 primitiveCount:opaqueCount*3
													  bytesPerIndex:2]];
	if (alphaCount > 0)
		[elements addObject:[SCNGeometryElement geometryElementWithData:[indices subdataWithRange:NSMakeRange(opaqueCount*sizeof(uint16_t),
																											   alphaCount*sizeof(uint16_t))]
														  primitiveType:SCNGeometryPrimitiveTypeTriangles
														 primitiveCount:opaqueCount*3
														  bytesPerIndex:2]];
	
	geometry = [SCNGeometry geometryWithSources:sources elements:elements];
	TRRenderLevelResourcesSCN *scnResources = (TRRenderLevelResourcesSCN *) self.resources;
	
	if (self.mesh.usesInternalLighting)
		[geometry insertMaterial:scnResources.meshInternalLightingMaterial atIndex:0];
	else
		[geometry insertMaterial:scnResources.meshExternalLightingMaterial atIndex:0];
	
	if (alphaCount > 0)
	{
		if (self.mesh.usesInternalLighting)
			[geometry insertMaterial:scnResources.meshAlphaInternalLightingMaterial atIndex:1];
		else
			[geometry insertMaterial:scnResources.meshAlphaExternalLightingMaterial atIndex:1];
	}
	
	return geometry;
}

@end
