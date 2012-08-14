//
//  TRSimpleStructure.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRSimpleStructure.h"

#import "TRSimpleStructureDescription.h"
#import "TRSimpleStructureDescriptionField.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@interface TRSimpleStructure ()

- (id)parseSingleValueForField:(TRSimpleStructureDescriptionField *)field fromStream:(TRInDataStream *)stream;
- (void)writeSingleValue:(id)value forField:(TRSimpleStructureDescriptionField *)field toStream:(TROutDataStream *)stream;

@end

@implementation TRSimpleStructure

+ (TRSimpleStructureDescription *)structureDescription;
{
	return nil;
}

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
{
	if (!(self = [super init])) return nil;
	
	_level = level;
	
	for (TRSimpleStructureDescriptionField *field in self.class.structureDescription.fields)
	{
		if (field.fixedArrayLength != 0)
		{
			NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:field.fixedArrayLength];
			
			for (NSUInteger i = 0; i < field.fixedArrayLength; i++)
				[result addObject:[self parseSingleValueForField:field fromStream:stream]];
			
			[self setValue:result forKey:field.name];
		}
		else if (field.countFieldBits != 0)
		{
			NSUInteger length = [[stream readNumberWithBits:field.countFieldBits signed:NO] unsignedIntegerValue];
			
			NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:length];
			
			for (NSUInteger i = 0; i < length; i++)
				[result addObject:[self parseSingleValueForField:field fromStream:stream]];
			
			[self setValue:result forKey:field.name];
		}
		else
			[self setValue:[self parseSingleValueForField:field fromStream:stream] forKey:field.name];
	}
	
	return self;
}

- (id)parseSingleValueForField:(TRSimpleStructureDescriptionField *)field fromStream:(TRInDataStream *)stream;
{
	if (field.type)
		return [[field.type alloc] initFromDataStream:stream inLevel:self.level];
	else
		return [stream readNumberWithBits:field.bits signed:field.isSigned];
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	for (TRSimpleStructureDescriptionField *field in self.class.structureDescription.fields)
	{
		if (field.fixedArrayLength != 0)
		{
			NSArray *elements = [self valueForKey:field.name];
			for (NSUInteger i = 0; i < field.fixedArrayLength; i++)
				[self writeSingleValue:[elements objectAtIndex:i] forField:field toStream:stream];
		}
		else if (field.countFieldBits != 0)
		{
			NSArray *elements = [self valueForKey:field.name];
			[stream appendNumber:@(elements.count) bits:field.countFieldBits signed:NO];
			
			for (id element in elements)
				[self writeSingleValue:element forField:field toStream:stream];
		}
		else
			[self writeSingleValue:[self valueForKey:field.name] forField:field toStream:stream];
	}
}

- (void)writeSingleValue:(id)value forField:(TRSimpleStructureDescriptionField *)field toStream:(TROutDataStream *)stream;
{
	if (field.type)
		[value writeToStream:stream];
	else
		[stream appendNumber:value bits:field.bits signed:field.isSigned];
}

@end
