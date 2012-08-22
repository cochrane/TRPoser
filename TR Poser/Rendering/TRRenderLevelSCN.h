//
//  TRRenderLevel.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class TRRenderLevelResources;

@interface TRRenderLevelSCN : NSObject

- (id)initWithResources:(TRRenderLevelResources *)resources;

@property (nonatomic, retain, readonly) TRRenderLevelResources *resources;
@property (nonatomic, retain, readonly) SCNNode *rootNode;
@property (nonatomic, retain, readonly) NSArray *rooms;
@property (nonatomic, retain, readonly) NSArray *moveables;

@end
