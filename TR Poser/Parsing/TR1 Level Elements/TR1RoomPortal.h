//
//  TR1RoomPortal.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@class TR1Vertex;
@class TR1Room;

@interface TR1RoomPortal : TRStructure

@property (nonatomic, assign) NSUInteger otherRoomIndex;
@property (nonatomic, retain) TR1Vertex *normal;
@property (nonatomic, copy) NSArray *vertices;

// Derived properties
@property (nonatomic, weak) TR1Room *otherRoom;

@end
