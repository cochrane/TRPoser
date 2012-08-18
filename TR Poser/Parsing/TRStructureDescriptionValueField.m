//
//  TRSimpleStructureDescriptionField.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionValueField.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"
#import "TRStructure.h"
#import "TRStructureDescriptionConstField.h"
#import "TR1Level.h"

@interface TRStructureDescriptionValueField ()

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) BOOL isPrimitive;

@property (nonatomic, readwrite, assign) TRStructureDescriptionPrimitiveType primitiveType;

@property (nonatomic, readwrite, assign) BOOL isVersioned;
@property (nonatomic, readwrite, copy) NSString *className;

- (id)parseSingleValueFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
- (void)writeSingleValue:(id)value toStream:(TROutDataStream *)stream;

@end

static NSMutableCharacterSet *nameTerminatorSet;

@implementation TRStructureDescriptionValueField

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
	self.arrayLength = [[TRStructureDescriptionArrayLength alloc] initWithScanner:scanner];
	
	NSAssert([scanner isAtEnd], @"Line %@ goes too long", fieldDescription);
	
	return self;
}

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
{
	if (self.arrayLength)
	{
		NSUInteger length = [self.arrayLength readLengthFromStream:stream object:structure];
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
		NSAssert(type != nil, @"Could not find type for name %@ (versioned? %lu)", self.className, (NSUInteger) self.isVersioned);
		return [[type alloc] initFromDataStream:stream inLevel:structure.level];
	}
}

- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;
{
	if (self.arrayLength != 0)
	{
		NSArray *elements = [structure valueForKey:self.name];
		
		[self.arrayLength writeLengthToStream:stream object:structure actual:elements.count];;
		
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
