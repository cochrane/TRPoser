//
//  TR1MeshVertex.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;

@interface TR1Vertex : NSObject

// Initializer for TRSimpleStructure. Calls through to initFromDataStream:
- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(id)level;

- (id)initFromDataStream:(TRInDataStream *)stream;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;

@end
