//
//  TRSimpleStructure.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRSimpleStructureDescription;

@class TRInDataStream;
@class TROutDataStream;

@class TR1Level;

@interface TRSimpleStructure : NSObject

+ (TRSimpleStructureDescription *)structureDescription;

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (void)writeToStream:(TROutDataStream *)stream;

@property (nonatomic, weak, readonly) TR1Level *level;

@end
