//
//  TRRenderMoveable.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TR1Moveable;
@class TRRenderLevelResources;
@class TRRenderMoveableNode;

@interface TRRenderMoveable : NSObject

- (id)initWithMoveable:(TR1Moveable *)moveable inRenderLevel:(TRRenderLevelResources *)level;

@property (nonatomic, retain, readonly) TR1Moveable *moveable;
@property (nonatomic, weak, readonly) TRRenderLevelResources *level;

@property (nonatomic, retain, readonly) TRRenderMoveableNode *rootNode;

@end

@interface TRRenderMoveableNode : NSObject


@end
