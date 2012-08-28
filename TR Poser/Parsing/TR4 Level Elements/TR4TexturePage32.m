//
//  TR4TexturePage32.m
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4TexturePage32.h"

#import <Accelerate/Accelerate.h>

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR4TexturePage32 ()
{
	uint8_t pixels[4*256*256] __attribute__(( aligned (16) ));
}

@end

@implementation TR4TexturePage32

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super initFromDataStream:stream inLevel:level])) return nil;
	
	NSAssert(!stream.isAtEnd, @"Stream mustn't be at end now.");
	
	[stream readUint8Array:pixels count:sizeof(pixels)];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint8Array:pixels count:sizeof(pixels)];
}

- (NSData *)pixels32Bit;
{
	uint8_t *result = malloc(sizeof(pixels));
	
	vImage_Buffer inbuffer = { pixels, 256, 256, 1024 };
	vImage_Buffer outbuffer = { result, 256, 256, 1024 };
	
	vImagePermuteChannels_ARGB8888(&inbuffer, &outbuffer, (const uint8[4]) { 3, 2, 1, 0 }, 0);
	
	return [NSData dataWithBytesNoCopy:result length:sizeof(pixels) freeWhenDone:YES];
}

@end
