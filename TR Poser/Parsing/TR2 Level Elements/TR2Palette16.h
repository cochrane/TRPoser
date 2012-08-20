//
//  TR2Palette16.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRPalette.h"

@interface TR2Palette16 : TRPalette

- (id)initFromDataStream:(TRInDataStream *)stream;
- (void)writeToStream:(TROutDataStream *)stream;

- (NSColor *)objectInColorsAtIndex:(NSUInteger)index;

- (NSData *)asTexturePage;

@end
