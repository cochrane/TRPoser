//
//  TRSimpleStructureDescriptionField.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionField.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"
#import "TRStructure.h"
#import "TR1Level.h"

@interface TRStructureDescriptionField ()

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) BOOL isPrimitive;

@property (nonatomic, readwrite, assign) BOOL isSigned;
@property (nonatomic, readwrite, assign) NSUInteger bits;
@property (nonatomic, readwrite, assign) NSUInteger fixedArrayLength;
@property (nonatomic, readwrite, assign) NSUInteger countFieldBits;

@property (nonatomic, readwrite, assign) BOOL isVersioned;
@property (nonatomic, readwrite, copy) NSString *className;

- (id)parseSingleValueFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
- (void)writeSingleValue:(id)value toStream:(TROutDataStream *)stream;

@end

static NSMutableCharacterSet *nameTerminatorSet;

@implementation TRStructureDescriptionField

+ (NSCharacterSet *)nameTerminatorSet
{
	if (nameTerminatorSet == nil)
	{
		nameTerminatorSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
		[nameTerminatorSet addCharactersInString:@"["];
	}
	return nameTerminatorSet;
}

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = NSNumberFormatterNoStyle;
	
	NSScanner *scanner = [NSScanner scannerWithString:fieldDescription];
	if ([scanner scanString:@"bit" intoString:NULL])
	{
		self.isPrimitive = YES;
		
		self.isSigned = ![scanner scanString:@"u" intoString:NULL];
		
		NSString *bits;
		[scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&bits];
		
		self.bits = bits.integerValue;
	}
	else
	{
		self.isPrimitive = NO;
		
		self.isVersioned = [scanner scanString:@"*" intoString:NULL];
		
		NSString *class;
		[scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&class];
		self.className = class;
		[scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
	}
	
	NSString *name;
	[scanner scanUpToCharactersFromSet:[[self class] nameTerminatorSet] intoString:&name];
	
	self.name = name;
	
	// See if there is an array value.
	if ([scanner scanString:@"[" intoString:NULL])
	{
		NSString *arrayLength;
		if ([scanner scanString:@"bit" intoString:NULL])
		{
			// Uses size field that comes before
			BOOL isUnsigned = [scanner scanString:@"u" intoString:NULL];
			NSAssert(isUnsigned, @"Only unsigned length fields are supported, anything else needs more logic in line %@", fieldDescription);
			
			NSString *countFieldBits;
			[scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&countFieldBits];
			
			self.countFieldBits = countFieldBits.integerValue;
		}
		else if ([scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&arrayLength])
		{
			self.fixedArrayLength = arrayLength.integerValue;
		}
		else
			return nil;
		
		BOOL foundEndBracket = [scanner scanString:@"]" intoString:NULL];
		NSAssert(foundEndBracket, @"array has to have end bracket. Line %@", fieldDescription);
	}
	
	return self;
}

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
{
	if (self.fixedArrayLength != 0)
	{
		NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.fixedArrayLength];
		
		for (NSUInteger i = 0; i < self.fixedArrayLength; i++)
			[result addObject:[self parseSingleValueFromStream:stream intoObject:structure]];
		
		[structure setValue:result forKey:self.name];
	}
	else if (self.countFieldBits != 0)
	{
		NSUInteger length = [[stream readNumberWithBits:self.countFieldBits signed:NO] unsignedIntegerValue];
		
		NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:length];
		
		for (NSUInteger i = 0; i < length; i++)
			[result addObject:[self parseSingleValueFromStream:stream intoObject:structure]];
		
		[structure setValue:result forKey:self.name];
	}
	else
		[structure setValue:[self parseSingleValueFromStream:stream intoObject:structure] forKey:self.name];
}

- (id)parseSingleValueFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
{
	if (self.isPrimitive)
		return [stream readNumberWithBits:self.bits signed:self.isSigned];
	else
	{
		Class type = self.isVersioned ? [structure.level versionedClassForName:self.className] : NSClassFromString(self.className);
		return [[type alloc] initFromDataStream:stream inLevel:structure.level];
	}
}

- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;
{
	if (self.fixedArrayLength != 0)
	{
		NSArray *elements = [structure valueForKey:self.name];
		for (NSUInteger i = 0; i < self.fixedArrayLength; i++)
			[self writeSingleValue:[elements objectAtIndex:i] toStream:stream];
	}
	else if (self.countFieldBits != 0)
	{
		NSArray *elements = [structure valueForKey:self.name];
		[stream appendNumber:@(elements.count) bits:self.countFieldBits signed:NO];
		
		for (id element in elements)
			[self writeSingleValue:element toStream:stream];
	}
	else
		[self writeSingleValue:[structure valueForKey:self.name] toStream:stream];
}

- (void)writeSingleValue:(id)value toStream:(TROutDataStream *)stream
{
	if (self.isPrimitive)
		[stream appendNumber:value bits:self.bits signed:self.isSigned];
	else
		[value writeToStream:stream];
}

@end
