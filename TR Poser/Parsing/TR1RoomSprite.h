//
//  TR1RoomSprite.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;
@class TR1Room;
@class TR1Vertex;
@class TR1Texture;

@interface TR1RoomSprite : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inRoom:(TR1Room *)room;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak, readonly) TR1Room *room;

@property (nonatomic, assign) NSUInteger vertexIndex;
@property (nonatomic, assign) NSUInteger textureIndex;

// Derived properties
@property (nonatomic, weak, readonly) TR1Vertex *position;
@property (nonatomic, weak) TR1Texture *texture;

@end
