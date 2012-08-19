//
//  TR1Camera.h
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@class TR1Room;

@interface TR1Camera : TRStructure

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;
@property (nonatomic, assign) NSUInteger roomIndex;

// Derived
@property (nonatomic, weak) TR1Room *room;

@end
