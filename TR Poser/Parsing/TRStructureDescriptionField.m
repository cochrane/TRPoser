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
#import "TRStructureDescriptionConstField.h"
#import "TR1Level.h"

@interface TRStructureDescriptionField ()

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) BOOL isPrimitive;

@property (nonatomic, readwrite, assign) TRStructureDescriptionPrimitiveType primitiveType;

@property (nonatomic, readwrite, assign) BOOL isVersioned;
@property (nonatomic, readwrite, copy) NSString *className;

@property (nonatomic, readwrite, assign) NSUInteger fixedArrayLength;
@property (nonatomic, readwrite, assign) TRStructureDescriptionPrimitiveType countFieldType;
@property (nonatomic, readwrite, copy) NSString *lengthKeyPath;
@property (nonatomic, readwrite, assign) NSUInteger lengthDivisor;
@property (nonatomic, readwrite, assign) NSUInteger lengthFactor;

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
	
	if ([fieldDescription hasPrefix:@"const"])
		return [[TRStructureDescriptionConstField alloc] initWithString:fieldDescription];
	
	NSScanner *scanner = [NSScanner scannerWithString:fieldDescription];
	TRStructureDescriptionPrimitiveType type;
	if ([scanner scanPrimitiveType:&type])
	{
		self.isPrimitive = YES;
		self.primitiveType = type;
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
		TRStructureDescriptionPrimitiveType countFieldType;
		if ([scanner scanPrimitiveType:&countFieldType])
		{
			self.countFieldType = countFieldType;
		}
		else if ([scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&arrayLength])
		{
			self.fixedArrayLength = arrayLength.integerValue;
		}
		else
		{
			NSString *keyPath;
			[scanner scanUpToString:@"]" intoString:&keyPath];
			self.lengthKeyPath = keyPath;
		}
		
		// Is there a factor?
		self.lengthDivisor = 1;
		self.lengthFactor = 1;
		
		NSInteger value = -12;
		
		if ([scanner scanString:@"*" intoString:NULL])
		{
			[scanner scanInteger:&value];
			self.lengthFactor = value;
		}
		else if ([scanner scanString:@"/" intoString:NULL])
		{
			[scanner scanInteger:&value];
			self.lengthDivisor = value;
		}
		
		if (self.fixedArrayLength != 0)
			self.fixedArrayLength = self.fixedArrayLength * self.lengthFactor / self.lengthDivisor;
		
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
	else if (self.countFieldType != TRSDCP_invalid)
	{
		NSUInteger length = [[stream readNumberOfPrimitiveType:self.countFieldType] unsignedIntegerValue] * self.lengthFactor / self.lengthDivisor;
		
		NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:length];
		
		for (NSUInteger i = 0; i < length; i++)
			[result addObject:[self parseSingleValueFromStream:stream intoObject:structure]];
		
		[structure setValue:result forKey:self.name];
	}
	else if (self.lengthKeyPath != 0)
	{
		NSUInteger length = [[structure valueForKeyPath:@"lengthKeyPath"] unsignedIntegerValue] * self.lengthFactor / self.lengthDivisor;
		
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
		return [stream readNumberOfPrimitiveType:self.primitiveType];
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
	else if (self.countFieldType != TRSDCP_invalid)
	{
		NSArray *elements = [structure valueForKey:self.name];
		[stream appendNumber:@(elements.count * self.lengthDivisor / self.lengthFactor) ofPrimitiveType:self.countFieldType];
		
		for (id element in elements)
			[self writeSingleValue:element toStream:stream];
	}
	else if (self.lengthKeyPath)
	{
		NSArray *elements = [structure valueForKey:self.name];
		NSUInteger length = [[structure valueForKeyPath:@"lengthKeyPath"] unsignedIntegerValue];
		
		// Note: This may fail if the key path isn't settable. It is the
		// subclass's duty to ensure that the key path is settable or holds the
		// correct value.
		if (length != elements.count * self.lengthDivisor / self.lengthFactor)
			[structure setValue:@(length) forKeyPath:self.lengthKeyPath];
		
		for (id element in elements)
			[self writeSingleValue:element toStream:stream];
	}
	else
		[self writeSingleValue:[structure valueForKey:self.name] toStream:stream];
}

- (void)writeSingleValue:(id)value toStream:(TROutDataStream *)stream
{
	if (self.isPrimitive)
		[stream appendNumber:value ofPrimitiveType:self.primitiveType];
	else
		[value writeToStream:stream];
}

@end
