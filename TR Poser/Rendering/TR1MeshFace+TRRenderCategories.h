//
//  TR1MeshFace+TRRenderCategories.h
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1MeshFace.h"
#import "TR1RoomFace.h"
#import "TR1Vertex.h"
#import "TR1RoomVertex.h"

#import <SceneKit/SceneKit.h>

@interface TR1MeshFace (TRRenderCategoriesSCN)

- (SCNVector3)positionAtCorner:(NSUInteger)index;
- (SCNVector3)normalAtCorner:(NSUInteger)index;
- (SCNVector3)lightAtCorner:(NSUInteger)index;

@end

@interface TR1RoomFace (TRRenderCategoriesSCN)

- (SCNVector3)positionAtCorner:(NSUInteger)index;
- (SCNVector3)lightAtCorner:(NSUInteger)index;

@end

@interface TR1Vertex (TRRenderCategoriesSCN)

- (SCNVector3)sceneKitVector;

@end

@interface TR1RoomVertex (TRRenderCategoriesSCN)

- (SCNVector3)sceneKitVector;

@end
