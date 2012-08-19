//
//  TR1SpriteTexture.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@interface TR1SpriteTexture : TRStructure

@property (nonatomic, assign) NSUInteger tileIndex;
@property (nonatomic, assign) NSUInteger x;
@property (nonatomic, assign) NSUInteger y;
@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
@property (nonatomic, assign) NSInteger leftSide;
@property (nonatomic, assign) NSInteger topSide;
@property (nonatomic, assign) NSInteger rightSide;
@property (nonatomic, assign) NSInteger bottomSide;

@end
