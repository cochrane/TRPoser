//
//  TR1Texture.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@interface TR1Texture : TRStructure

@property (nonatomic, assign) NSUInteger attribute;
@property (nonatomic, assign) NSUInteger tileIndex;
@property (nonatomic, copy) NSArray *vertices;

@end
