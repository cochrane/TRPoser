//
//  TR1RoomLight.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@interface TR1RoomLight : TRStructure

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;

// Suffix 1 because in TR2 and higher, there is an intensity2/fade2
@property (nonatomic, assign) NSUInteger intensity1;
@property (nonatomic, assign) NSUInteger fade1;

// Derived
@property (nonatomic, weak) NSColor *color;

@end
