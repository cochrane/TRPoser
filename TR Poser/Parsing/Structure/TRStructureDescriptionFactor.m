//
//  TRStructureDescriptionFactor.m
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionFactor.h"

#import <objc/runtime.h>

#import "TRStructure.h"
#import "TRStructureDescription.h"

static NSString *lineRegexpString = @"^@factor\\s*\
(?:\
	\\(\\s*\
	(signed|unsigned|double)\\s*\
	\\)\
)?\\s*\
([a-zA-Z][a-zA-Z0-9_]+)\\s*\
=\\s*\
([a-zA-Z][a-zA-Z0-9_]+)\\s*\
\\*\\s*\
([0-9.eE]+)\\s*$";
static NSRegularExpression *expression = nil;

static void SetFactorPropertyUnsigned(id self, SEL _cmd, NSUInteger value)
{
	NSString *selectorName = NSStringFromSelector(_cmd);
	NSMutableString *propertyName = [selectorName mutableCopy];
	[propertyName deleteCharactersInRange:NSMakeRange(0, 3)];
	[propertyName deleteCharactersInRange:NSMakeRange(propertyName.length-1, 1)];
	[propertyName replaceCharactersInRange:NSMakeRange(0, 1) withString:[[propertyName substringToIndex:1] lowercaseString]];
	
	TRStructureDescriptionFactor *prop = [[[[self class] structureDescription] factorProperties] objectForKey:propertyName];
	
	NSAssert(prop, @"Property for selector %@ cannot be null", propertyName);

	NSUInteger factor = [prop.factor unsignedIntegerValue];
	
	// Divide applies to read. Invert here
	NSUInteger result = prop.divide ? value * factor : value / factor;
	
	[self setValue:@(result) forKeyPath:prop.originalFieldName];
}

static NSUInteger FactorPropertyUnsigned(id self, SEL _cmd)
{
	NSString *propertyName = NSStringFromSelector(_cmd);
	TRStructureDescriptionFactor *prop = [[[[self class] structureDescription] factorProperties] objectForKey:propertyName];
	
	NSAssert(prop, @"Property for selector %@ cannot be null", propertyName);
	
	NSUInteger factor = [prop.factor unsignedIntegerValue];
	NSUInteger value = [[self valueForKeyPath:prop.originalFieldName] unsignedIntegerValue];
	
	return prop.divide ? (value / factor) : (value * factor);
}

static void SetFactorPropertySigned(id self, SEL _cmd, NSInteger value)
{
	NSString *selectorName = NSStringFromSelector(_cmd);
	NSMutableString *propertyName = [selectorName mutableCopy];
	[propertyName deleteCharactersInRange:NSMakeRange(0, 3)];
	[propertyName deleteCharactersInRange:NSMakeRange(propertyName.length-1, 1)];
	[propertyName replaceCharactersInRange:NSMakeRange(0, 1) withString:[[propertyName substringToIndex:1] lowercaseString]];
	
	TRStructureDescriptionFactor *prop = [[[[self class] structureDescription] factorProperties] objectForKey:propertyName];
	
	NSAssert(prop, @"Property for selector %@ cannot be null", propertyName);
	
	NSInteger factor = [prop.factor integerValue];
	
	// Divide applies to read. Invert here
	NSInteger result = prop.divide ? value * factor : value / factor;
	
	[self setValue:@(result) forKeyPath:prop.originalFieldName];
}

static NSInteger FactorPropertySigned(id self, SEL _cmd)
{
	NSString *propertyName = NSStringFromSelector(_cmd);
	TRStructureDescriptionFactor *prop = [[[[self class] structureDescription] factorProperties] objectForKey:propertyName];
	
	NSAssert(prop, @"Property for selector %@ cannot be null", propertyName);
	
	NSInteger factor = [prop.factor integerValue];
	NSInteger value = [[self valueForKeyPath:prop.originalFieldName] integerValue];
	
	return prop.divide ? (value / factor) : (value * factor);
}

static void SetFactorPropertyDouble(id self, SEL _cmd, double value)
{
	NSString *selectorName = NSStringFromSelector(_cmd);
	NSMutableString *propertyName = [selectorName mutableCopy];
	[propertyName deleteCharactersInRange:NSMakeRange(0, 3)];
	[propertyName deleteCharactersInRange:NSMakeRange(propertyName.length-1, 1)];
	[propertyName replaceCharactersInRange:NSMakeRange(0, 1) withString:[[propertyName substringToIndex:1] lowercaseString]];
	
	TRStructureDescriptionFactor *prop = [[[[self class] structureDescription] factorProperties] objectForKey:propertyName];
	
	NSAssert(prop, @"Property for selector %@ cannot be null", propertyName);
	
	double factor = [prop.factor doubleValue];
	
	// Divide applies to read. Invert here
	double result = prop.divide ? value * factor : value / factor;
	
	[self setValue:@(result) forKeyPath:prop.originalFieldName];
}

static double FactorPropertyDouble(id self, SEL _cmd)
{
	NSString *propertyName = NSStringFromSelector(_cmd);
	TRStructureDescriptionFactor *prop = [[[[self class] structureDescription] factorProperties] objectForKey:propertyName];
	
	NSAssert(prop, @"Property for selector %@ cannot be null", propertyName);
	
	double factor = [prop.factor doubleValue];
	double value = [[self valueForKeyPath:prop.originalFieldName] doubleValue];
	
	return prop.divide ? (value / factor) : (value * factor);
}

@implementation TRStructureDescriptionFactor

+ (void)initialize
{
	expression = [[NSRegularExpression alloc] initWithPattern:lineRegexpString options:NSRegularExpressionAllowCommentsAndWhitespace error:NULL];
}

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;

	self.type = TRStructureDescriptionFactor_Double;
	
	NSTextCheckingResult *components = [expression firstMatchInString:fieldDescription options:NSMatchingAnchored range:NSMakeRange(0, fieldDescription.length)];
	
	NSAssert(components, @"Could not match regexp with line %@", fieldDescription);
	NSAssert(components.range.location != NSNotFound, @"Trouble matching %@ against regexp", fieldDescription);
	
	NSRange typeRange = [components rangeAtIndex:1];
	if (typeRange.location != NSNotFound)
	{
		NSString *typeString = [fieldDescription substringWithRange:typeRange];
		if ([typeString isEqual:@"signed"])
			self.type = TRStructureDescriptionFactor_Signed;
		else if ([typeString isEqual:@"unsigned"])
			self.type = TRStructureDescriptionFactor_Unsigned;
		else if ([typeString isEqual:@"double"])
			self.type = TRStructureDescriptionFactor_Double;
	}
	
	NSRange newFieldRange = [components rangeAtIndex:2];
	self.derivedFieldName = [fieldDescription substringWithRange:newFieldRange];
	
	NSRange oldFieldRange = [components rangeAtIndex:3];
	self.originalFieldName = [fieldDescription substringWithRange:oldFieldRange];
	
	NSRange factorRange = [components rangeAtIndex:4];
	NSString *factor = [fieldDescription substringWithRange:factorRange];
	if (self.type == TRStructureDescriptionFactor_Double)
		self.factor = @(factor.doubleValue);
	else
		self.factor = @(factor.integerValue);
	
	return self;
}

- (void)addMethodsToClass:(Class)class;
{
	SEL getterSelector = NSSelectorFromString(self.derivedFieldName);
	
	NSMutableString *setterSelectorString = [self.derivedFieldName mutableCopy];
	[setterSelectorString insertString:@"set" atIndex:0];
	[setterSelectorString appendString:@":"];
	[setterSelectorString replaceCharactersInRange:NSMakeRange(3, 1) withString:[[self.derivedFieldName substringToIndex:1] uppercaseString]];
	SEL setterSelector = NSSelectorFromString(setterSelectorString);
	
	switch(self.type)
	{
		case TRStructureDescriptionFactor_Double:
			class_addMethod(class, getterSelector, (IMP) FactorPropertyDouble, "d@:");
			class_addMethod(class, setterSelector, (IMP) SetFactorPropertyDouble, "v@:d");
			break;
		case TRStructureDescriptionFactor_Signed:
			class_addMethod(class, getterSelector, (IMP) FactorPropertySigned, "q@:");
			class_addMethod(class, setterSelector, (IMP) SetFactorPropertySigned, "v@:q");
			break;
		case TRStructureDescriptionFactor_Unsigned:
			class_addMethod(class, getterSelector, (IMP) FactorPropertyUnsigned, "Q@:");
			class_addMethod(class, setterSelector, (IMP) SetFactorPropertyUnsigned, "v@:Q");
			break;
	}
}


@end
