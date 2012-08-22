//
//  TRFrame.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRFrame.h"

@interface TRFrame ()
{
	NSUInteger numAngles;
	NSUInteger *angleValues;
}

@end

@implementation TRFrame

- (id)initWithCountOfAngles:(NSUInteger)angles;
{
	if (!(self = [super init])) return nil;
	
	numAngles = angles;
	angleValues = calloc(sizeof(NSUInteger), 3 * numAngles);
	
	return self;
}

- (void)dealloc
{
	free(angleValues);
}

- (void)setRotationX:(NSUInteger)x y:(NSUInteger)y z:(NSUInteger)z atIndex:(NSUInteger)index;
{
	NSAssert(index < numAngles, @"Index %lu >= max=%lu", index, numAngles);
	
	angleValues[index*3+0] = x;
	angleValues[index*3+1] = y;
	angleValues[index*3+2] = z;
}

- (NSUInteger)rotationXAtIndex:(NSUInteger)index;
{
	NSAssert(index < numAngles, @"Index %lu >= max=%lu", index, numAngles);
	return angleValues[index*3+0];
}
- (NSUInteger)rotationYAtIndex:(NSUInteger)index;
{
	NSAssert(index < numAngles, @"Index %lu >= max=%lu", index, numAngles);
	return angleValues[index*3+1];
}
- (NSUInteger)rotationZAtIndex:(NSUInteger)index;
{
	NSAssert(index < numAngles, @"Index %lu >= max=%lu", index, numAngles);
	return angleValues[index*3+2];
}


- (double)rotationXInRadAtIndex:(NSUInteger)index;
{
	return (double)[self rotationXAtIndex:index] * M_PI / 512.0;
}
- (double)rotationYInRadAtIndex:(NSUInteger)index;
{
	return (double)[self rotationYAtIndex:index] * M_PI / 512.0;
}
- (double)rotationZInRadAtIndex:(NSUInteger)index;
{
	return (double)[self rotationZAtIndex:index] * M_PI / 512.0;
}

@end
