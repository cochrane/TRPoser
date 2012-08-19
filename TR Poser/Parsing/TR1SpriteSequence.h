//
//  TR1SpriteSequence.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@interface TR1SpriteSequence : TRStructure

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, assign) NSInteger negativeLength;
@property (nonatomic, assign) NSUInteger offset;

@end
