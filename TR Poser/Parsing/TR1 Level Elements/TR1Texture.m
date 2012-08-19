//
//  TR1Texture.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Texture.h"

@implementation TR1Texture

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 attribute;\
	bitu16 tileIndex;\
	TR1TextureVertex vertices[4];";
}

@end
