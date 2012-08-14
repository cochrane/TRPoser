//
//  TRSimpleStructureTest.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRSimpleStructureTest.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"
#import "TRSimpleStructure.h"
#import "TRSimpleStructureDescription.h"

#pragma mark Test data structures

struct TestStruct {
	uint32_t dword;
	uint8_t byte1;
	uint8_t byte2;
	uint16_t word;
	int32_t negative;
} __attribute__((packed));

struct ComplexTestStruct {
	int32_t dword;
	uint8_t alignmentScrewup;
	struct TestStruct inherited;
	uint8_t followUp;
} __attribute__((packed));

@interface TRSimpleStructureTest_TestClass : TRSimpleStructure

@property (nonatomic, assign) NSUInteger dword;
@property (nonatomic, assign) NSUInteger byte1;
@property (nonatomic, assign) NSUInteger byte2;
@property (nonatomic, assign) NSUInteger word;
@property (nonatomic, assign) NSInteger negative;

@end

@implementation TRSimpleStructureTest_TestClass

@synthesize dword, byte1, byte2, word, negative;

+ (TRSimpleStructureDescription *)structureDescription
{
	return [[TRSimpleStructureDescription alloc] initWithSource:@"bitu32 dword; bitu8 byte1; bitu8 byte2; bitu16 word; bit32 negative"];
}

@end

@interface TRSimpleStructureTest_ComplexTestClass : TRSimpleStructure

@property (nonatomic, assign) NSUInteger dword;
@property (nonatomic, assign) NSUInteger alignmentScrewup;
@property (nonatomic, retain) TRSimpleStructureTest_TestClass *inherited;
@property (nonatomic, assign) NSUInteger followUp;

@end

@implementation TRSimpleStructureTest_ComplexTestClass

@synthesize dword, alignmentScrewup, inherited, followUp;

+ (TRSimpleStructureDescription *)structureDescription
{
	return [[TRSimpleStructureDescription alloc] initWithSource:@"bitu32 dword; bitu8 alignmentScrewup; TRSimpleStructureTest_TestClass inherited; bitu8 followUp"];
}

@end

#pragma mark -
#pragma mark Test case

@implementation TRSimpleStructureTest

- (void)testSimpleRead
{
	struct TestStruct test = {
		UINT16_MAX + 2,
		128,
		12,
		259,
		-42
	};
	
	NSData *testData = [NSData dataWithBytes:&test length:sizeof(test)];
	TRInDataStream *stream = [[TRInDataStream alloc] initWithData:testData];
	
	TRSimpleStructureTest_TestClass *object = [[TRSimpleStructureTest_TestClass alloc] initFromDataStream:stream inLevel:nil];
	
	STAssertEquals(stream.position, sizeof(test), @"Position is less than size of test data");
	
	STAssertEquals((NSUInteger) test.dword, object.dword, @"Read dword does not equal.");
	STAssertEquals((NSUInteger) test.byte1, object.byte1, @"Read byte does not equal.");
	STAssertEquals((NSUInteger) test.byte2, object.byte2, @"Read byte does not equal.");
	STAssertEquals((NSUInteger) test.word, object.word, @"Read word does not equal.");
	STAssertEquals((NSInteger) test.negative, object.negative, @"Read negative value does not equal.");
}

- (void)testSimpleWrite
{
	TRSimpleStructureTest_TestClass *object = [[TRSimpleStructureTest_TestClass alloc] init];
	
	object.dword = UINT16_MAX + 2;
	object.byte1 = 128;
	object.byte2 = 12;
	object.word = 259;
	object.negative = -42;
	
	TROutDataStream *stream = [[TROutDataStream alloc] init];
	[object writeToStream:stream];
	
	struct TestStruct test;
	STAssertEquals(stream.length, sizeof(test), @"Length is not equal to test data");
	
	[stream.data getBytes:&test length:sizeof(test)];
	
	STAssertEquals((NSUInteger) test.dword, object.dword, @"Written dword does not equal.");
	STAssertEquals((NSUInteger) test.byte1, object.byte1, @"Written byte does not equal.");
	STAssertEquals((NSUInteger) test.byte2, object.byte2, @"Written byte does not equal.");
	STAssertEquals((NSUInteger) test.word, object.word, @"Written word does not equal.");
	STAssertEquals((NSInteger) test.negative, object.negative, @"Written negative value does not equal.");
}

- (void)testComplexRead;
{
	struct ComplexTestStruct test = {
		40000,
		129,
		{
			UINT16_MAX + 2,
			128,
			12,
			259,
			-42
		},
		0
	};
	
	NSData *testData = [NSData dataWithBytes:&test length:sizeof(test)];
	TRInDataStream *stream = [[TRInDataStream alloc] initWithData:testData];
	
	TRSimpleStructureTest_ComplexTestClass *object = [[TRSimpleStructureTest_ComplexTestClass alloc] initFromDataStream:stream inLevel:nil];
	
	STAssertEquals(stream.position, sizeof(test), @"Position is less than size of test data");
	
	STAssertEquals((NSUInteger) test.dword, object.dword, @"Read dword does not equal.");
	STAssertEquals((NSUInteger) test.alignmentScrewup, object.alignmentScrewup, @"Read byte does not equal.");
	
	STAssertEquals((NSUInteger) test.inherited.dword, object.inherited.dword, @"Read inherited dword does not equal.");
	STAssertEquals((NSUInteger) test.inherited.byte1, object.inherited.byte1, @"Read inherited byte does not equal.");
	STAssertEquals((NSUInteger) test.inherited.byte2, object.inherited.byte2, @"Read inherited byte does not equal.");
	STAssertEquals((NSUInteger) test.inherited.word, object.inherited.word, @"Read inherited word does not equal.");
	STAssertEquals((NSInteger) test.inherited.negative, object.inherited.negative, @"Read inherited negative value does not equal.");
	
	STAssertEquals((NSUInteger) test.followUp, object.followUp, @"Read byte does not equal.");
}

- (void)testComplexWrite;
{
	TRSimpleStructureTest_TestClass *inherited = [[TRSimpleStructureTest_TestClass alloc] init];
	
	inherited.dword = UINT16_MAX + 2;
	inherited.byte1 = 128;
	inherited.byte2 = 12;
	inherited.word = 259;
	inherited.negative = -42;
	
	TRSimpleStructureTest_ComplexTestClass *object = [[TRSimpleStructureTest_ComplexTestClass alloc] init];
	object.dword = 40000;
	object.alignmentScrewup = 129;
	object.inherited = inherited;
	object.followUp = 0;
	
	TROutDataStream *stream = [[TROutDataStream alloc] init];
	[object writeToStream:stream];
	
	struct ComplexTestStruct test;
	STAssertEquals(stream.length, sizeof(test), @"Length is not equal to test data");
	
	[stream.data getBytes:&test length:sizeof(test)];
	
	STAssertEquals(stream.length, sizeof(test), @"Length is not equal to size of test data");
	
	STAssertEquals((NSUInteger) test.dword, object.dword, @"Read dword does not equal.");
	STAssertEquals((NSUInteger) test.alignmentScrewup, object.alignmentScrewup, @"Read byte does not equal.");
	
	STAssertEquals((NSUInteger) test.inherited.dword, object.inherited.dword, @"Read inherited dword does not equal.");
	STAssertEquals((NSUInteger) test.inherited.byte1, object.inherited.byte1, @"Read inherited byte does not equal.");
	STAssertEquals((NSUInteger) test.inherited.byte2, object.inherited.byte2, @"Read inherited byte does not equal.");
	STAssertEquals((NSUInteger) test.inherited.word, object.inherited.word, @"Read inherited word does not equal.");
	STAssertEquals((NSInteger) test.inherited.negative, object.inherited.negative, @"Read inherited negative value does not equal.");
	
	STAssertEquals((NSUInteger) test.followUp, object.followUp, @"Read byte does not equal.");

}

@end
