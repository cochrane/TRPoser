//
//  TR1RoomFace.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomFace.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1Mesh.h"
#import "TR1Room.h"
#import "TR1Texture.h"

@implementation TR1RoomFace

+ (NSSet *)keyPathsForValuesAffectingTexture
{
	return [NSSet setWithObjects:@"room.level.textures", @"surfaceIndex", @"isTextured", nil];
}

- (id)initFromDataStream:(TRInDataStream *)stream inRoom:(TR1Room *)room corners:(NSUInteger)corners;
{
	if (!(self = [super init])) return nil;
	
	_room = room;
	
	_indices = [[NSMutableArray alloc] initWithCapacity:corners];
	for (NSUInteger i = 0; i < corners; i++)
		[_indices addObject:@( [stream readUint16 ])];
	
	self.surfaceIndex = [stream readUint16];
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
	for (NSNumber *number in self.indices)
		[stream appendUint16:number.unsignedShortValue];
	
	[stream appendUint16:self.surfaceIndex];
}

- (BOOL)isTwoSided;
{
	return NO;
}
- (BOOL)hasAlpha
{
	return NO;
}

- (TR1Texture *)texture
{
	return [[self.room valueForKeyPath:@"level.objectTextures"] objectAtIndex:self.surfaceIndex];
}

- (void)setTexture:(TR1Texture *)texture
{
	//self.surfaceIndex = texture.index;
}


@end
