//
//  TR1Animation.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@class TRInDataStream;
@class TROutDataStream;

@class TRFrame;
@class TR1AnimationCommand;
@class TR1Level;
@class TR1Moveable;
@class TR1StateChange;

@interface TR1Animation : TRStructure

@property (nonatomic, assign) NSUInteger frameOffset;
@property (nonatomic, assign) NSUInteger frameRate;
@property (nonatomic, assign) NSUInteger frameSize;
@property (nonatomic, assign) NSUInteger stateID;
@property (nonatomic, assign) NSUInteger frameStart;
@property (nonatomic, assign) NSUInteger frameEnd;
@property (nonatomic, assign) NSUInteger nextAnimationIndex;
@property (nonatomic, assign) NSUInteger nextFrameIndex;
@property (nonatomic, assign) NSUInteger stateChangesCount;
@property (nonatomic, assign) NSUInteger stateChangesOffset;
@property (nonatomic, assign) NSUInteger animCommandCount;
@property (nonatomic, assign) NSUInteger animCommandOffset;

// Derived attributes
@property (nonatomic, assign, readonly) NSUInteger number;
@property (nonatomic, weak) TR1Animation *nextAnimation;

- (NSUInteger)countOfStateChanges;
- (TR1StateChange *)objectInStateChangesAtIndex:(NSUInteger)index;

- (TRFrame *)frameAtIndex:(NSUInteger)index object:(TR1Moveable *)moveable;

@end
