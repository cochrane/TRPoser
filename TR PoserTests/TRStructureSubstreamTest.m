//
//  TRStructureSubstreamTest.m
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureSubstreamTest.h"

#import "TRStructure.h"
#import "TRInDataStream.h"
#import "TROutDataStream.h"

struct InnerSubstreamTestStruct
{
	uint16_t value1;
	uint8_t value2;
};

struct SubstreamTestStruct
{
	uint16_t dataLength;
	uint8_t data[128];
	uint16_t innerOffset;
};

@interface TRStructureSubstreamTest_Inner : TRStructure
@property (nonatomic, assign) NSUInteger value1;
@property (nonatomic, assign) NSUInteger value2;
@end

@interface TRStructureSubstreamTest_Outer : TRStructure;

@property (nonatomic, retain) TRStructureSubstreamTest_Inner *inner;
@property (nonatomic, assign) NSUInteger innerOffset;

@end

@implementation TRStructureSubstreamTest_Outer

+ (NSString *)structureDescriptionSource
{
	return @"substream data[bitu16]; bitu16 innerOffset";
}

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level
{
	NSDictionary *substreams;
	if (!(self = [super initFromDataStream:stream inLevel:level substreams:&substreams])) return nil;
	
	TRInDataStream *substream = [substreams objectForKey:@"data"];
	substream.position = self.innerOffset;
	self.inner = [[TRStructureSubstreamTest_Inner alloc] initFromDataStream:substream inLevel:level];
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream
{
	TROutDataStream *substream = [[TROutDataStream alloc] init];
	const uint8_t *garbage = (const uint8_t *) "garbage";
	[substream appendUint8Array:garbage count:sizeof(garbage)];
	[self.inner writeToStream:substream];
	
	NSUInteger missing = 128 - substream.length;
	[substream appendUnusedBytes:missing];
	
	self.innerOffset = sizeof(garbage);
	
	[super writeToStream:stream substreams:@{ @"data" : substream }];
}

@end

@implementation TRStructureSubstreamTest_Inner

+(NSString *)structureDescriptionSource
{
	return @"bitu16 value1; bitu8 value2";
}

@end

@implementation TRStructureSubstreamTest

- (void)testSubstreamRead
{
	unsigned offset = 48;
	
	struct SubstreamTestStruct test;
	test.dataLength = 128;
	bzero(test.data, 128);
	
	struct InnerSubstreamTestStruct inner = { 47, 12 };
	memcpy(&(test.data[offset]), &inner, sizeof(inner));
	test.innerOffset = offset;
	
	NSData *data = [NSData dataWithBytes:&test length:sizeof(test)];
	TRInDataStream *stream = [[TRInDataStream alloc] initWithData:data];
	
	TRStructureSubstreamTest_Outer *object = [[TRStructureSubstreamTest_Outer alloc] initFromDataStream:stream inLevel:nil];
	
	STAssertEquals(stream.position, sizeof(test), @"Stream has to be at end of struct.");
	
	STAssertEquals((NSUInteger) inner.value1, object.inner.value1, @"Wrong inner value");
	STAssertEquals((NSUInteger) inner.value2, object.inner.value2, @"Wrong inner value");
}
- (void)testSubstreamWrite
{
	TRStructureSubstreamTest_Outer *object = [[TRStructureSubstreamTest_Outer alloc] init];
	
	TRStructureSubstreamTest_Inner *innerObject = [[TRStructureSubstreamTest_Inner alloc] init];
	innerObject.value1 = 678;
	innerObject.value2 = 98;

	object.inner = innerObject;
	
	TROutDataStream *stream = [[TROutDataStream alloc] init];
	[object writeToStream:stream];
	
	struct SubstreamTestStruct test;
	
	STAssertEquals(stream.length, sizeof(test), @"Stream has to be at end of struct.");
	
	[stream.data getBytes:&test length:sizeof(test)];
	
	struct InnerSubstreamTestStruct *inner = (struct InnerSubstreamTestStruct *) &(test.data[test.innerOffset]);
	
	STAssertEquals((NSUInteger) inner->value1, object.inner.value1, @"Wrong inner value");
	STAssertEquals((NSUInteger) inner->value2, object.inner.value2, @"Wrong inner value");
}

@end
