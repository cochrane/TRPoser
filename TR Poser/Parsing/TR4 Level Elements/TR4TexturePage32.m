//
//  TR4TexturePage32.m
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR4TexturePage32.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR4TexturePage32 ()
{
	uint8_t pixels[4*256*256];
}

@end

@implementation TR4TexturePage32

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super initFromDataStream:stream inLevel:level])) return nil;
	
	[stream readUint8Array:pixels count:sizeof(pixels)];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint8Array:pixels count:sizeof(pixels)];
}

- (NSData *)pixels32Bit;
{
	return [NSData dataWithBytes:pixels length:sizeof(pixels)];
}

@end
