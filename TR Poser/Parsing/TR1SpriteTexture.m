//
//  TR1SpriteTexture.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1SpriteTexture.h"

@implementation TR1SpriteTexture

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 tileIndex;\
	bitu8 x;\
	bitu8 y;\
	bitu16 width;\
	bitu16 height;\
	bit16 leftSide;\
	bit16 topSide;\
	bit16 rightSide;\
	bit16 bottomSide;";
}

@end
