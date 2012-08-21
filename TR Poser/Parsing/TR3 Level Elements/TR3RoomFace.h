//
//  TR3RoomFace.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomFace.h"

@interface TR3RoomFace : TR1RoomFace

- (id)initFromDataStream:(TRInDataStream *)stream inRoom:(TR1Room *)room corners:(NSUInteger)corners;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, assign, readwrite) BOOL isTwoSided;
@property (nonatomic, assign, readonly) BOOL hasAlpha;

@end
