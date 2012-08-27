//
//  TRStructureDescriptionArrayLengthDescriptor.m
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionArrayLength.h"

#import "TRStructure.h"

@interface TRStructureDescriptionArrayLength ()

@property (nonatomic, assign, readwrite) NSUInteger fixedLength;
@property (nonatomic, copy, readwrite) NSString *lengthKeyPath;
@property (nonatomic, assign, readwrite) TRStructureDescriptionPrimitiveType countFieldType;
@property (nonatomic, assign, readwrite) NSUInteger factor;
@property (nonatomic, assign, readwrite) NSUInteger divisor;


@end

@implementation TRStructureDescriptionArrayLength

- (id)initWithScanner:(NSScanner *)scanner;
{
	return [self initWithScanner:scanner inBrackets:YES];
}

- (id)initWithScanner:(NSScanner *)scanner inBrackets:(BOOL)requireBrackets;
{
	if (!(self = [super init])) return nil;
	
	if (requireBrackets)
		if (![scanner scanString:@"[" intoString:NULL])
			return nil;
	
	NSString *arrayLength;
	TRStructureDescriptionPrimitiveType countFieldType;
	if ([scanner scanPrimitiveType:&countFieldType])
	{
		self.countFieldType = countFieldType;
	}
	else if ([scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&arrayLength])
	{
		self.fixedLength = arrayLength.integerValue;
	}
	else
	{
		NSString *keyPath;
		[scanner scanUpToString:@"]" intoString:&keyPath];
		self.lengthKeyPath = keyPath;
	}
	
	// Is there a factor?
	self.divisor = 1;
	self.factor = 1;
	
	NSInteger value = -12;
	
	if ([scanner scanString:@"*" intoString:NULL])
	{
		[scanner scanInteger:&value];
		self.factor = value;
	}
	else if ([scanner scanString:@"/" intoString:NULL])
	{
		[scanner scanInteger:&value];
		self.divisor = value;
	}
	
	if (self.fixedLength != 0)
		self.fixedLength = self.fixedLength * self.factor / self.divisor;
	
	if (requireBrackets)
	{
		BOOL foundEndBracket = [scanner scanString:@"]" intoString:NULL];
		NSAssert(foundEndBracket, @"array has to have end bracket!");
	}
	
	return self;
}

- (NSUInteger)readLengthFromStream:(TRInDataStream *)stream object:(TRStructure *)object;
{
	if (self.fixedLength != 0)
		return self.fixedLength;
	else if (self.countFieldType != TRSDCP_invalid)
	{
		NSUInteger result = [[stream readNumberOfPrimitiveType:self.countFieldType] unsignedIntegerValue];
		NSAssert((result * self.factor) % self.divisor == 0, @"Division by %lu not permissible.", self.divisor);
		return result * self.factor / self.divisor;
	}
	else if (self.lengthKeyPath)
	{
		NSUInteger result = [[object valueForKeyPath:self.lengthKeyPath] unsignedIntegerValue] * self.factor / self.divisor;
		NSAssert((result * self.factor) % self.divisor == 0, @"Division by %lu not permissible.", self.divisor);
		return result * self.factor / self.divisor;
	}
	
	else
		return NSNotFound;
}
- (void)writeLengthToStream:(TROutDataStream *)stream object:(TRStructure *)object actual:(NSUInteger)actualLength;
{
	if (self.fixedLength != 0)
	{
		NSAssert(actualLength == self.fixedLength, @"Objects have to conform to fixed length %lu, but are %lu", self.fixedLength, actualLength);
		return;
	}
	else if (self.lengthKeyPath)
	{
		NSUInteger expectedLength = [[object valueForKeyPath:self.lengthKeyPath] unsignedIntegerValue] * self.divisor / self.factor;
		NSAssert(actualLength == expectedLength, @"Objects have to conform to dynamic external length %lu, but are %lu", expectedLength, actualLength);
		return;
	}
	else
		[stream appendNumber:@(actualLength * self.divisor / self.factor) ofPrimitiveType:self.countFieldType];
}

@end
