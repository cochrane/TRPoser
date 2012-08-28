//
//  TR4FlybyCamera.m
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4FlybyCamera.h"

@implementation TR4FlybyCamera

+ (NSString *)structureDescriptionSource
{
	return @"bit32 position1X;\
	bit32 position1Y;\
	bit32 position1Z;\
	bit32 position2X;\
	bit32 position2Y;\
	bit32 position2Z;\
	bitu8 index1;\
	bitu8 index2;\
	bitu16 unknown1;\
	bitu16 unknown2;\
	bitu16 unknown3;\
	bitu16 unknown4;\
	bitu16 unknown5;\
	bitu32 cameraID;";
}

@end
