//
//  TR2Level.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2Level.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1Animation.h"
#import "TR1FloorDataList.h"
#import "TR1Mesh.h"
#import "TR1MeshPointer.h"
#import "TR1Palette8.h"
#import "TR1StateChange.h"
#import "TR1TexturePage8.h"
#import "TR2Palette16.h"
#import "TR2Room.h"
#import "TR2TexturePage16.h"

@implementation TR2Level

+ (NSString *)structureDescriptionSource
{
	return @"const bitu32=45;\
	*Palette8 palette8;\
	*Palette16 palette16;\
	*TexturePage8 textureTiles8[bitu32];\
	*TexturePage16 textureTiles16[textureTiles8.@count];\
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
	*CinematicFrame cinematicFrames[bitu16];\
	bitu8 demoData[bitu16];\
	*SoundMap soundMap;\
	*SoundDetail soundDetails[bitu32];\
	bitu32 sampleIndices[bitu32];";
}

- (NSUInteger)gameVersion;
{
	return 2;
}

@end
