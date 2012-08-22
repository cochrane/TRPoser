//
//  TRRenderLevel.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderLevel.h"

#import "TRRenderLevelResources.h"
#import "TRRenderRoom.h"

@interface TRRenderLevel ()
{
	SCNNode *rootNode;
}

@end

@implementation TRRenderLevel

- (id)initWithResources:(TRRenderLevelResources *)resources;
{
	if (!(self = [super init])) return nil;
	
	_resources = resources;
	
	NSMutableArray *rooms = [[NSMutableArray alloc] initWithCapacity:resources.rooms.count];
	for (TRRenderRoomGeometry *geometry in resources.rooms)
	{
		TRRenderRoom *room = [[TRRenderRoom alloc] initWithRoomGeometry:geometry];
		[rooms addObject:room];
	}
	_rooms = [rooms copy];
	
	return self;
}

- (SCNNode *)rootNode
{
	if (rootNode) return rootNode;
	
	rootNode = [SCNNode node];
	
	for (TRRenderRoom *room in self.rooms)
	{
		SCNNode *node = room.node;
		SCNVector3 offset = room.offset;
		
		node.position = offset;
		[rootNode addChildNode:node];
	}
	
	return rootNode;

}

@end
