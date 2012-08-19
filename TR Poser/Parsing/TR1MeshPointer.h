//
//  TR1MeshPointer.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;
@class TR1Mesh;
@class TR1Level;

@interface TR1MeshPointer : NSObject

// The level is ignored.
- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, assign) NSUInteger meshStartOffset;

// Note: This is not derived, but set by the level!
@property (nonatomic, retain) TR1Mesh *mesh;

@end
