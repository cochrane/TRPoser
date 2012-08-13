//
//  TR1MeshFace.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;

@class TR1Mesh;
@class TR1Texture;

@interface TR1MeshFace : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inMesh:(TR1Mesh *)mesh corners:(NSUInteger)corners isTextured:(BOOL)isTextured;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak, readonly) TR1Mesh *mesh;

@property (nonatomic, assign) BOOL isTextured;

@property (nonatomic, retain, readonly) NSMutableArray *indices;
@property (nonatomic, assign) NSUInteger surfaceIndex;
@property (nonatomic, assign, readonly) BOOL hasAlpha;
@property (nonatomic, assign, readonly) float shininess;

// Derived values
@property (nonatomic, retain) TR1Texture *texture;

@end
