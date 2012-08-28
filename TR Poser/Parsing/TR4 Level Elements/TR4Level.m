//
//  TR4Level.m
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4Level.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TRStructureDescription.h"

#import "TR1MeshPointer.h"
#import "TR2TexturePage16.h"
#import "TR4TexturePage32.h"
#import "TR4Mesh.h"

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

+ (NSString *)geometryPartDescriptionSource
{
	return @"bitu32 unused1;\
	*Room rooms[bitu16];\
	*FloorDataList floorData;\
	substream meshData[bitu32*2];\
	*MeshPointer meshPointers[bitu32];\
	*Animation animations[bitu32];\
	*StateChange stateChanges[bitu32];\
	*AnimationDispatch animationDispatches[bitu32];\
	*AnimationCommandList animationCommands;\
	*MeshTree meshTrees[bitu32/4];\
	*FrameData frames;\
	*Moveable moveables[bitu32];\
	*StaticMesh staticMeshes[bitu32];\
	const bitu8='S';\
	const bitu8='P';\
	const bitu8='R';\
	*SpriteTexture spriteTextures[bitu32];\
	*SpriteSequence spriteSequences[bitu32];\
	*Camera cameras[bitu32];\
	*FlybyCamera flybyCameras[bitu32];\
	*SoundSource soundSources[bitu32];\
	*Box boxes[bitu32];\
	bitu16 overlaps[bitu32];\
	*Zone zones[boxes.@count];\
	bitu16 animatedTextures[bitu32];\
	bitu8 unused2;\
	const bitu8='T';\
	const bitu8='E';\
	const bitu8='X';\
	*Texture objectTextures[bitu32];\
	*Item items[bitu32];\
	*AIObject aiObjects[bitu32];\
	bitu8 demoData[bitu16];\
	*SoundMap soundMap;\
	*SoundDetail soundDetails[bitu32];\
	bitu32 sampleIndices[bitu32];\
	const bitu16=0;\
	const bitu16=0;\
	const bitu16=0;";
}

+ (TRStructureDescription *)geometryPartDescription
{
	static TRStructureDescription *description = nil;
	if (!description)
	{
		description = [[TRStructureDescription alloc] initWithSource:self.geometryPartDescriptionSource];
	}
	return description;
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
	NSAssert(texture32Stream.isAtEnd, @"32 bit texture stream is too long.");
	
	TRInDataStream *texture16Stream = substreams[@"texture16"];
	self.textureTiles16 = [[NSMutableArray alloc] initWithCapacity:regularTiles];
	for (NSUInteger i = 0; i < regularTiles; i++)
		[self.textureTiles16 addObject:[[TR2TexturePage16 alloc] initFromDataStream:texture16Stream inLevel:self]];
	NSAssert(texture16Stream.isAtEnd, @"16 bit texture stream is too long.");
	
	TRInDataStream *specialTextureStream = substreams[@"textureFontAndSky"];
	self.specialTextureTiles = [[NSMutableArray alloc] initWithCapacity:2];
	for (NSUInteger i = 0; i < 2; i++)
		[self.specialTextureTiles addObject:[[TR4TexturePage32 alloc] initFromDataStream:specialTextureStream inLevel:self]];
	NSAssert(specialTextureStream.isAtEnd, @"font and sky texture stream is too long.");
	
	// Parse geometry
	NSDictionary *geometrySubstreams = nil;
	TRInDataStream *geometryStream = substreams[@"geometry"];
	[self parseStream:geometryStream description:self.class.geometryPartDescription substreams:&geometrySubstreams];
	
	[self parseMeshesFromStream:geometrySubstreams[@"meshData"]];
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
	TROutDataStream *texture32Stream = [[TROutDataStream alloc] init];
	for (TRTexturePage *page in self.textureTiles32)
		[page writeToStream:texture32Stream];
	
	TROutDataStream *texture16Stream = [[TROutDataStream alloc] init];
	for (TRTexturePage *page in self.textureTiles16)
		[page writeToStream:texture16Stream];
	
	TROutDataStream *specialTextureStream = [[TROutDataStream alloc] init];
	for (TRTexturePage *page in self.specialTextureTiles)
		[page writeToStream:specialTextureStream];
	
	TROutDataStream *meshStream = [[TROutDataStream alloc] init];
	[self writeMeshesToStream:meshStream];
	
	TROutDataStream *geometryStream = [[TROutDataStream alloc] init];
	[self writeToStream:geometryStream description:self.class.geometryPartDescription substreams:@{ @"meshData" : meshStream }];
	
	[super writeToStream:stream substreams:@{ @"texture32" : texture32Stream,
	 @"texture16" : texture16Stream,
	 @"textureFontAndSky" : specialTextureStream,
	 @"geometry" : geometryStream }];
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
