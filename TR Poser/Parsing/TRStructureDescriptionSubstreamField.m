//
//  TRStructureDescriptionSubstreamField.m
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionSubstreamField.h"

#import "TRStructureDescriptionArrayLength.h"

@interface TRStructureDescriptionSubstreamField ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) TRStructureDescriptionArrayLength *arrayLength;

@end

@implementation TRStructureDescriptionSubstreamField

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;
	
	NSScanner *scanner = [NSScanner scannerWithString:fieldDescription];
	
	if (![scanner scanString:@"substream" intoString:NULL])
		return nil;
	
	NSString *name;
	[scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&name];
	self.name = name;
	
	self.arrayLength = [[TRStructureDescriptionArrayLength alloc] initWithScanner:scanner];
	NSAssert(self.arrayLength != nil, @"substream has to have array length.");
	
	return self;
}

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure substreams:(NSDictionary *__autoreleasing*)substreams;
{
	NSAssert(substreams != NULL, @"Gotta have substreams!");
	NSUInteger bytes = [self.arrayLength readLengthFromStream:stream object:structure];
	
	*substreams = @{ self.name : [stream substreamWithLength:bytes] };
}
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure substreams:(NSDictionary *)substreams;
{
	TROutDataStream *substream = [substreams objectForKey:self.name];
	NSAssert(substream != NULL, @"Substream named %@ does not exist", self.name);
	
	[self.arrayLength writeLengthToStream:stream object:structure actual:substream.length];
	[stream appendStream:substream];
}

@end
