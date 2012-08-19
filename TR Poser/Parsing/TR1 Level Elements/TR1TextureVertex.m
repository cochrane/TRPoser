//
//  TR1TextureVertex.m
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1TextureVertex.h"

@implementation TR1TextureVertex

+ (NSString *)structureDescriptionSource
{
	return @"bitu8 xCoordinate;\
	bitu8 xPixel;\
	bitu8 yCoordinate;\
	bitu8 yPixel;";
}

@end
