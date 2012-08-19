//
//  TR1Zone.h
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@interface TR1Zone : TRStructure

@property (nonatomic, assign) NSUInteger ground1Normal;
@property (nonatomic, assign) NSUInteger ground2Normal;
@property (nonatomic, assign) NSUInteger flyNormal;

@property (nonatomic, assign) NSUInteger ground1Alternate;
@property (nonatomic, assign) NSUInteger ground2Alternate;
@property (nonatomic, assign) NSUInteger flyAlternate;

@end
