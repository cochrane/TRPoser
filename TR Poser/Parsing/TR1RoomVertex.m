//
//  TR1RoomVertex.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1RoomVertex.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

#import "TR1Vertex.h"

@implementation TR1RoomVertex

- (id)initFromDataStream:(TRInDataStream *)stream;
{
	if (!(self = [super init])) return nil;
	
	self.position = [[TR1Vertex alloc] initFromDataStream:stream];
	
	self.lighting1 = [stream readUint16];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[self.position writeToStream:stream];
	[stream appendUint16:self.lighting1];
}

@end
