//
//  TR1Box.h
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@interface TR1Box : TRStructure

// sector and world are derived from each other, depending on the version. In
// TR1, world is set, and sector is derived. In TR2, it's the other way around.
@property (nonatomic, assign) NSUInteger minSectorZ;
@property (nonatomic, assign) NSUInteger maxSectorZ;
@property (nonatomic, assign) NSUInteger minSectorX;
@property (nonatomic, assign) NSUInteger maxSectorX;

@property (nonatomic, assign) NSUInteger minWorldZ;
@property (nonatomic, assign) NSUInteger maxWorldZ;
@property (nonatomic, assign) NSUInteger minWorldX;
@property (nonatomic, assign) NSUInteger maxWorldX;


// Always the same
@property (nonatomic, assign) NSInteger floorHeight;
@property (nonatomic, assign) NSUInteger overlapIndex;

@end
