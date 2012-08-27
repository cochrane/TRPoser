//
//  TR1SimpleStructureDescriptionItem.m
//  
//
//  Created by Torsten Kammer on 14.08.12.
//
//

#import "TRStructureDescriptionField.h"

#import "TRStructureDescriptionConstField.h"
#import "TRStructureDescriptionCompressedField.h"
#import "TRStructureDescriptionSubstreamField.h"
#import "TRStructureDescriptionValueField.h"

@implementation TRStructureDescriptionField

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;
	
	if ([fieldDescription hasPrefix:@"const"])
		return [[TRStructureDescriptionConstField alloc] initWithString:fieldDescription];
	else if ([fieldDescription hasPrefix:@"compressed"])
		return [[TRStructureDescriptionCompressedField alloc] initWithString:fieldDescription];
	else if ([fieldDescription hasPrefix:@"substream"])
		return [[TRStructureDescriptionSubstreamField alloc] initWithString:fieldDescription];
	else
		return [[TRStructureDescriptionValueField alloc] initWithString:fieldDescription];
}

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
{
	[self doesNotRecognizeSelector:_cmd];
}
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;
{
	[self doesNotRecognizeSelector:_cmd];
}

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure substreams:(NSDictionary *__autoreleasing*)substreams;
{
	[self parseFromStream:stream intoObject:structure];
	if (substreams) *substreams = nil;
}
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure substreams:(NSDictionary *)substreams;
{
	[self writeToStream:stream fromObject:structure];
}

@end
