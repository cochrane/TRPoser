//
//  TR1Palette8.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRPalette.h"

@interface TR1Palette8 : TRPalette

- (id)initFromDataStream:(TRInDataStream *)stream;
- (void)writeToStream:(TROutDataStream *)stream;

- (NSUInteger)countOfColors;
- (NSColor *)objectInColorsAtIndex:(NSUInteger)index;
- (void)getColor:(uint8_t *)rgb atIndex:(NSUInteger)index;

@end
