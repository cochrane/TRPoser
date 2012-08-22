//
//  TRRenderRoomGeometry.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class TR1Room;
@class TRRenderLevelResources;

@interface TRRenderRoomGeometry : NSObject

- (id)initWithRoom:(TR1Room *)room inRenderLevel:(TRRenderLevelResources *)level;

@property (nonatomic, retain) TR1Room *room;
@property (nonatomic, retain) TRRenderLevelResources *level;

// Returns the same geometry every time; it can and will be shared.
- (SCNGeometry *)roomGeometry;

@property (nonatomic, assign, readonly) SCNVector3 offset;


@end
