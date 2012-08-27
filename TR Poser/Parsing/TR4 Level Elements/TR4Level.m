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
	bitu16 flatRoomTiles;\
	bitu16 objectTiles;\
	bitu16 bumpedRoomTiles;\
	compressed texture32[u=bitu32, c=bitu32];\
	compressed texture16[u=bitu32, c=bitu32];\
	compressed textureFontAndSky[u=bitu32, c=bitu32];\
	compressed geometry[u=bitu32, c=bitu32];\
	*Sound sounds[bitu32];\
	";
}

- (NSUInteger)gameVersion;
{
	return 4;
}

@end
