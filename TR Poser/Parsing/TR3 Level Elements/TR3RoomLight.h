//
//  TR3RoomLight.h
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2RoomLight.h"

@interface TR3RoomLight : TR2RoomLight

@property (nonatomic, assign) uint8_t red;
@property (nonatomic, assign) uint8_t green;
@property (nonatomic, assign) uint8_t blue;
@property (nonatomic, assign) uint8_t unused;

@property (nonatomic, retain) NSColor *color;

@end
