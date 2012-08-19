//
//  TR1Lightmap.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Lightmap.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR1Lightmap ()
{
	uint8_t lightmap[32*256];
}

@end

@implementation TR1Lightmap

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level
{
	if (!(self = [super init])) return nil;
	
	[stream readUint8Array:lightmap count:sizeof(lightmap)];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream
{
	[stream appendUint8Array:lightmap count:sizeof(lightmap)];
}

@end
