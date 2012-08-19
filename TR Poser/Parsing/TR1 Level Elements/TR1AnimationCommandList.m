//
//  TR1AnimationCommandList.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1AnimationCommandList.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TR1AnimationCommandList ()
{
	NSUInteger numCommands;
	uint16_t *commands;
}

@end

@implementation TR1AnimationCommandList

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	_level = level;
	
	numCommands = [stream readUint32];
	commands = malloc(numCommands * sizeof(uint16_t));
	[stream readUint16Array:commands count:numCommands];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint32:(uint32_t) numCommands];
	[stream appendUint16Array:commands count:numCommands];
}

- (NSUInteger)countOfCommands;
{
	return numCommands;
}

- (NSNumber *)objectInCommandsAtIndex:(NSUInteger)code;
{
	NSAssert(code < numCommands, @"Command has to be less than %lu, is %lu", numCommands, code);
	return @(commands[code]);
}

@end

