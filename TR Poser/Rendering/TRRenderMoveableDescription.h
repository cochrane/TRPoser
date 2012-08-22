//
//  TRRenderMoveableDescription.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SceneKit/SceneKit.h>

@class TR1Moveable;
@class TRRenderLevelResourcesSCN;
@class TRRenderMoveableDescriptionNode;

@interface TRRenderMoveableDescription : NSObject

- (id)initWithMoveable:(TR1Moveable *)moveable inRenderLevel:(TRRenderLevelResourcesSCN *)level;

@property (nonatomic, retain, readonly) TR1Moveable *moveable;
@property (nonatomic, weak, readonly) TRRenderLevelResourcesSCN *level;

@property (nonatomic, retain, readonly) TRRenderMoveableDescriptionNode *rootNode;

@end

@interface TRRenderMoveableDescriptionNode : NSObject

@property (nonatomic, weak) TRRenderMoveableDescriptionNode *parent;
@property (nonatomic, retain) NSMutableArray *children;

@property (nonatomic, assign) double offsetX;
@property (nonatomic, assign) double offsetY;
@property (nonatomic, assign) double offsetZ;

@property (nonatomic, assign) NSUInteger meshIndex;

@end
