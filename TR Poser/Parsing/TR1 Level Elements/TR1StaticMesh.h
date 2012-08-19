//
//  TR1StaticMesh.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@class TR1Item;
@class TR1MeshPointer;

@interface TR1StaticMesh : TRStructure

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, assign) NSUInteger meshIndex;
@property (nonatomic, retain) NSMutableArray *boundingBox;
@property (nonatomic, assign) NSUInteger flags;

// Derived properties
@property (nonatomic, weak) TR1Item *item;
@property (nonatomic, weak) TR1MeshPointer *mesh;

@end
