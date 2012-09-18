//
//  TR1Room.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Room.h"

#import <AppKit/NSColorSpace.h>

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1Level.h"
#import "TR1RoomFace.h"
#import "TR1RoomLight.h"
#import "TR1RoomSector.h"
#import "TR1RoomSprite.h"
#import "TR1RoomPortal.h"
#import "TR1RoomVertex.h"
#import "TR1StaticMeshInstance.h"

@implementation TR1Room

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	_level = level;

	self.x = [stream readInt32];
	self.z = [stream readInt32];
	self.yBottom = [stream readInt32];
	self.yTop = [stream readInt32];
	
	NSUInteger numWords = [stream readUint32];
	NSUInteger positionAtStart = stream.position;
	
	Class vertexClass = [self.level versionedClassForName:@"RoomVertex"];
	
	NSUInteger countOfVertices = [stream readUint16];
	_vertices = [[NSMutableArray alloc] initWithCapacity:countOfVertices];
	for (NSUInteger i = 0; i < countOfVertices; i++)
		[_vertices addObject:[[vertexClass alloc] initFromDataStream:stream inLevel:self.level]];
	
	Class faceClass = [self.level versionedClassForName:@"RoomFace"];
	
	NSUInteger countOfRectangles = [stream readUint16];
	_rectangles = [[NSMutableArray alloc] initWithCapacity:countOfRectangles];
	for (NSUInteger i = 0; i < countOfRectangles; i++)
		[_rectangles addObject:[[faceClass alloc] initFromDataStream:stream inRoom:self corners:4]];
	
	NSUInteger countOfTriangles = [stream readUint16];
	_triangles = [[NSMutableArray alloc] initWithCapacity:countOfTriangles];
	for (NSUInteger i = 0; i < countOfTriangles; i++)
		[_triangles addObject:[[faceClass alloc] initFromDataStream:stream inRoom:self corners:3]];
	
	NSUInteger countOfSprites = [stream readUint16];
	_sprites = [[NSMutableArray alloc] initWithCapacity:countOfSprites];
	for (NSUInteger i = 0; i < countOfSprites; i++)
		[_sprites addObject:[[TR1RoomSprite alloc] initFromDataStream:stream inRoom:self]];
	
	NSUInteger positionNow = stream.position;
	NSAssert(positionNow - positionAtStart == numWords*2, @"Word count wrong! Was %lu (%lu bytes), but scanned %lu bytes.", numWords, numWords*2, positionNow - positionAtStart);
	
	NSUInteger countOfPortals = [stream readUint16];
	_portals = [[NSMutableArray alloc] initWithCapacity:countOfPortals];
	for (NSUInteger i = 0; i < countOfPortals; i++)
		[_portals addObject:[[TR1RoomPortal alloc] initFromDataStream:stream inLevel:self.level]];
	
	self.countOfSectorsZ = [stream readUint16];
	self.countOfSectorsX = [stream readUint16];
	_sectors = [[NSMutableArray alloc] initWithCapacity:self.countOfSectorsX * self.countOfSectorsZ];
	for (NSUInteger i = 0; i < self.countOfSectorsX * self.countOfSectorsZ; i++)
		[_sectors addObject:[[TR1RoomSector alloc] initFromDataStream:stream inLevel:self.level]];
	
	[self readGlobalLightState:stream];
	
	Class roomLightClass = [self.level versionedClassForName:@"RoomLight"];
	NSUInteger countOfLights = [stream readUint16];
	_lights = [[NSMutableArray alloc] initWithCapacity:countOfLights];
	for (NSUInteger i = 0; i < countOfLights; i++)
		[_lights addObject:[[roomLightClass alloc] initFromDataStream:stream inLevel:self.level]];
	
	Class staticMeshInstanceClass = [self.level versionedClassForName:@"StaticMeshInstance"];
	NSUInteger countOfStaticMeshes = [stream readUint16];
	_staticMeshes = [[NSMutableArray alloc] initWithCapacity:countOfStaticMeshes];
	for (NSUInteger i = 0; i < countOfStaticMeshes; i++)
		[_staticMeshes addObject:[[staticMeshInstanceClass alloc] initFromDataStream:stream inLevel:self.level]];
	
	self.alternateRoomIndex = [stream readUint16];
	self.flags = [stream readUint16];
	
	[self readRoomFooter:stream];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendInt32:(int32_t) self.x];
	[stream appendInt32:(int32_t) self.z];
	[stream appendInt32:(int32_t) self.yBottom];
	[stream appendInt32:(int32_t) self.yTop];
	
	TROutDataStream *substream = [[TROutDataStream alloc] init];
	
	[substream appendUint16:self.vertices.count];
	for (TR1RoomVertex *vertex in self.vertices)
		[vertex writeToStream:substream];
	
	[substream appendUint16:self.rectangles.count];
	for (TR1RoomFace *face in self.rectangles)
		[face writeToStream:substream];
	
	[substream appendUint16:self.triangles.count];
	for (TR1RoomFace *face in self.triangles)
		[face writeToStream:substream];
	
	[substream appendUint16:self.sprites.count];
	for (TR1RoomSprite *sprite in self.sprites)
		[sprite writeToStream:substream];
	
	[stream appendUint32:substream.length/2];
	[stream appendStream:substream];
	
	[stream appendUint16:self.portals.count];
	for (TR1RoomPortal *portal in self.portals)
		[portal writeToStream:stream];
	
	[stream appendUint16:self.countOfSectorsZ];
	[stream appendUint16:self.countOfSectorsX];
	for (TR1RoomSector *sector in self.sectors)
		[sector writeToStream:stream];
	
	[self writeGlobalLightState:stream];
	
	[stream appendUint16:self.lights.count];
	for (TR1RoomLight *light in self.lights)
		[light writeToStream:stream];

	[stream appendUint16:self.staticMeshes.count];
	for (TR1StaticMeshInstance *mesh in self.staticMeshes)
		[mesh writeToStream:stream];
	
	[stream appendUint16:self.alternateRoomIndex];
	[stream appendUint16:self.flags];
	
	[self writeRoomFooter:stream];
}

- (void)readGlobalLightState:(TRInDataStream *)stream;
{
	self.ambientIntensity1 = [stream readUint16];
}
- (void)writeGlobalLightState:(TROutDataStream *)stream;
{
	[stream appendUint16:(uint16_t) self.ambientIntensity1];
}

- (void)readRoomFooter:(TRInDataStream *)stream;
{
	
}
- (void)writeRoomFooter:(TROutDataStream *)stream;
{
	
}

- (void)enumerateRoomVertices:(void (^)(TR1RoomVertex *))iterator;
{
	for (TR1RoomVertex *vertex in self.vertices)
		iterator(vertex);
}

- (void)setRoomColor:(NSColor *)color
{
	NSColorSpace *graySpace = [NSColorSpace genericGrayColorSpace];
	NSColor *grayScaleColor = [color colorUsingColorSpace:graySpace];
	
	float lightValue = [grayScaleColor whiteComponent];
	self.ambientIntensity1 = [self.level lightValueFromBrightness:lightValue];
}

- (NSColor *)roomColor
{
	float lightValue = [self.level normalizeLightValue:self.ambientIntensity1];
	return [NSColor colorWithDeviceWhite:lightValue alpha:1.0];
}

@end
