//
//  TR1StaticMeshInstance.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <AppKit/NSColor.h>
#import <Foundation/Foundation.h>

#import "TRStructure.h"

@class TRInDataStream;
@class TROutDataStream;

@class TR1Level;
@class TR1StaticMesh;

@interface TR1StaticMeshInstance : TRStructure

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;
@property (nonatomic, assign) NSInteger rotation;
@property (nonatomic, assign) NSUInteger intensity1;
@property (nonatomic, assign) NSUInteger objectID;

// Derived values
@property (nonatomic, assign) float rotationInDegrees;
@property (nonatomic, assign) float rotationInRad;
@property (nonatomic, weak) TR1StaticMesh *mesh;
@property (nonatomic, weak) NSColor *color;

@end
