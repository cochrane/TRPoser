//
//  TR1SpriteSequence.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1SpriteSequence.h"

@implementation TR1SpriteSequence

+ (NSString *)structureDescriptionSource
{
	return @"bitu32 objectID;\
	bit16 negativeLength;\
	bitu16 offset;";
}

@end
