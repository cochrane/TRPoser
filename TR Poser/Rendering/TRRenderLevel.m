//
//  TRRenderLevel.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderLevel.h"

#import <Accelerate/Accelerate.h>

#import "TRTexturePage.h"
#import "TR1Level.h"
#import "TR1Palette8.h"

@interface TRRenderLevel ()
{
	BOOL usePalettePage;
	CGImageRef textureImage;
	NSUInteger pagesWide;
	NSUInteger pagesHigh;
}

- (void)setupTexture;

@end

@implementation TRRenderLevel

@synthesize textureImage=textureImage;

- (id)initWithLevel:(TR1Level *)aLevel;
{
	if (!(self = [super init])) return nil;
	
	self.level = aLevel;
	[self setupTexture];
	
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

@end
