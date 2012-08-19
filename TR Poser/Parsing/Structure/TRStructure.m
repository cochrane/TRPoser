//
//  TRSimpleStructure.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

#import "TR2Level.h"

#import "TRStructureDescription.h"
#import "TRStructureDescriptionValueField.h"
#import "TRStructureDescriptionDerivedProperty.h"
#import "TRStructureDescriptionFactor.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TRStructure ()

+ (void)prepareClassWithDescription:(TRStructureDescription *)description;

@end

static NSMutableDictionary *structureDescriptions;

@implementation TRStructure

+ (TRStructureDescription *)structureDescription;
{
	if (!structureDescriptions)
		structureDescriptions = [[NSMutableDictionary alloc] init];
	
	NSString *source = [self structureDescriptionSource];
	
	TRStructureDescription *result = [structureDescriptions objectForKey:source];
	if (!result)
	{
		result = [[TRStructureDescription alloc] initWithSource:source];
		[self prepareClassWithDescription:result];
		[structureDescriptions setObject:result forKey:source];
	}
	return result;
}
+ (NSString *)structureDescriptionSource;
{
	return nil;
}

+ (void)prepareClassWithDescription:(TRStructureDescription *)description;
{
	for (TRStructureDescriptionDerivedProperty *property in description.derivedProperties.allValues)
	{
		[property addMethodsToClass:self];
	}
	for (TRStructureDescriptionFactor *property in description.factorProperties.allValues)
	{
		[property addMethodsToClass:self];
	}
}

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	return [self initFromDataStream:stream inLevel:level substreams:NULL];
}
- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level substreams:(NSDictionary * __autoreleasing *)substreams;
{
	if (!(self = [super init])) return nil;
	
	NSAssert(stream != nil, @"Have to have a stream!");
	
	_level = level;
	
	NSMutableDictionary *mutableSubstreams = [[NSMutableDictionary alloc] init];
	for (TRStructureDescriptionField *field in self.class.structureDescription.fields)
	{
		NSDictionary *additionalSubstreams = nil;
		[field parseFromStream:stream intoObject:self substreams:&additionalSubstreams];
		if (additionalSubstreams)
			[mutableSubstreams addEntriesFromDictionary: additionalSubstreams];
	}
	if (substreams) *substreams = mutableSubstreams;
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	[self writeToStream:stream substreams:nil];
}
- (void)writeToStream:(TROutDataStream *)stream substreams:(NSDictionary *)substreams;
{
	for (TRStructureDescriptionField *field in self.class.structureDescription.fields)
	{
		[field writeToStream:stream fromObject:self substreams:substreams];
	}
}

@end
