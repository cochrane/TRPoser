//
//  TR1AnimatedObject.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;

@class TR1AnimationFrame;
@class TR1Level;
@class TR1MeshTreeNode;

@interface TR1AnimatedObject : NSObject

@property (nonatomic, readonly, assign) NSUInteger objectID;
@property (nonatomic, readonly, weak) TR1Level *level;

- (NSUInteger)countOfMeshTreeNodes;
- (TR1MeshTreeNode *)objectInMeshTreeNodeAtIndex:(NSUInteger)index;

- (NSUInteger)countOfFrames;
- (TR1AnimationFrame *)objectInFramesAtIndex:(NSUInteger)index;

// Notice that for animated objects, the data isn't in convenient packages as it is for rooms or meshes. Therefore, the following methods will be called by a TRLevel

- (void)readMeshTreeFrom:(TRInDataStream *)stream;
- (void)readFramesFrom:(TRInDataStream *)stream;
- (void)readAnimationsFrom:(TRInDataStream *)stream;

@end
