//
//  TR1MeshTree.h
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@interface TR1MeshTree : TRStructure

@property (nonatomic, assign) NSInteger offsetX;
@property (nonatomic, assign) NSInteger offsetY;
@property (nonatomic, assign) NSInteger offsetZ;
@property (nonatomic, assign) NSUInteger flags;

// Derived
@property (nonatomic, assign) BOOL push;
@property (nonatomic, assign) BOOL pop;

@end
