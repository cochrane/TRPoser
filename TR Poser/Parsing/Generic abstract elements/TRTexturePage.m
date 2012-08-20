//
//  TRTexturePage.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRTexturePage.h"

@implementation TRTexturePage

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	_level = level;
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
	
}

- (NSData *)pixels32Bit;
{
	return nil;
}

@end
