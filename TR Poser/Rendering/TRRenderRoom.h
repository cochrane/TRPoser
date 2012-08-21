//
//  TRRenderRoom.h
//  TR Poser
//
//  Created by Torsten Kammer on 21.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class TR1Room;
@class TRRenderLevel;

@interface TRRenderRoom : NSObject

- (id)initWithRoom:(TR1Room *)room inRenderLevel:(TRRenderLevel *)level;

@property (nonatomic, retain) TR1Room *room;
@property (nonatomic, retain) TRRenderLevel *level;

// Returns the same geometry every time; it can and will be shared.
- (SCNGeometry *)roomGeometry;

// Returns a new node every time. Who knows what you might want to
// do with it?
- (SCNNode *)createNodeWithStaticGeometry;

@end
