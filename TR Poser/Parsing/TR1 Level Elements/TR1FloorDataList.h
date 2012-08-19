//
//  TR1FloorDataList.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;
@class TR1Level;

@interface TR1FloorDataList : NSObject

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak, readonly) TR1Level *level;

- (NSUInteger)countOfCodes;
- (NSNumber *)objectInCodesAtIndex:(NSUInteger)code;

@end
