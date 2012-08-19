//
//  TR2TexturePage16.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2TexturePage16.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR2TexturePage16 ()

@property (nonatomic, copy, readwrite) NSData *pixels;

@end

@implementation TR2TexturePage16

@synthesize pixels;

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super initFromDataStream:stream inLevel:level])) return nil;
	
	self.pixels = [stream dataWithLength:256*256*2];
	
	return self;
}

- (void)writeToDataStream:(TROutDataStream *)stream;
{
	[stream appendData:self.pixels];
}

- (NSUInteger)bitsPerPixel;
{
	return 16;
}

@end
