//
//  TRRenderMoveableDescription.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderMoveableDescription.h"

#import "TR1Moveable.h"
#import "TR1MeshTree.h"
#import "TR1Level.h"
#import "TRRenderLevelResources.h"

@implementation TRRenderMoveableDescription

- (id)initWithMoveable:(TR1Moveable *)moveable inRenderLevel:(TRRenderLevelResources *)level;
{
	if (!(self = [super init])) return nil;
	
	_moveable = moveable;
	_level = level;
	
	// Assemble meshes
	NSMutableArray *stack = [[NSMutableArray alloc] init];
	
	_rootNode = [[TRRenderMoveableDescriptionNode alloc] init];
	_rootNode.meshIndex = moveable.meshStart;
	TRRenderMoveableDescriptionNode *previous = _rootNode;
	NSUInteger meshTreeStart = moveable.meshTreeOffset / 4;
	
	/*
	 * TRosettaStone does not explain this part well. What happens is:
	 * The root node is not in mesh trees, only the children (hence
	 * the start at 1). Pop means take the last thing on the stack
	 * and use it as a parent. Push means use the parent we have and
	 * put it on the stack, too. Both can be on at the same time; then
	 * Pop is executed first.
	 */
	for (NSUInteger i = 1; i < moveable.meshCount; i++)
	{
		TR1MeshTree *tree = self.level.level.meshTrees[meshTreeStart + i - 1];
		
		TRRenderMoveableDescriptionNode *node = [[TRRenderMoveableDescriptionNode alloc] init];
		node.meshIndex = moveable.meshStart + i;
		if (tree.pop)
		{
			node.parent = [stack lastObject];
			[stack removeLastObject];
		}
		else
		{
			node.parent = previous;
		}
		
		if (tree.push)
			[stack addObject:node.parent];
		
		node.offsetX = tree.offsetX / 1024.0;
		node.offsetY = tree.offsetY / 1024.0;
		node.offsetZ = tree.offsetZ / 1024.0;
		
		previous = node;
	}
	
	return self;
}


@end

@implementation TRRenderMoveableDescriptionNode

- (id)init
{
	if (!(self = [super init])) return nil;
	
	_children = [[NSMutableArray alloc] init];
	
	return self;
}

- (void)setParent:(TRRenderMoveableDescriptionNode *)parent
{
	if (_parent)
		[_parent.children removeObject:self];
		
	_parent = parent;
	
	if (_parent)
		[_parent.children addObject:self];
}

@end
