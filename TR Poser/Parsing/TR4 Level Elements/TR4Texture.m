//
//  TR4Texture.m
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4Texture.h"

@implementation TR4Texture

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 attribute;\
	bitu16 tileIndex;\
	bitu16 flags;\
	*TextureVertex vertices[4];\
	bitu32 unknown1;\
	bitu32 unknown2;\
	bitu32 sizeX;\
	bitu32 sizeY;";
}

@end
