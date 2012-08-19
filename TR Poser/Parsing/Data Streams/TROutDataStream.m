//
//  TR1OutDataStream.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TROutDataStream.h"

@interface TROutDataStream ()
{
	NSMutableData *streamData;
}

@end

@implementation TROutDataStream

- (id)init
{
	if (!(self = [super init])) return nil;
	
	streamData = [[NSMutableData alloc] init];
	
	return self;
}

- (void)appendUint32:(uint32_t)value;
{
	[self appendUint32Array:&value count:1];
}
- (void)appendUint16:(uint16_t)value;
{
	[self appendUint16Array:&value count:1];
}
- (void)appendUint8:(uint8_t)value;
{
	[self appendUint8Array:&value count:1];
}
- (void)appendFloat32:(Float32)value;
{
	[self appendUint32Array:(uint32_t *) &value count:1];
}
- (void)appendInt32:(int32_t)value;
{
	[self appendUint32Array:(uint32_t *)&value count:1];
}
- (void)appendInt16:(int16_t)value;
{
	[self appendUint16Array:(uint16_t *) &value count:1];
}
- (void)appendInt8:(int8_t)value;
{
	[self appendUint8Array:(uint8_t *) &value count:1];
}

- (void)appendUint32Array:(const uint32_t *)array count:(NSUInteger)count;
{
	[self appendUint8Array:(uint8_t *) array count:count*4];
}

- (void)appendUint16Array:(const uint16_t *)array count:(NSUInteger)count;
{
	[self appendUint8Array:(uint8_t *) array count:count*2];
}
- (void)appendUint8Array:(const uint8_t *)array count:(NSUInteger)count;
{
	[streamData appendBytes:array length:count];
}
- (void)appendFloat32Array:(const Float32 *)array count:(NSUInteger)count;
{
	[self appendUint8Array:(uint8_t *) array count:count*4];
}

- (void)appendData:(NSData *)data
{
	[streamData appendData:data];
}

- (void)appendStream:(TROutDataStream *)stream;
{
	[self appendData:stream.data];
}



- (void)appendUnusedBytes:(NSUInteger)bytes;
{
	uint8_t uninitialized[bytes];
	
	[self appendUint8Array:uninitialized count:bytes];
}


- (NSData *)data;
{
	return streamData;
}
- (NSUInteger)length;
{
	return streamData.length;
}

@end
