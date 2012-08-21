//
//  TR3Mesh.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR3Mesh.h"

@implementation TR3Mesh

- (double)normalizeLightValue:(NSUInteger)value;
{
	// This came from vt, but all links there seem to have died.
	return value / 32767.0;
}

@end
