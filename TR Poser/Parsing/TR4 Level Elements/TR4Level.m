//
//  TR4Level.m
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4Level.h"

#import "TR2TexturePage16.h"
#import "TR4TexturePage32.h"

@implementation TR4Level

+ (NSString *)structureDescriptionSource
{
	return @"const bitu8='T';\
	const bitu8='R';\
	const bitu8='4';\
	const bitu8=0;\
	bitu16 flatRoomTiles;\
	bitu16 objectTiles;\
	bitu16 bumpedRoomTiles;\
	compressed texture32[u=bitu32, c=bitu32];\
	compressed texture16[u=bitu32, c=bitu32];\
	compressed textureFontAndSky[u=bitu32, c=bitu32];\
	compressed geometry[u=bitu32, c=bitu32];\
	*Sound sounds[bitu32];\
	";
}

- (NSUInteger)gameVersion;
{
	return 4;
}
- (id)initFromDataStream:(TRInDataStream *)stream;
{
	NSDictionary *substreams = nil;
	if (!(self = [super initFromDataStream:stream inLevel:self substreams:&substreams])) return nil;
	
	// Parse textures
	TRInDataStream *texture32Stream = substreams[@"texture32"];
	NSUInteger regularTiles = self.flatRoomTiles + self.objectTiles + self.bumpedRoomTiles;
	self.textureTiles32 = [[NSMutableArray alloc] initWithCapacity:regularTiles];
	for (NSUInteger i = 0; i < regularTiles; i++)
		[self.textureTiles32 addObject:[[TR4TexturePage32 alloc] initFromDataStream:texture32Stream inLevel:self]];
	
	TRInDataStream *texture16Stream = substreams[@"texture16"];
	self.textureTiles16 = [[NSMutableArray alloc] initWithCapacity:regularTiles];
	for (NSUInteger i = 0; i < regularTiles; i++)
		[self.textureTiles16 addObject:[[TR2TexturePage16 alloc] initFromDataStream:texture16Stream inLevel:self]];
	
	TRInDataStream *specialTextureStream = substreams[@"textureFontAndSky"];
	self.specialTextureTiles = [[NSMutableArray alloc] initWithCapacity:2];
	for (NSUInteger i = 0; i < 2; i++)
		[self.specialTextureTiles addObject:[[TR4TexturePage32 alloc] initFromDataStream:specialTextureStream inLevel:self]];
	
//	// Parse meshes
//	TRInDataStream *meshStream = [substreams objectForKey:@"meshData"];
//	for (TR1MeshPointer *meshPointer in self.meshPointers)
//	{
//		meshStream.position = meshPointer.meshStartOffset;
//		TR1Mesh *mesh = [[TR1Mesh alloc] initFromDataStream:meshStream inLevel:self];
//		meshPointer.mesh = mesh;
//	}
//	
//	// Set up things by key
//	_staticMeshesByObjectID = [[NSMutableDictionary alloc] initWithCapacity:self.staticMeshes.count];
//	for (TR1StaticMesh *mesh in self.staticMeshes)
//		[_staticMeshesByObjectID setObject:mesh forKey:@(mesh.objectID)];
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
//	TROutDataStream *meshStream = [[TROutDataStream alloc] init];
//	for (TR1MeshPointer *meshPointer in self.meshPointers)
//	{
//		meshPointer.meshStartOffset = meshStream.length;
//		[meshPointer.mesh writeToStream:meshStream];
//	}
//	[super writeToStream:stream substreams:@{ @"meshData" : meshStream }];
}

- (NSUInteger)countOfTextureTiles;
{
	return self.textureTiles32.count + self.specialTextureTiles.count;
}
- (TRTexturePage *)objectInTextureTilesAtIndex:(NSUInteger)index;
{
	if (index < self.textureTiles32.count)
		return [self.textureTiles32 objectAtIndex:index];
	else
		return [self.specialTextureTiles objectAtIndex:index - self.textureTiles32.count];
}

@end
