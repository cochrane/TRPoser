//
//  TRRenderMesh.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderMesh.h"

#import "TR1Mesh.h"
#import "TR1MeshFace.h"
#import "TRRenderLevel.h"
#import "TR1MeshFace+TRRenderCategories.h"

@interface TRRenderMesh ()

@property (nonatomic, retain, readwrite) TR1Mesh *mesh;
@property (nonatomic, weak, readwrite) TRRenderLevel *level;
@property (nonatomic, retain) SCNGeometry *geometry;

@end

@implementation TRRenderMesh

- (id)initWithMesh:(TR1Mesh *)mesh inRenderLevel:(TRRenderLevel *)level;
{
	if (!(self = [super init])) return nil;
	
	self.mesh = mesh;
	self.level = level;
	
	return self;
}

- (SCNGeometry *)meshGeometry;
{
	if (!self.geometry)
	{
		NSUInteger numVertices = self.mesh.coloredRectangles.count * 4 + self.mesh.coloredTriangles.count * 3 + self.mesh.texturedRectangles.count * 4 + self.mesh.texturedTriangles.count * 3;
		
		// Setup geometry sources
		
		CGPoint *textureCoords = malloc(sizeof(CGPoint) * numVertices);
		SCNVector3 *positions = malloc(sizeof(SCNVector3) * numVertices);
		SCNVector3 *normals = self.mesh.usesInternalLighting ? NULL : malloc(sizeof(SCNVector3) * numVertices);
		SCNVector3 *colors = self.mesh.usesInternalLighting ? malloc(sizeof(SCNVector3) * numVertices) : NULL;
		
		NSUInteger coloredRectanglesStart = 0;
		NSUInteger coloredTrianglesStart = 0;
		NSUInteger texturedRectanglesStart = 0;
		NSUInteger texturedTrianglesStart = 0;
		
		NSUInteger doublesidedTriangles = 0;
		NSUInteger alphaTriangles = 0;
		
		NSUInteger i = 0;
		coloredRectanglesStart = i;
		for (TR1MeshFace *face in self.mesh.coloredRectangles)
		{
			if (face.isTwoSided) doublesidedTriangles += 2;
			if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 4 : 2;
			
			for (NSUInteger j = 0; j < 4; j++, i++)
			{
				textureCoords[i] = [self.level textureCoordsForColorIndex:face.colorIndex8];
				positions[i] = [face positionAtCorner:j];
				
				if (normals)
					normals[i] = [face normalAtCorner:j];
				else
					colors[i] = [face lightAtCorner:j];
			}
		}
		coloredTrianglesStart = i;
		for (TR1MeshFace *face in self.mesh.coloredTriangles)
		{
			if (face.isTwoSided) doublesidedTriangles += 1;
			if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 2 : 1;
			
			for (NSUInteger j = 0; j < 3; j++, i++)
			{
				textureCoords[i] = [self.level textureCoordsForColorIndex:face.colorIndex8];
				positions[i] = [face positionAtCorner:j];
				
				if (normals)
					normals[i] = [face normalAtCorner:j];
				else
					colors[i] = [face lightAtCorner:j];
			}
		}
		texturedRectanglesStart = i;
		for (TR1MeshFace *face in self.mesh.texturedRectangles)
		{
			if (face.isTwoSided) doublesidedTriangles += 2;
			if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 4 : 2;
			
			CGPoint faceTexCoords[4];
			[self.level getTextureCoords:faceTexCoords forObjectTexture:face.texture];
			
			for (NSUInteger j = 0; j < 4; j++, i++)
			{
				textureCoords[i] = faceTexCoords[j];
				positions[i] = [face positionAtCorner:j];
				
				if (normals)
					normals[i] = [face normalAtCorner:j];
				else
					colors[i] = [face lightAtCorner:j];
			}
		}
		texturedTrianglesStart = i;
		for (TR1MeshFace *face in self.mesh.texturedTriangles)
		{
			if (face.isTwoSided) doublesidedTriangles += 1;
			if (face.hasAlpha) doublesidedTriangles += face.isTwoSided ? 2 : 1;
			
			CGPoint faceTexCoords[4];
			[self.level getTextureCoords:faceTexCoords forObjectTexture:face.texture];
			
			for (NSUInteger j = 0; j < 3; j++, i++)
			{
				textureCoords[i] = faceTexCoords[j];
				positions[i] = [face positionAtCorner:j];
				
				if (normals)
					normals[i] = [face normalAtCorner:j];
				else
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
		SCNGeometrySource *normalsSource = normals ? nil : [SCNGeometrySource geometrySourceWithData:[NSData dataWithBytesNoCopy:normals length:numVertices*sizeof(SCNVector3)]
																							semantic:SCNGeometrySourceSemanticNormal
																						 vectorCount:numVertices
																					 floatComponents:YES
																				 componentsPerVector:3
																				   bytesPerComponent:sizeof(CGFloat)
																						  dataOffset:0
																						  dataStride:0];
		SCNGeometrySource *colorsSource = colors ? [SCNGeometrySource geometrySourceWithData:[NSData dataWithBytesNoCopy:colors length:numVertices*sizeof(SCNVector3)]
																					semantic:SCNGeometrySourceSemanticColor
																				 vectorCount:numVertices
																			 floatComponents:YES
																		 componentsPerVector:3
																		   bytesPerComponent:sizeof(CGFloat)
																				  dataOffset:0
																				  dataStride:0] : nil;
		
		// Setup geometry elements
		NSUInteger triangleCount = self.mesh.coloredRectangles.count * 2 + self.mesh.coloredTriangles.count + self.mesh.texturedRectangles.count * 2 + self.mesh.texturedTriangles.count + doublesidedTriangles;
		NSUInteger standardTriangleCount = triangleCount - alphaTriangles;
		
		uint16_t *standardElements = malloc(sizeof(NSUInteger) * standardTriangleCount * 3);
		uint16_t *alphaElements = (alphaTriangles > 0) ? malloc(sizeof(NSUInteger) * alphaTriangles * 3) : NULL;
		
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
		if (normalsSource) [sources addObject:normalsSource];
		else if (colorsSource) [sources addObject:colorsSource];
		
		NSMutableArray *elements = [[NSMutableArray alloc] initWithCapacity:2];
		[elements addObject:standardElement];
		if (alphaElement) [elements addObject:alphaElement];
		
		SCNGeometry *geometry = [SCNGeometry geometryWithSources:sources elements:elements];
		
		if (self.mesh.usesInternalLighting)
			[geometry insertMaterial:self.level.meshInternalLightingMaterial atIndex:0];
		else
			[geometry insertMaterial:self.level.meshExternalLightingMaterial atIndex:0];
		
		if (alphaElement > 0)
		{
			if (self.mesh.usesInternalLighting)
				[geometry insertMaterial:self.level.meshAlphaInternalLightingMaterial atIndex:1];
			else
				[geometry insertMaterial:self.level.meshAlphaExternalLightingMaterial atIndex:1];
		}
		
		self.geometry = geometry;
	}
	return self.geometry;
}


@end
