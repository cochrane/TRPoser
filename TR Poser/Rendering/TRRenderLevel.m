//
//  TRRenderLevel.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderLevel.h"

#import <Accelerate/Accelerate.h>

#import "TRRenderMesh.h"
#import "TRTexturePage.h"
#import "TR1Level.h"
#import "TR1MeshPointer.h"
#import "TR1Palette8.h"
#import "TR1Texture.h"
#import "TR1TextureVertex.h"

@interface TRRenderLevel ()
{
	BOOL usePalettePage;
	CGImageRef textureImage;
	NSUInteger pagesWide;
	NSUInteger pagesHigh;
}

@property (nonatomic, copy, readwrite) NSArray *meshes;

@property (nonatomic, readwrite, retain) SCNMaterial *meshInternalLightingMaterial;
@property (nonatomic, readwrite, retain) SCNMaterial *meshExternalLightingMaterial;
@property (nonatomic, readwrite, retain) SCNMaterial *meshAlphaInternalLightingMaterial;
@property (nonatomic, readwrite, retain) SCNMaterial *meshAlphaExternalLightingMaterial;

- (void)setupTexture;
- (void)setupMaterials;
- (void)setupMeshes;

@end

@implementation TRRenderLevel

@synthesize textureImage=textureImage;

- (id)initWithLevel:(TR1Level *)aLevel;
{
	if (!(self = [super init])) return nil;
	
	self.level = aLevel;
	[self setupTexture];
	[self setupMaterials];
	[self setupMeshes];
	
	return self;
}

- (void)dealloc
{
	CGImageRelease(textureImage);
}

- (void)setupTexture;
{
	NSMutableArray *texturePages32 = [[NSMutableArray alloc] initWithCapacity:self.level.textureTiles8.count];
	if (self.level.palette8)
	{
		usePalettePage = YES;
		[texturePages32 addObject:[self.level.palette8 asTexturePage]];
	}
	
	for (TRTexturePage *page in [self.level valueForKey:@"textureTiles"])
		[texturePages32 addObject:[page pixels32Bit]];

	pagesWide = sqrt((double) texturePages32.count);
	pagesHigh = ceil( (double) texturePages32.count / (double) pagesWide);

	const NSUInteger rowBytes = pagesWide * 256 * 4;
	const NSUInteger pageRowBytes = rowBytes * 256;
	const NSUInteger pageColumnBytes = 256*4;

	uint8_t *result = calloc(pagesHigh*pagesWide, 256*256*4);
	for (NSUInteger row = 0, i = 0; row < pagesHigh; row++)
	{
		for (NSUInteger col = 0; col < pagesWide; col++, i++)
		{
			if (i >= texturePages32.count) break;
			
			uint8_t *output = &(result[row*pageRowBytes + col*pageColumnBytes]);
			const uint8_t *original = [texturePages32[i] bytes];
			
			for (NSUInteger j = 0; j < 256; j++)
				memcpy(&(output[j*rowBytes]), &(original[j*256*4]), 256*4);
		}
	}
	CFDataRef imageData = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, result, pagesHigh*pagesWide*256*256*4, kCFAllocatorMalloc);
	CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(imageData);
	CFRelease(imageData);
	CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
	
	textureImage = CGImageCreate(pagesWide*256, pagesHigh*256, 8, 32, rowBytes, deviceRGB, kCGImageAlphaFirst, dataProvider, NULL, YES, kCGRenderingIntentDefault);
	CGColorSpaceRelease(deviceRGB);
	CGDataProviderRelease(dataProvider);
}

- (void)setupMaterials
{
	self.meshInternalLightingMaterial = [SCNMaterial material];
//	self.meshInternalLightingMaterial.ambient.contents = [NSColor blackColor];
//	self.meshInternalLightingMaterial.diffuse.contents = [NSColor blackColor];
//	self.meshInternalLightingMaterial.specular.contents = [NSColor blackColor];
//	self.meshInternalLightingMaterial.emission.contents = (__bridge id) textureImage;
	self.meshInternalLightingMaterial.diffuse.contents = (__bridge id) textureImage;
	self.meshInternalLightingMaterial.diffuse.minificationFilter = SCNLinearFiltering;
	self.meshInternalLightingMaterial.diffuse.magnificationFilter = SCNLinearFiltering;
	self.meshInternalLightingMaterial.diffuse.mipFilter = SCNLinearFiltering;
	self.meshInternalLightingMaterial.diffuse.wrapS = SCNRepeat;
	self.meshInternalLightingMaterial.diffuse.wrapT = SCNRepeat;
	self.meshInternalLightingMaterial.lightingModelName = SCNLightingModelConstant;
	self.meshInternalLightingMaterial.locksAmbientWithDiffuse = YES;
	
	self.meshExternalLightingMaterial = [SCNMaterial material];
	self.meshExternalLightingMaterial.diffuse.contents = (__bridge id) textureImage;
	self.meshExternalLightingMaterial.diffuse.minificationFilter = SCNLinearFiltering;
	self.meshExternalLightingMaterial.diffuse.magnificationFilter = SCNLinearFiltering;
	self.meshExternalLightingMaterial.diffuse.mipFilter = SCNLinearFiltering;
	self.meshExternalLightingMaterial.diffuse.wrapS = SCNRepeat;
	self.meshExternalLightingMaterial.diffuse.wrapT = SCNRepeat;
	self.meshExternalLightingMaterial.lightingModelName = SCNLightingModelConstant;
	self.meshExternalLightingMaterial.locksAmbientWithDiffuse = YES;
	
	self.meshAlphaInternalLightingMaterial = [SCNMaterial material];
//	self.meshAlphaInternalLightingMaterial.ambient.contents = [NSColor blackColor];
//	self.meshAlphaInternalLightingMaterial.diffuse.contents = [NSColor blackColor];
//	self.meshAlphaInternalLightingMaterial.specular.contents = [NSColor blackColor];
//	self.meshAlphaInternalLightingMaterial.emission.contents = (__bridge id) textureImage;
	self.meshAlphaInternalLightingMaterial.transparencyMode = SCNTransparencyModeRGBZero;
	self.meshAlphaInternalLightingMaterial.diffuse.contents = (__bridge id) textureImage;
	
	self.meshAlphaExternalLightingMaterial = [SCNMaterial material];
	self.meshAlphaExternalLightingMaterial.diffuse.contents = (__bridge id) textureImage;
	self.meshAlphaExternalLightingMaterial.transparencyMode = SCNTransparencyModeRGBZero;
}

- (void)setupMeshes
{
	NSMutableArray *meshes = [[NSMutableArray alloc] initWithCapacity:self.level.meshPointers.count];
	
	for (TR1MeshPointer *meshPointer in self.level.meshPointers)
	{
		TRRenderMesh *renderMesh = [[TRRenderMesh alloc] initWithMesh:meshPointer.mesh inRenderLevel:self];
		[meshes addObject:renderMesh];
	}
	
	self.meshes = meshes;
}

- (void)getTextureCoords:(CGPoint *)fourPoints forObjectTexture:(TR1Texture *)texture;
{
	NSUInteger page = texture.tileIndex;
	if (usePalettePage)
		page += 1;
	
	NSUInteger pageRow = page / pagesWide;
	NSUInteger pageCol = page % pagesWide;
	
	NSUInteger i = 0;
	for (TR1TextureVertex *vertex in texture.vertices)
	{
		NSUInteger pixels[2] = {
			vertex.xPixel + pageCol*256,
			vertex.yPixel + pageRow*256
		};
		
		fourPoints[i++] = CGPointMake((CGFloat) pixels[0] / (CGFloat) (pagesWide*256), (CGFloat) pixels[1] / (CGFloat) (pagesHigh*256));
	}
}

- (CGPoint)textureCoordsForColorIndex:(NSUInteger)colorIndex;
{
	NSUInteger pixelX = 8 + (colorIndex % 16)*16;
	NSUInteger pixelY = 8 + (colorIndex / 16)*16;
	
	return CGPointMake((CGFloat) pixelX / (CGFloat) (pagesWide * 256),
					   (CGFloat) pixelY / (CGFloat) (pagesHigh * 256));
}

@end