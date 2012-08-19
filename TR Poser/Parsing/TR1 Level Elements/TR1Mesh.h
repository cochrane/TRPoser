//
//  TR1Mesh.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;

@class TR1Level;
@class TR1MeshFace;
@class TR1Vertex;

@interface TR1Mesh : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak, readonly) TR1Level *level;

@property (nonatomic, retain) TR1Vertex *collisionSphereCenter;
@property (nonatomic, assign) NSInteger collisionSphereRadius;

@property (nonatomic, retain, readonly) NSMutableArray *vertices;
@property (nonatomic, retain, readonly) NSMutableArray *normals;
@property (nonatomic, retain, readonly) NSMutableArray *lightIntensities;

@property (nonatomic, retain, readonly) NSMutableArray *texturedTriangles;
@property (nonatomic, retain, readonly) NSMutableArray *texturedRectangles;
@property (nonatomic, retain, readonly) NSMutableArray *coloredTriangles;
@property (nonatomic, retain, readonly) NSMutableArray *coloredRectangles;

@property (readonly, nonatomic, assign) NSUInteger number;
@property (readonly, nonatomic, assign) BOOL usesInternalLighting;

@end
