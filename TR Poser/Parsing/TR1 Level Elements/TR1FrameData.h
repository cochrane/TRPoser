//
//  TRFrameData.h
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;
@class TR1Level;
@class TRFrame;
@class TR1Moveable;

@interface TR1FrameData : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

// The values, both in- and output, are in shorts!
- (NSUInteger)lengthOfFrameAtPosition:(NSUInteger)position forObject:(TR1Moveable *)object;
- (TRFrame *)frameAtOffset:(NSUInteger)position forObject:(TR1Moveable *)object;
- (TRFrame *)frameAtIndex:(NSUInteger)index offset:(NSUInteger)position forObject:(TR1Moveable *)object;

@property (nonatomic, weak, readonly) TR1Level *level;

@property (nonatomic, assign, readonly) const uint16_t *frameData;

@end

