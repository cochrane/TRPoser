//
//  TRFrameData.h
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;
@class TR1Level;

@interface TR1FrameData : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak, readonly) TR1Level *level;

@end

