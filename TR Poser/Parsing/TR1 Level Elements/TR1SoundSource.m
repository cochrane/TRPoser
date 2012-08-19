//
//  TR1SoundSource.m
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1SoundSource.h"

@implementation TR1SoundSource

+ (NSString *)structureDescriptionSource
{
	return @"bit32 x;\
	bit32 y;\
	bit32 z;\
	bitu16 soundID;\
	bitu16 flags;";
}

@end
