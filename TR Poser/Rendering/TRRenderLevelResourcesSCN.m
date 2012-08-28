//
//  TRRenderLevel.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderLevelResourcesSCN.h"

#import <Accelerate/Accelerate.h>

#import "TRRenderMeshSCN.h"
#import "TRRenderMoveableDescription.h"
#import "TRRenderRoomGeometrySCN.h"
#import "TRRenderLevelSCN.h"
#import "TRRenderTexture.h"
#import "TRTexturePage.h"
#import "TR1Level.h"
#import "TR1MeshPointer.h"
#import "TR1Moveable.h"
#import "TR1Palette8.h"
#import "TR1Texture.h"
#import "TR1TextureVertex.h"

@interface TRRenderLevelResourcesSCN ()
{
	CGImageRef textureImage;
}

@property (nonatomic, copy, readwrite) NSArray *meshes;
@property (nonatomic, copy, readwrite) NSArray *rooms;
@property (nonatomic, copy, readwrite) NSDictionary *moveablesByObjectID;

@property (nonatomic, readwrite, retain) SCNMaterial *meshInternalLightingMaterial;
@property (nonatomic, readwrite, retain) SCNMaterial *meshExternalLightingMaterial;
@property (nonatomic, readwrite, retain) SCNMaterial *meshAlphaInternalLightingMaterial;
@property (nonatomic, readwrite, retain) SCNMaterial *meshAlphaExternalLightingMaterial;

- (void)setupMaterials;
- (void)setupMeshes;
- (void)setupRooms;
- (void)setupMoveables;

@end

@implementation TRRenderLevelResourcesSCN

@synthesize textureImage=textureImage;

- (id)initWithLevel:(TR1Level *)aLevel;
{
	if (!(self = [super initWithLevel:aLevel])) return nil;
	
	[self setupMaterials];
	[self setupMeshes];
	[self setupRooms];
	[self setupMoveables];
	
	return self;
}

- (void)dealloc
{
	if (textureImage)
		CGImageRelease(textureImage);
}

- (void)setupMaterials
{
	self.meshInternalLightingMaterial = [SCNMaterial material];
	self.meshInternalLightingMaterial.diffuse.contents = (__bridge id) self.textureImage;
	self.meshInternalLightingMaterial.diffuse.minificationFilter = SCNLinearFiltering;
	self.meshInternalLightingMaterial.diffuse.magnificationFilter = SCNLinearFiltering;
	self.meshInternalLightingMaterial.diffuse.mipFilter = SCNLinearFiltering;
	self.meshInternalLightingMaterial.diffuse.wrapS = SCNRepeat;
	self.meshInternalLightingMaterial.diffuse.wrapT = SCNRepeat;
	self.meshInternalLightingMaterial.lightingModelName = SCNLightingModelConstant;
	self.meshInternalLightingMaterial.ambient.contents = [NSColor clearColor];
	
	self.meshExternalLightingMaterial = [SCNMaterial material];
	self.meshExternalLightingMaterial.ambient.contents = [NSColor whiteColor];
	self.meshExternalLightingMaterial.diffuse.contents = (__bridge id) self.textureImage;
	self.meshExternalLightingMaterial.diffuse.minificationFilter = SCNLinearFiltering;
	self.meshExternalLightingMaterial.diffuse.magnificationFilter = SCNLinearFiltering;
	self.meshExternalLightingMaterial.diffuse.mipFilter = SCNLinearFiltering;
	self.meshExternalLightingMaterial.diffuse.wrapS = SCNRepeat;
	self.meshExternalLightingMaterial.diffuse.wrapT = SCNRepeat;
	self.meshExternalLightingMaterial.lightingModelName = SCNLightingModelLambert;
	self.meshExternalLightingMaterial.locksAmbientWithDiffuse = YES;
	
	self.meshAlphaExternalLightingMaterial = [self.meshExternalLightingMaterial copy];
	self.meshAlphaExternalLightingMaterial.transparencyMode = SCNTransparencyModeRGBZero;
	
	self.meshAlphaInternalLightingMaterial = [self.meshInternalLightingMaterial copy];
	self.meshAlphaInternalLightingMaterial.transparencyMode = SCNTransparencyModeRGBZero;
}

- (void)setupMeshes
{
	NSMutableArray *meshes = [[NSMutableArray alloc] initWithCapacity:self.level.meshPointers.count];
	
	for (TR1MeshPointer *meshPointer in self.level.meshPointers)
	{
		TRRenderMeshSCN *renderMesh = [[TRRenderMeshSCN alloc] initWithMesh:meshPointer.mesh resources:self];
		[meshes addObject:renderMesh];
	}
	
	self.meshes = meshes;
}
- (void)setupRooms
{
	NSMutableArray *rooms = [[NSMutableArray alloc] initWithCapacity:self.level.rooms.count];
	
	for (TR1Room *room in self.level.rooms)
	{
		TRRenderRoomGeometrySCN *renderRoom = [[TRRenderRoomGeometrySCN alloc] initWithRoom:room resources:self];
		[rooms addObject:renderRoom];
	}
	
	self.rooms = rooms;
}
- (void)setupMoveables;
{
	NSMutableDictionary *moveables = [[NSMutableDictionary alloc] initWithCapacity:self.level.moveables.count];
	
	for (TR1Moveable *moveable in self.level.moveables)
	{
		TRRenderMoveableDescription *description = [[TRRenderMoveableDescription alloc] initWithMoveable:moveable inRenderLevel:self];
		
		[moveables setObject:description forKey:@(moveable.objectID)];
	}
	
	self.moveablesByObjectID = moveables;
}
- (CGImageRef)textureImage
{
	if (textureImage == NULL)
	{
		NSData *image = [self.renderTexture create32BitData];
		CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef) image);
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		
		textureImage = CGImageCreate(self.renderTexture.width,
									 self.renderTexture.height,
									 8, 32,
									 self.renderTexture.width * 4,
									 colorSpace,
									 kCGImageAlphaFirst,
									 dataProvider,
									 NULL,
									 YES,
									 kCGRenderingIntentDefault);
		
		CGDataProviderRelease(dataProvider);
		CGColorSpaceRelease(colorSpace);
	}
	return textureImage;
}

- (void)getTextureCoords:(CGPoint *)fourPoints forObjectTexture:(TR1Texture *)texture;
{
	NSUInteger i = 0;
	for (TR1TextureVertex *vertex in texture.vertices)
	{
		float coords[2];
		[self.renderTexture getTextureCoords:coords forTexture:texture corner:i];
		
		fourPoints[i++] = CGPointMake(coords[0], coords[1]);
	}
}

- (CGPoint)textureCoordsForColorIndex:(NSUInteger)colorIndex;
{
	float coords[2];
	[self.renderTexture getTextureCoords:coords forColorIndex:colorIndex];
	return CGPointMake(coords[0], coords[1]);
}

- (TRRenderLevelSCN *)createRenderLevel;
{
	return [[TRRenderLevelSCN alloc] initWithResources:self];
}

- (NSArray *)moveables
{
	return self.moveablesByObjectID.allValues;
}

- (TRRenderMoveableDescription *)moveableForObjectID:(NSUInteger)objectID;
{
	return [self.moveablesByObjectID objectForKey:@(objectID)];
}

@end
