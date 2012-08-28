//
//  TR4RoomLight.h
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2RoomLight.h"

@interface TR4RoomLight : TR2RoomLight

@property (nonatomic, assign) uint8_t red;
@property (nonatomic, assign) uint8_t green;
@property (nonatomic, assign) uint8_t blue;

@property (nonatomic, assign) NSUInteger lightType;
@property (nonatomic, assign) NSUInteger unknown;
@property (nonatomic, assign) CGFloat in;
@property (nonatomic, assign) CGFloat out;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) CGFloat cutoff;
@property (nonatomic, assign) CGFloat directionX;
@property (nonatomic, assign) CGFloat directionY;
@property (nonatomic, assign) CGFloat directionZ;

@end
