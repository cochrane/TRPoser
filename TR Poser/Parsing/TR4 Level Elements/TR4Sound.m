//
//  TR4Sound.m
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4Sound.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@implementation TR4Sound

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	NSAssert(![stream isAtEnd], @"Stream %@ cannot be at end yet.", stream);
	
	NSUInteger uncompressedSize = [stream readUint32];
	NSUInteger compressedSize = [stream readUint32];
	
	if (compressedSize == uncompressedSize)
	{
		TRInDataStream *sound = [stream substreamWithLength:compressedSize];
		self.soundData = sound.levelData;
	}
	else
	{
		TRInDataStream *decompressedSound = [stream decompressStreamCompressedLength:compressedSize uncompressedLength:uncompressedSize];
		self.soundData = decompressedSound.levelData;
	}
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	TROutDataStream *soundStream = [[TROutDataStream alloc] init];
	[soundStream appendData:self.soundData];
	
	NSData *compressedData = [soundStream compressed];
	
	[stream appendUint32:(uint32_t) self.soundData.length];
	[stream appendUint32:(uint32_t) compressedData.length];
	[stream appendData:compressedData];
}

@end
