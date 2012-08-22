//
//  TRRenderRoom.m
//  TR Poser
//
//  Created by Torsten Kammer on 21.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderRoomSCN.h"

#import "TRRenderRoomGeometrySCN.h"
#import "TR1Room.h"
#import "TR1RoomFace.h"
#import "TR1RoomLight.h"
#import "TRRenderCategoriesSCN.h"
#import "TR1StaticMesh.h"
#import "TR1StaticMeshInstance.h"
#import "TRRenderLevelResourcesSCN.h"
#import "TRRenderMeshSCN.h"

@interface TRRenderRoomSCN ()
{
	SCNNode *node;
}

@end

@implementation TRRenderRoomSCN

- (id)initWithRoomGeometry:(TRRenderRoomGeometrySCN *)room;
{
	if (!(self = [super init])) return nil;
	
	_geometry = room;
	
	return self;
}

- (SCNNode *)node;
{
	if (node) return node;
	
	node = [SCNNode nodeWithGeometry:self.geometry.roomGeometry];
	
	TRRenderLevelResourcesSCN *resourcesSCN = (TRRenderLevelResourcesSCN *) self.geometry.resources;
	
	for (TR1StaticMeshInstance *instance in self.room.staticMeshes)
	{
		TR1StaticMesh *staticMesh = instance.mesh;
		TRRenderMeshSCN *mesh = [resourcesSCN.meshes objectAtIndex:staticMesh.meshIndex];
		
		SCNVector3 offset = SCNVector3Make((CGFloat) (instance.x - self.room.x) / 1024.0, (CGFloat) instance.y / 1024.0, (CGFloat) (instance.z - self.room.z) / 1024.0);
		
		SCNGeometry *meshGeometry = mesh.meshGeometry;
		NSColor *color = instance.color;
		if (color != nil)
		{
			SCNGeometry *coloredGeometry = [meshGeometry copy];
			
			for (NSUInteger i = 0; i < meshGeometry.materials.count; i++)
			{
				SCNMaterial *coloredMaterial = [meshGeometry.materials[i] copy];
				coloredMaterial.multiply.contents = color;
				[coloredGeometry replaceMaterialAtIndex:i withMaterial:coloredMaterial];
			}
			
			meshGeometry = coloredGeometry;
		}
		
		SCNNode *meshNode = [SCNNode nodeWithGeometry:meshGeometry];
		meshNode.position = offset;
		meshNode.rotation = SCNVector4Make(0.0, 1.0, 0.0, instance.rotationInRad);
		
		[node addChildNode:meshNode];
	}
	
	// Lighting
	SCNLight *light = [SCNLight light];
	light.type = SCNLightTypeAmbient;
	light.color = self.room.roomColor;
	node.light = light;
	
	for (TR1RoomLight *light in self.room.lights)
	{
		SCNLight *roomLight = [SCNLight light];
		roomLight.type = SCNLightTypeOmni;
		roomLight.color = light.color;
		[roomLight setAttribute:@0 forKey:SCNLightAttenuationStartKey];
		[roomLight setAttribute:@(light.fade1 / 0x7FFF) forKey:SCNLightAttenuationEndKey];
		[roomLight setAttribute:@1 forKey:SCNLightAttenuationFalloffExponentKey];
		
		SCNNode *lightNode = [SCNNode node];
		lightNode.light = roomLight;
		lightNode.position = SCNVector3Make(light.x / 1024.0,
											light.y / 1024.0,
											light.z / 1024.0);
		[node addChildNode:lightNode];
	}
	
	return node;
}

- (TR1Room *)room
{
	return self.geometry.room;
}

- (SCNVector3)offset
{
	return self.geometry.offset;
}

@end
