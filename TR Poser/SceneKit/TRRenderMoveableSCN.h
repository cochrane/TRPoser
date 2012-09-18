//
//  TRRenderMoveable.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class TR1Animation;
@class TRRenderMoveableDescription;
@class TRRenderMoveableDescriptionNode;
@class TRRenderMoveableNode;
@class TRRenderRoomSCN;

@interface TRRenderMoveableSCN : NSObject

- (id)initWithDescription:(TRRenderMoveableDescription *)description;

@property (nonatomic, retain, readonly) TRRenderMoveableDescription *description;

@property (nonatomic, retain, readonly) TRRenderMoveableNode *rootNode;

@property (nonatomic, assign) SCNVector3 offset;
@property (nonatomic, assign) double rotation;
@property (nonatomic, retain) TRRenderRoomSCN *room;

@property (nonatomic, retain, readonly) SCNNode *sceneRoot;

- (void)setFrame:(NSUInteger)frame ofAnimation:(TR1Animation *)animation;
- (void)setFrame:(NSUInteger)frame ofRelativeAnimation:(NSUInteger)animation;

@end

@interface TRRenderMoveableNode : NSObject

- (id)initWithDescription:(TRRenderMoveableDescriptionNode *)node partOf:(TRRenderMoveableSCN *)moveable;

@property (nonatomic, copy, readonly) NSArray *children;

@property (nonatomic, assign) double rotationX;
@property (nonatomic, assign) double rotationY;
@property (nonatomic, assign) double rotationZ;

@property (nonatomic, assign) SCNVector3 offset;

@property (nonatomic, assign, readonly) CATransform3D transformation;

@property (nonatomic, retain, readonly) SCNNode *node;

- (void)enumerate:(void(^)(TRRenderMoveableNode *))iterator;

@end
