//
//  TR1SoundSource.h
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@interface TR1SoundSource : TRStructure

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;

@property (nonatomic, assign) NSUInteger soundID;
@property (nonatomic, assign) NSUInteger flags;

@end
