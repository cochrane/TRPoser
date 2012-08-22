//
//  TRRenderMesh.h
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class TR1Mesh;
@class TRRenderLevelResourcesSCN;

@interface TRRenderMeshSCN : NSObject

- (id)initWithMesh:(TR1Mesh *)mesh inRenderLevel:(TRRenderLevelResourcesSCN *)level;

@property (nonatomic, retain, readonly) TR1Mesh *mesh;
@property (nonatomic, weak, readonly) TRRenderLevelResourcesSCN *level;

- (SCNGeometry *)meshGeometry;

@end
