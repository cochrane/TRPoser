//
//  TR1MeshFace+TRRenderCategories.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderCategoriesSCN.h"

#import "TR1Mesh.h"
#import "TR1Room.h"

@implementation TR1MeshFace (TRRenderCategoriesSCN)

- (SCNVector3)positionAtCorner:(NSUInteger)index;
{
	return [self.mesh.vertices[[self.indices[index] unsignedIntegerValue]] sceneKitVector];
}
- (SCNVector3)normalAtCorner:(NSUInteger)index;
{
	NSAssert(!self.mesh.usesInternalLighting, @"Can't return normal if uses internal lighting.");
	SCNVector3 vector = [self.mesh.normals[[self.indices[index] unsignedIntegerValue]] sceneKitVector];
	
	CGFloat length = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z);
	vector.x /= length;
	vector.y /= length;
	vector.z /= length;
	
	return vector;
}
- (SCNVector3)lightAtCorner:(NSUInteger)index;
{
	NSAssert(self.mesh.usesInternalLighting, @"Can't return light value if not internal lighting.");

	double lightValue = [self.mesh.lightIntensities[[self.indices[index] unsignedIntegerValue]] doubleValue];
	
	return SCNVector3Make(lightValue, lightValue, lightValue);
}

@end

@implementation TR1RoomFace (TRRenderCategoriesSCN)

- (SCNVector3)positionAtCorner:(NSUInteger)index;
{
	return [self.room.vertices[[self.indices[index] unsignedIntegerValue]] sceneKitVector];
}
- (SCNVector3)lightAtCorner:(NSUInteger)index;
{
	NSColor *color = [self.room.vertices[[self.indices[index] unsignedIntegerValue]] color];
	
	NSColor *rgbColor = [color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
	SCNVector3 vector;
	
	[rgbColor getRed:&vector.x green:&vector.y blue:&vector.z alpha:NULL];
	
	return vector;
}

@end


@implementation TR1Vertex (TRRenderCategoriesSCN)

- (SCNVector3)sceneKitVector;
{
	return SCNVector3Make((CGFloat) self.x / 1024.0, (CGFloat) self.y / 1024.0, (CGFloat) self.z / 1024.0);
}

@end


@implementation TR1RoomVertex (TRRenderCategoriesSCN)

- (SCNVector3)sceneKitVector;
{
	return self.position.sceneKitVector;
}

@end