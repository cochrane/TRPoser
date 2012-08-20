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

// Graphics data, as 32 bits ARGB. Automatically generated where the actual
// bit value is lower, which means this method can be slow.
- (NSData *)pixels32Bit;

@end
