//
//  TR1AnimDispatch.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@class TR1Animation;

@interface TR1AnimationDispatch : TRStructure

@property (nonatomic, assign) NSUInteger low;
@property (nonatomic, assign) NSUInteger high;
@property (nonatomic, assign) NSUInteger nextAnimationIndex;
@property (nonatomic, assign) NSUInteger nextFrameIndex;

// Derived properties
@property (nonatomic, weak) TR1Animation *nextAnimation;

@end
