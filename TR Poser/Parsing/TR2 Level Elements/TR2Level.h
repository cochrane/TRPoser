//
//  TR2Level.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Level.h"

@class TROutDataStream;

@class TR2Palette16;

@interface TR2Level : TR1Level

@property (nonatomic, retain) TR2Palette16 *palette16;
@property (nonatomic, retain) NSMutableArray *textureTiles16;

@end
