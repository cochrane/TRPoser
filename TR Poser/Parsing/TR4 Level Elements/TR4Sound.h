//
//  TR4Sound.h
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TR1Level;
@class TRInDataStream;
@class TROutDataStream;

@interface TR4Sound : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, copy) NSData *soundData;

@end
