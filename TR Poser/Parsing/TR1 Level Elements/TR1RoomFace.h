//
//  TR1RoomFace.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;

@class TR1Room;
@class TR1Texture;

@interface TR1RoomFace : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inRoom:(TR1Room *)room corners:(NSUInteger)corners;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak) TR1Room *room;

@property (nonatomic, retain) NSMutableArray *indices;
@property (nonatomic, assign) NSUInteger surfaceIndex;
@property (nonatomic, assign, readonly) BOOL isTwoSided;

// Derived values
@property (nonatomic, retain) TR1Texture *texture;

@end
