//
//  TR1Level.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Level.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1MeshPointer.h"
#import "TR1Mesh.h"

@implementation TR1Level

+ (NSString *)structureDescriptionSource
{
	return @"const bitu32=32;\
	*TexturePage8 textureTiles8[bitu32];\
	bitu32 unused1;\
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
	*Texture objectTextures[bitu32];\
	*SpriteTexture spriteTextures[bitu32];\
	*SpriteSequence spriteSequences[bitu32];\
	*Camera cameras[bitu32];\
	*SoundSource soundSources[bitu32];\
	*Box boxes[bitu32];\
	bitu16 overlaps[bitu32];\
	*Zone zones[boxes.@count];\
	bitu16 animatedTextures[bitu32];\
	*Item items[bitu32];\
	*Lightmap lightmap;\
	*Palette8 palette8;\
	*CinematicFrame cinematicFrames[bitu16];\
	bitu8 demoData[bitu16];\
	*SoundMap soundMap;\
	*SoundDetail soundDetails[bitu32];\
	*SampleList samples;\
	bitu32 sampleIndices[bitu32];";
}

- (NSUInteger)gameVersion;
{
	return 1;
}

- (Class)versionedClassForName:(NSString *)classNameSuffix;
{
	for (NSUInteger i = self.gameVersion; i > 0; i--)
	{
		NSString *versionedName = [NSString stringWithFormat:@"TR%lu%@", i, classNameSuffix];
		Class result = NSClassFromString(versionedName);
		if (result) return result;
	}
	return nil;
}

- (id)initFromDataStream:(TRInDataStream *)stream;
{
	NSDictionary *substreams = nil;
	if (!(self = [super initFromDataStream:stream inLevel:self substreams:&substreams])) return nil;
	
	// Parse meshes
	TRInDataStream *meshStream = [substreams objectForKey:@"meshData"];
	for (TR1MeshPointer *meshPointer in self.meshPointers)
	{
		meshStream.position = meshPointer.meshStartOffset;
		TR1Mesh *mesh = [[TR1Mesh alloc] initFromDataStream:meshStream inLevel:self];
		meshPointer.mesh = mesh;
	}
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
	TROutDataStream *meshStream = [[TROutDataStream alloc] init];
	for (TR1MeshPointer *meshPointer in self.meshPointers)
	{
		meshPointer.meshStartOffset = meshStream.length;
		[meshPointer.mesh writeToStream:meshStream];
	}
	[super writeToStream:stream substreams:@{ @"meshData" : meshStream }];
}

@end
