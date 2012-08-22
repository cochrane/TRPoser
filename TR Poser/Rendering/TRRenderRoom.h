//
//  TRRenderRoom.h
//  TR Poser
//
//  Created by Torsten Kammer on 21.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class TRRenderLevelResources;
@class TRRenderRoomGeometry;
@class TR1Room;

@interface TRRenderRoom : NSObject

- (id)initWithRoomGeometry:(TRRenderRoomGeometry *)room;

@property (nonatomic, retain, readonly) TRRenderRoomGeometry *geometry;
@property (nonatomic, retain, readonly) TR1Room *room;
@property (nonatomic, weak, readonly) TRRenderLevelResources *level;

- (SCNNode *)node;

@property (nonatomic, assign, readonly) SCNVector3 offset;

@end
