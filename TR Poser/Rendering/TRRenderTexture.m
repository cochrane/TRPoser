//
//  TRRenderTexture.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderTexture.h"

#import "TR1Level.h"
#import "TR1Palette8.h"
#import "TR1Texture.h"
#import "TR1TextureVertex.h"
#import "TRTexturePage.h"

@interface TRRenderTexture ()
{
	BOOL usesPalette;
	NSUInteger pagesWide;
	NSUInteger pagesHigh;
}

@end

@implementation TRRenderTexture

- (id)initWithLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	_level = level;
	
	NSUInteger numPages = [self.level countOfTextureTiles];
	if (self.level.palette8)
	{
		usesPalette = YES;
		numPages += 1;
	}
	pagesWide = sqrt((double) numPages);
	pagesHigh = ceil((double) numPages / (double) pagesWide);
	
	return self;
}

- (NSUInteger)width
{
	return pagesWide * 256;
}
- (NSUInteger)height
{
	return pagesHigh * 256;
}

- (NSData *)create32BitData
{
	NSMutableArray *texturePages32 = [[NSMutableArray alloc] initWithCapacity:self.level.countOfTextureTiles];
	if (usesPalette)
		[texturePages32 addObject:[self.level.palette8 asTexturePage]];
	
	for (TRTexturePage *page in [self.level valueForKey:@"textureTiles"])
		[texturePages32 addObject:[page pixels32Bit]];
	
	const NSUInteger rowBytes = self.width * 4;
	const NSUInteger pageRowBytes = rowBytes * 256;
	const NSUInteger pageColumnBytes = 256*4;
	
	uint8_t *result = calloc(self.width * self.height, 4);
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
	
	return [NSData dataWithBytesNoCopy:result length:self.width*self.height*4 freeWhenDone:YES];
}

- (void)getTextureCoords:(float *)coords forTexture:(TR1Texture *)texture corner:(NSUInteger)corner;
{
	TR1TextureVertex *vertex = texture.vertices[corner];
	
	NSUInteger page = texture.tileIndex;
	if (usesPalette)
		page += 1;
		
	NSUInteger pageRow = page / pagesWide;
	NSUInteger pageCol = page % pagesWide;
	
	NSAssert((pageRow < pagesHigh) && (pageCol < pagesWide), @"texture page %lu is too high!", page);
	
	NSUInteger pixels[2] = {
		vertex.xPixel + pageCol*256,
		vertex.yPixel + pageRow*256
	};
	
	if (vertex.xCoordinate < 128) pixels[0]++;
	else pixels[0]--;
	
	if (vertex.yCoordinate < 128) pixels[1]++;
	else pixels[1]--;
	
	coords[0] = (float) pixels[0] / (float) self.width;
	coords[1] = (float) pixels[1] / (float) self.height;
}

- (void)getTextureCoords:(float *)coords forColorIndex:(uint8_t)colorIndex;
{
	NSUInteger pixelX = 8 + (colorIndex % 16)*16;
	NSUInteger pixelY = 8 + (colorIndex / 16)*16;
	
	coords[0] = (float) pixelX / (float) self.width;
	coords[0] = (float) pixelY / (float) self.height;
}

@end
