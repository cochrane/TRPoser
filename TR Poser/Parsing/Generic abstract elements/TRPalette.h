//
//  TRPalette.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TR1Level;
@class TRInDataStream;
@class TROutDataStream;

@interface TRPalette : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream;
- (void)writeToStream:(TROutDataStream *)stream;

// Called from TRStructure code. Falls through to initFromDataStream:
- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;

// There are always 256 colors. This interface is just to be KVC compliant.
- (NSUInteger)countOfColors;
- (NSColor *)objectInColorsAtIndex:(NSUInteger)index;

@end
