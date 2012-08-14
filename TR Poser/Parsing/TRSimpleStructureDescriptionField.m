//
//  TRSimpleStructureDescriptionField.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRSimpleStructureDescriptionField.h"

@interface TRSimpleStructureDescriptionField ()

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, retain) Class type;
@property (nonatomic, readwrite, assign) BOOL isSigned;
@property (nonatomic, readwrite, assign) NSUInteger bits;
@property (nonatomic, readwrite, assign) NSUInteger fixedArrayLength;
@property (nonatomic, readwrite, assign) NSUInteger countFieldBits;

@end

static NSMutableCharacterSet *nameTerminatorSet;

@implementation TRSimpleStructureDescriptionField

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
		self.isSigned = ![scanner scanString:@"u" intoString:NULL];
		
		NSString *bits;
		[scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&bits];
		
		self.bits = bits.integerValue;
		
		NSString *name;
		[scanner scanUpToCharactersFromSet:[[self class] nameTerminatorSet] intoString:&name];
		
		self.name = name;
	}
	else
	{
		NSString *class;
		[scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&class];
		[scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
		
		NSString *name;
		[scanner scanUpToCharactersFromSet:[[self class] nameTerminatorSet] intoString:&name];
		
		self.name = name;
		self.type = NSClassFromString(class);
	}
	
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

@end
