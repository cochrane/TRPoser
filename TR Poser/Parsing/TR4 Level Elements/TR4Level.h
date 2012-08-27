//
//  TR4Level.h
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR3Level.h"

@interface TR4Level : TR3Level

@property (nonatomic, assign) NSUInteger flatRoomTiles;
@property (nonatomic, assign) NSUInteger objectTiles;
@property (nonatomic, assign) NSUInteger bumpedRoomTiles;

@property (nonatomic, retain) NSMutableArray *sounds;
@property (nonatomic, retain) NSMutableArray *textureTiles32;
@property (nonatomic, retain) NSMutableArray *specialTextureTiles;

@end
