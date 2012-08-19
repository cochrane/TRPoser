//
//  TR1SoundMap.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1SoundMap.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR1SoundMap ()
{
	uint16_t *sounds;
}

@end

@implementation TR1SoundMap

- (NSUInteger)countOfEntries
{
	return 256;
}

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level
{
	if (!(self = [super init])) return nil;
	
	sounds = malloc(sizeof(uint16_t) * self.countOfEntries);
	[stream readUint16Array:sounds count:self.countOfEntries];
	
	return self;
}

- (void)dealloc
{
	free(sounds);
}

- (void)writeToStream:(TROutDataStream *)stream
{
	[stream appendUint16Array:sounds count:self.countOfEntries];
}

@end
