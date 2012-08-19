//
//  TRLevelTest_GreatWall.h
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class TRInDataStream;

@interface TRLevelTest_GreatWall : SenTestCase

- (NSURL *)greatWallURL;
- (TRInDataStream *)greatWallData;

@end
