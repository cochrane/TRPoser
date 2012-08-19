//
//  TR2StaticMeshInstance.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2StaticMeshInstance.h"

@implementation TR2StaticMeshInstance

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 rotation;\
	bitu16 intensity1;\
	bitu16 intensity2;\
	bitu16 objectID;";
}

@end
