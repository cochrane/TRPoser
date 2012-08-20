//
//  TRTexturePage.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;

@class TR1Level;

@interface TRTexturePage : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak) TR1Level *level;

// Graphics data, as 16, 24 or 32 bits. This automatically generates one of the above from a paletted texture.
@property (nonatomic, assign, readonly) NSUInteger bitsPerPixel;
@property (nonatomic, copy, readonly) NSData *pixels;

@end
