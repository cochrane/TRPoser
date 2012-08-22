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
@class TRRenderLevelResources;
@class TRRenderMoveableDescriptionNode;

@interface TRRenderMoveableDescription : NSObject

- (id)initWithMoveable:(TR1Moveable *)moveable inRenderLevel:(TRRenderLevelResources *)level;

@property (nonatomic, retain, readonly) TR1Moveable *moveable;
@property (nonatomic, weak, readonly) TRRenderLevelResources *level;

@property (nonatomic, retain, readonly) TRRenderMoveableDescriptionNode *rootNode;

@end

@interface TRRenderMoveableDescriptionNode : NSObject

@property (nonatomic, weak) TRRenderMoveableDescriptionNode *parent;
@property (nonatomic, retain) NSMutableArray *children;

@property (nonatomic, assign) SCNVector3 offset;

@property (nonatomic, assign) NSUInteger meshIndex;

@end
