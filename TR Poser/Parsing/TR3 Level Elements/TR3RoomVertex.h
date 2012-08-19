//
//  TR3RoomVertex.h
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2RoomVertex.h"

@interface TR3RoomVertex : TR2RoomVertex

@property (nonatomic, assign) NSUInteger colorField;

// Derived
@property (nonatomic, retain) NSColor *color;

@end
