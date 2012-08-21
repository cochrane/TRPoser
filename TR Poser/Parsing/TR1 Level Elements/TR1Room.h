//
//  TR1Room.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;

@class TR1Level;
@class TR1RoomVertex;

@interface TR1Room : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak, readonly) TR1Level *level;

@property (nonatomic, assign, readonly) NSUInteger number;

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger z;
@property (nonatomic, assign) NSInteger yBottom;
@property (nonatomic, assign) NSInteger yTop;

@property (nonatomic, retain) NSMutableArray *vertices;
@property (nonatomic, retain) NSMutableArray *rectangles;
@property (nonatomic, retain) NSMutableArray *triangles;
@property (nonatomic, retain) NSMutableArray *sprites;
@property (nonatomic, retain) NSMutableArray *portals;

@property (nonatomic, assign) NSUInteger countOfSectorsX;
@property (nonatomic, assign) NSUInteger countOfSectorsZ;
@property (nonatomic, retain) NSMutableArray *sectors;

@property (nonatomic, retain) NSMutableArray *lights;
@property (nonatomic, retain) NSMutableArray *staticMeshes;

@property (nonatomic, assign) NSUInteger ambientIntensity1;
@property (nonatomic, assign) NSUInteger lightMode;

@property (nonatomic, assign) NSUInteger alternateRoomIndex;
@property (nonatomic, assign) NSUInteger flags;

// Derived values
@property (nonatomic, weak) TR1Room *alternate;
@property (nonatomic, copy) NSColor *roomColor;

// for subclasses to override
- (void)readGlobalLightState:(TRInDataStream *)stream;
- (void)writeGlobalLightState:(TROutDataStream *)stream;

- (void)readRoomFooter:(TRInDataStream *)stream;
- (void)writeRoomFooter:(TROutDataStream *)stream;

- (void)enumerateRoomVertices:(void (^)(TR1RoomVertex *))iterator;

@end
