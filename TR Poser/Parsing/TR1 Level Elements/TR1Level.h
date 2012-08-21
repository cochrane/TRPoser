//
//  TR1Level.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@class TRInDataStream;

@class TR1AnimationCommandList;
@class TR1FloorDataList;
@class TR1Lightmap;
@class TR1Mesh;
@class TR1Palette8;
@class TR1RoomVertex;
@class TR1SampleList;
@class TR1SoundMap;
@class TR1StaticMesh;
@class TRTexturePage;

@interface TR1Level : TRStructure

- (id)initWithData:(NSData *)data;
- (NSData *)writeToData;

- (id)initFromDataStream:(TRInDataStream *)stream;
- (void)writeToStream:(TROutDataStream *)stream;

- (NSUInteger)gameVersion;
- (Class)versionedClassForName:(NSString *)classNameSuffix;

@property (nonatomic, retain) TR1Palette8 *palette8;
@property (nonatomic, retain) NSMutableArray *textureTiles8;
@property (nonatomic, retain) NSMutableArray *rooms;
@property (nonatomic, retain) TR1FloorDataList *floorData;
@property (nonatomic, retain) NSMutableArray *meshPointers;
@property (nonatomic, retain) NSMutableArray *meshes;
@property (nonatomic, retain) NSMutableArray *animations;
@property (nonatomic, retain) NSMutableArray *stateChanges;
@property (nonatomic, retain) NSMutableArray *animationDispatches;
@property (nonatomic, retain) TR1AnimationCommandList *animationCommands;
@property (nonatomic, retain) NSMutableArray *meshTrees;
@property (nonatomic, retain) NSMutableArray *frames;
@property (nonatomic, retain) NSMutableArray *moveables;
@property (nonatomic, retain) NSMutableArray *staticMeshes;
@property (nonatomic, retain) NSMutableArray *objectTextures;
@property (nonatomic, retain) NSMutableArray *spriteTextures;
@property (nonatomic, retain) NSMutableArray *spriteSequences;
@property (nonatomic, retain) NSMutableArray *cameras;
@property (nonatomic, retain) NSMutableArray *soundSources;
@property (nonatomic, retain) NSMutableArray *boxes;
@property (nonatomic, retain) NSMutableArray *overlaps;
@property (nonatomic, retain) NSMutableArray *zones;
@property (nonatomic, retain) NSMutableArray *animatedTextures;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) TR1Lightmap *lightmap;
@property (nonatomic, retain) NSMutableArray *cinematicFrames;
@property (nonatomic, retain) NSData *demoData;
@property (nonatomic, retain) TR1SoundMap *soundMap;
@property (nonatomic, retain) NSMutableArray *soundDetails;
@property (nonatomic, retain) TR1SampleList *samples;
@property (nonatomic, retain) NSMutableArray *sampleIndices;

// Not sure about this one
@property (nonatomic, assign) NSUInteger unused1;


// Derived
- (TR1StaticMesh *)staticMeshWithObjectID:(NSUInteger)objectID;

// Always returns the highest quality for every level.
- (NSUInteger)countOfTextureTiles;
- (TRTexturePage *)objectInTextureTilesAtIndex:(NSUInteger)index;

- (double)normalizeLightValue:(NSUInteger)value;
- (NSUInteger)lightValueFromBrightness:(double)brightness;

- (void)enumerateRoomVertices:(void (^)(TR1RoomVertex *))iterator;

@end
