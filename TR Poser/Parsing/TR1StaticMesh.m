//
//  TR1StaticMesh.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1StaticMesh.h"

#import "TR1Item.h"
#import "TR1Level.h"
#import "TR1MeshPointer.h"

@implementation TR1StaticMesh

+ (NSString *)structureDescriptionSource
{
	return @"bitu32 objectID;\
	bitu16 meshIndex;\
	TR1Vertex boundingBox[4];\
	bitu16 flags;\
	@derived mesh=level.meshPointers[meshIndex];";
}

+ (NSSet *)keyPathsForValuesAffectingItem
{
	return [NSSet setWithObjects:@"objectID", @"level.items", nil];
}
+ (NSSet *)keyPathsForValuesAffectingMesh
{
	return [NSSet setWithObjects:@"meshIndex", @"level.meshPointers", @"level.meshes", nil];
}

- (void)setItem:(TR1Item *)item
{
	self.objectID = item.objectID;
}
- (TR1Item *)item
{
//	return [self.level itemWithObjectID:self.objectID];
	return nil;
}

@dynamic mesh;

@end
