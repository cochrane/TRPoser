//
//  TRRenderLevel.h
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderLevelResources.h"

#import <SceneKit/SceneKit.h>

@class TR1Level;
@class TR1Texture;
@class TRRenderRoomSCN;
@class TRRenderLevelSCN;
@class TRRenderMoveableDescription;

@interface TRRenderLevelResourcesSCN : TRRenderLevelResources

@property (nonatomic, readonly) CGImageRef textureImage;

@property (nonatomic, copy, readonly) NSArray *meshes;
@property (nonatomic, copy, readonly) NSArray *rooms;
@property (nonatomic, copy, readonly) NSArray *moveables;

- (TRRenderMoveableDescription *)moveableForObjectID:(NSUInteger)objectID;

- (void)getTextureCoords:(CGPoint *)fourPoints forObjectTexture:(TR1Texture *)texture;
- (CGPoint)textureCoordsForColorIndex:(NSUInteger)colorIndex;

@property (nonatomic, readonly, retain) SCNMaterial *meshInternalLightingMaterial;
@property (nonatomic, readonly, retain) SCNMaterial *meshExternalLightingMaterial;
@property (nonatomic, readonly, retain) SCNMaterial *meshAlphaInternalLightingMaterial;
@property (nonatomic, readonly, retain) SCNMaterial *meshAlphaExternalLightingMaterial;

- (TRRenderLevelSCN *)createRenderLevel;

@end
