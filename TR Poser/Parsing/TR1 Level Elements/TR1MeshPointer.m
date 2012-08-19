//
//  TR1MeshPointer.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1MeshPointer.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@implementation TR1MeshPointer

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	self.meshStartOffset = [stream readUint32];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[stream appendUint32:(uint32_t) self.meshStartOffset];
}


@end
