//
//  TRRenderRoom.h
//  TR Poser
//
//  Created by Torsten Kammer on 21.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class TRRenderLevelResourcesSCN;
@class TRRenderRoomGeometrySCN;
@class TR1Room;

@interface TRRenderRoomSCN : NSObject

- (id)initWithRoomGeometry:(TRRenderRoomGeometrySCN *)room;

@property (nonatomic, retain, readonly) TRRenderRoomGeometrySCN *geometry;
@property (nonatomic, retain, readonly) TR1Room *room;

- (SCNNode *)node;

@property (nonatomic, assign, readonly) SCNVector3 offset;

@end
