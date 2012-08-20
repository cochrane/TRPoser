//
//  TRPalette.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRPalette.h"

@implementation TRPalette

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	return [self initFromDataStream:stream];
}

- (id)initFromDataStream:(TRInDataStream *)stream
{
	if (!(self = [super init])) return nil;
	
	return self;
}
- (void)writeToStream:(TROutDataStream *)stream;
{
}

- (NSUInteger)countOfColors;
{
	return 0;
}
- (NSColor *)objectInColorsAtIndex:(NSUInteger)index;
{
	return nil;
}


@end
