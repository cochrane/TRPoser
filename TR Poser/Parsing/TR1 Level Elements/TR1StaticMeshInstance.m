//
//  TR1StaticMeshInstance.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1StaticMeshInstance.h"

#import "TR1Level.h"
#import "TR1StaticMesh.h"

@implementation TR1StaticMeshInstance

+ (NSSet *)keyPathsForValuesAffectingRotationInDegrees
{
	return [NSSet setWithObjects:@"rotation", nil];
}
+ (NSSet *)keyPathsForValuesAffectingRotationInRad
{
	return [NSSet setWithObjects:@"rotation", nil];
}

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 rotation;\
	bitu16 intensity1;\
	bitu16 objectID;";
}

- (float)rotationInDegrees;
{
	return 90.0f * (self.rotation >> 14);
}
- (void)setRotationInDegrees:(float)rotationInDegrees
{
	self.rotation = (((NSUInteger) rotationInDegrees) % 90) << 14;
}

- (float)rotationInRad;
{
	return M_PI_2 * (self.rotation >> 14);
}
- (void)setRotationInRad:(float)rotationInRad
{
	if (rotationInRad < M_PI_2)
		self.rotation = 0;
	else if (rotationInRad < M_PI)
		self.rotation = 1 << 14;
	else if (rotationInRad < 3*M_PI_2)
		self.rotation = 2 << 14;
	else
		self.rotation = 3 << 14;
}

- (void)setMesh:(TR1StaticMesh *)mesh
{
	self.objectID = mesh.objectID;
}
- (TR1StaticMesh *)mesh
{
	return [self.level staticMeshWithObjectID:self.objectID];
}

@end
