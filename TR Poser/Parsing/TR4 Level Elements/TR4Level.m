//
//  TR4Level.m
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4Level.h"

@implementation TR4Level

+ (NSString *)structureDescriptionSource
{
	return @"const bitu8='T';\
	const bitu8='R';\
	const bitu8='4';\
	const bitu8=0;\
	";
}

- (NSUInteger)gameVersion;
{
	return 4;
}

@end
