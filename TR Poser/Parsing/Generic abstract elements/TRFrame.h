//
//  TRFrame.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TR1Moveable;

@interface TRFrame : NSObject

- (id)initWithCountOfAngles:(NSUInteger)angles;

// Uninitialized angles are guaranteed to be 0.
- (void)setRotationX:(NSUInteger)x y:(NSUInteger)y z:(NSUInteger)z atIndex:(NSUInteger)index;

- (NSUInteger)rotationXAtIndex:(NSUInteger)index;
- (NSUInteger)rotationYAtIndex:(NSUInteger)index;
- (NSUInteger)rotationZAtIndex:(NSUInteger)index;

- (double)rotationXInRadAtIndex:(NSUInteger)index;
- (double)rotationYInRadAtIndex:(NSUInteger)index;
- (double)rotationZInRadAtIndex:(NSUInteger)index;

@property (nonatomic, assign) NSInteger boundingBoxMinX;
@property (nonatomic, assign) NSInteger boundingBoxMinY;
@property (nonatomic, assign) NSInteger boundingBoxMinZ;

@property (nonatomic, assign) NSInteger boundingBoxMaxX;
@property (nonatomic, assign) NSInteger boundingBoxMaxY;
@property (nonatomic, assign) NSInteger boundingBoxMaxZ;

@property (nonatomic, assign) NSInteger offsetX;
@property (nonatomic, assign) NSInteger offsetY;
@property (nonatomic, assign) NSInteger offsetZ;

@end
