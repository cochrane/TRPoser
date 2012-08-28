//
//  TRStructureDescriptionCompressedField.m
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionCompressedField.h"

@interface TRStructureDescriptionCompressedField ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) TRStructureDescriptionArrayLength *compressedLength;
@property (nonatomic, retain, readwrite) TRStructureDescriptionArrayLength *uncompressedLength;
@property (nonatomic, assign, readwrite) BOOL compressedComesFirst;

@end

@implementation TRStructureDescriptionCompressedField

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;
	
	NSScanner *scanner = [NSScanner scannerWithString:fieldDescription];
	
	if (![scanner scanString:@"compressed" intoString:NULL])
		return nil;
	
	NSString *name;
	[scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&name];
	self.name = name;
	
	NSAssert([scanner scanString:@"[" intoString:NULL], @"line %@ has to have [", fieldDescription);
	
	if ([scanner scanString:@"c" intoString:NULL])
		self.compressedComesFirst = YES;
	else if ([scanner scanString:@"u" intoString:NULL])
		self.compressedComesFirst = NO;
	else
		[NSException raise:NSInvalidArgumentException format:@"Wrong format in line %@", fieldDescription];
	
	NSAssert([scanner scanString:@"=" intoString:NULL], @"line %@ has to have first =", fieldDescription);
	
	if (self.compressedComesFirst)
		self.compressedLength = [[TRStructureDescriptionArrayLength alloc] initWithScanner:scanner inBrackets:NO];
	else
		self.uncompressedLength = [[TRStructureDescriptionArrayLength alloc] initWithScanner:scanner inBrackets:NO];
	
	NSAssert([scanner scanString:@"," intoString:NULL], @"has to have comma");
	
	if (self.compressedComesFirst)
		NSAssert([scanner scanString:@"u" intoString:NULL], @"after c, u is required");
	else
		NSAssert([scanner scanString:@"c" intoString:NULL], @"after u, c is required");
	
	NSAssert([scanner scanString:@"=" intoString:NULL], @"line %@ has to have second =", fieldDescription);

	if (self.compressedComesFirst)
		self.uncompressedLength = [[TRStructureDescriptionArrayLength alloc] initWithScanner:scanner inBrackets:NO];
	else
		self.compressedLength = [[TRStructureDescriptionArrayLength alloc] initWithScanner:scanner inBrackets:NO];
	
	NSAssert([scanner scanString:@"]" intoString:NULL], @"line %@ has to have ]", fieldDescription);
	
	NSAssert([scanner isAtEnd], @"Line %@ goes too long", fieldDescription);
	
	return self;
}

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure substreams:(NSDictionary *__autoreleasing*)substreams;
{
	NSAssert(substreams != NULL, @"Gotta have substreams!");
	NSAssert(!stream.isAtEnd, @"Stream at end even though there is still field \"%@\" to read.", self.name);
	
	NSUInteger uncompressed, compressed;
	if (self.compressedComesFirst)
	{
		compressed = [self.compressedLength readLengthFromStream:stream object:structure];
		uncompressed = [self.uncompressedLength readLengthFromStream:stream object:structure];
	}
	else
	{
		uncompressed = [self.uncompressedLength readLengthFromStream:stream object:structure];
		compressed = [self.compressedLength readLengthFromStream:stream object:structure];
	}
	if (compressed == uncompressed)
	{
		*substreams = @{ self.name : [stream substreamWithLength:compressed] };
	}
	else
	{
		*substreams = @{ self.name : [stream decompressStreamCompressedLength:compressed uncompressedLength:uncompressed] };
	}
}
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure substreams:(NSDictionary *)substreams;
{
	TROutDataStream *substream = [substreams objectForKey:self.name];
	NSAssert(substream != NULL, @"Substream named %@ does not exist", self.name);
	
	NSData *compressed = [substream compressed];
	if (self.compressedComesFirst)
	{
		[self.compressedLength writeLengthToStream:stream object:structure actual:compressed.length];
		[self.uncompressedLength writeLengthToStream:stream object:structure actual:substream.length];
	}
	else
	{
		[self.uncompressedLength writeLengthToStream:stream object:structure actual:substream.length];
		[self.compressedLength writeLengthToStream:stream object:structure actual:compressed.length];
	}
	
	[stream appendData:compressed];
}

@end
