//
//  TR1RoomSprite.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomSprite.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1Room.h"
#import "TR1Texture.h"

@implementation TR1RoomSprite

+ (NSSet *)keyPathsForValuesAffectingTexture
{
	return [NSSet setWithObjects:@"room.level.textures", @"textureIndex", nil];
}
+ (NSSet *)keyPathsForValuesAffectingPosition
{
	return [NSSet setWithObjects:@"room.vertices", @"vertexIndex", nil];
}

- (id)initFromDataStream:(TRInDataStream *)stream inRoom:(TR1Room *)room;
{
	if (!(self = [super init])) return nil;
	
	_room = room;
	
	self.vertexIndex = [stream readUint16];
	self.textureIndex = [stream readUint16];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint16:(uint16_t) self.vertexIndex];
	[stream appendUint16:(uint16_t) self.textureIndex];
}

// No setter for position. That would require more thought.

- (TR1Vertex *)position
{
	return [[self.room valueForKey:@"vertices"] objectAtIndex:self.vertexIndex];
}

- (void)setTexture:(TR1Texture *)texture
{
	//self.textureIndex = texture.index;
}
- (TR1Texture *)texture
{
	return [[self.room valueForKeyPath:@"level.textures"] objectAtIndex:self.textureIndex];
}

@end
