//
//  TR2TexturePage16.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2TexturePage16.h"

#import <Accelerate/Accelerate.h>

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR2TexturePage16 ()
{
	uint16_t pixels[256*256];
}

@end

@implementation TR2TexturePage16

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super initFromDataStream:stream inLevel:level])) return nil;
	
	[stream readUint16Array:pixels count:256*256];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint16Array:pixels count:256*256];
}

- (NSData *)pixels32Bit;
{
	vImage_Buffer inputBuffer = { pixels, 256, 256, 512 };
	
	uint8_t *output = malloc(256*256*4);
	vImage_Buffer outputBuffer = { output, 256, 256, 1024 };
	
	vImageConvert_ARGB1555toARGB8888(&inputBuffer, &outputBuffer, 0);
	
	return [NSData dataWithBytesNoCopy:output length:256*256*4];
}

@end
