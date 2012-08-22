//
//  TR1Moveable.h
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@class TR1Animation;

@interface TR1Moveable : TRStructure

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, assign) NSUInteger meshCount;
@property (nonatomic, assign) NSUInteger meshStart;
@property (nonatomic, assign) NSUInteger meshTreeOffset;
@property (nonatomic, assign) NSUInteger frameOffset;
@property (nonatomic, assign) NSUInteger animationOffset;

@property (nonatomic, weak) TR1Animation *firstAnimation;

@end
