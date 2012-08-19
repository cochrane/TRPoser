//
//  TR1RoomSector.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@class TR1Room;

@interface TR1RoomSector : TRStructure

@property (nonatomic, assign) NSUInteger floorDataIndex;
@property (nonatomic, assign) NSUInteger boxIndex;
@property (nonatomic, assign) NSUInteger roomBelowIndex;
@property (nonatomic, assign) NSInteger floorHeight;
@property (nonatomic, assign) NSUInteger roomAboveIndex;
@property (nonatomic, assign) NSInteger ceilingHeight;

// Derived properties
@property (nonatomic, weak) TR1Room *roomBelow;
@property (nonatomic, weak) TR1Room *roomAbove;
@property (nonatomic, assign) NSInteger worldFloor;
@property (nonatomic, assign) NSInteger worldCeiling;

@end
