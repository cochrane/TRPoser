//
//  TR1RoomVertex.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;

@class TR1Vertex;

@interface TR1RoomVertex : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, retain) TR1Vertex *position;
@property (nonatomic, assign) NSUInteger lighting1;

@end
