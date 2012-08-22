//
//  TRRenderMoveable.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderMoveable.h"

#import "TRRenderMesh.h"
#import "TRRenderMoveableDescription.h"
#import "TRRenderLevelResources.h"
#import "TRRenderRoom.h"

@interface TRRenderMoveable ()
{
	SCNNode *sceneRoot;
}

@end

@implementation TRRenderMoveable

- (id)initWithDescription:(TRRenderMoveableDescription *)description;
{
	if (!(self = [super init])) return nil;
	
	_description = description;
	_rootNode = [[TRRenderMoveableNode alloc] initWithDescription:description.rootNode partOf:self];
	
	return self;
}

- (void)setOffset:(SCNVector3)offset
{
	self.sceneRoot.position = offset;
}
- (SCNVector3)offset
{
	return self.sceneRoot.position;
}

- (void)setRotation:(double)rotation
{
	self.sceneRoot.rotation = SCNVector4Make(0, 1, 0, rotation);
}

- (double)rotation
{
	SCNVector4 rot = self.sceneRoot.rotation;
	if (rot.x == 0.0 && rot.y == 1.0 && rot.z == 0.0)
		return rot.w;
	else
		return NAN;
}

- (SCNNode *)sceneRoot
{
	if (!sceneRoot)
	{
		sceneRoot = [SCNNode node];
		[sceneRoot addChildNode:self.rootNode.node];
	}
	return sceneRoot;
}

- (void)setRoom:(TRRenderRoom *)room
{
	if (_room)
		[self.sceneRoot removeFromParentNode];
	
	_room = room;
	if (_room)
		[_room.node addChildNode:self.sceneRoot];
}

@end

@implementation TRRenderMoveableNode

- (id)initWithDescription:(TRRenderMoveableDescriptionNode *)node partOf:(TRRenderMoveable *)moveable;
{
	if (!(self = [super init])) return nil;
	
	self.offset = node.offset;
	TRRenderLevelResources *resources = moveable.description.level;
	TRRenderMesh *mesh = [[resources meshes] objectAtIndex:node.meshIndex];
	_node = [SCNNode nodeWithGeometry:mesh.meshGeometry];
	_node.transform = self.transformation;
	
	NSMutableArray *children = [[NSMutableArray alloc] initWithCapacity:node.children.count];
	for (TRRenderMoveableDescriptionNode *childNode in node.children)
	{
		TRRenderMoveableNode *child = [[[self class] alloc] initWithDescription:childNode partOf:moveable];
		[children addObject:child];
		[_node addChildNode:child.node];
	}
	_children = children;
	
	return self;
}

- (CATransform3D)transformation
{
	// Core Animation multiplies matrices from the left, not right (as OpenGL
	// does), so this order is correct.
	
	//The Y-X-Z order is prescribed by TRosettaStone
	CATransform3D transform = CATransform3DMakeTranslation(self.offset.x, self.offset.y, self.offset.z);
	transform = CATransform3DRotate(transform, self.rotationY, 0.0, 1.0, 0.0);
	transform = CATransform3DRotate(transform, self.rotationX, 1.0, 0.0, 0.0);
	transform = CATransform3DRotate(transform, self.rotationZ, 0.0, 0.0, 1.0);
	
	return transform;
}

@end
