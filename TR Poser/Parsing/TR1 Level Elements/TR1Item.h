//
//  TR2Item.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@class TR1Room;

@interface TR1Item : TRStructure

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, assign) NSUInteger roomIndex;
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;
@property (nonatomic, assign) NSUInteger angle;
@property (nonatomic, assign) NSUInteger intensity1;
@property (nonatomic, assign) NSUInteger flags;

// Derived properties
@property (nonatomic, weak) TR1Room *room;

@end
