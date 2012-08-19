//
//  TR3StaticMeshInstance.h
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2StaticMeshInstance.h"

@interface TR3StaticMeshInstance : TR2StaticMeshInstance

@property (nonatomic, assign) NSUInteger colorField;

// Derived
@property (nonatomic, retain) NSColor *color;


@end
