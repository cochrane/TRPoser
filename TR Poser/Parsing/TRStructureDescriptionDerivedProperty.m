//
//  TRSimpleStructureDescriptionDerivedProperty.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionDerivedProperty.h"

#import <objc/runtime.h>

#import "TRStructureDescription.h"
#import "TRStructure.h"

static NSString *lineRegexpString = @"^@derived ([a-zA-Z][a-zA-Z0-9_]+)=([a-zA-Z][a-zA-Z0-9_]+)\\[([a-zA-Z][a-zA-Z0-9_]+)\\]$";
static NSRegularExpression *expression = nil;

@interface TRStructureDescriptionDerivedProperty ()

@property (nonatomic, copy, readwrite) NSString *objectKey;
@property (nonatomic, copy, readwrite) NSString *levelArrayKey;
@property (nonatomic, copy, readwrite) NSString *indexKey;

@end

static void SetDerivedProperty(id self, SEL _cmd, id value)
{
	NSString *selectorName = NSStringFromSelector(_cmd);
	NSMutableString *propertyName = [selectorName mutableCopy];
	[propertyName deleteCharactersInRange:NSMakeRange(0, 3)];
	[propertyName deleteCharactersInRange:NSMakeRange(propertyName.length-1, 1)];
	[propertyName replaceCharactersInRange:NSMakeRange(0, 1) withString:[[propertyName substringToIndex:1] lowercaseString]];
	
	TRStructureDescriptionDerivedProperty *prop = [[[[self class] structureDescription] derivedProperties] objectForKey:propertyName];
	
	NSAssert(prop, @"Property for selector %@ cannot be null", propertyName);
	
	NSUInteger index = [[self valueForKeyPath:prop.levelArrayKey] indexOfObject:value];
	
	[self setValue:@(index) forKeyPath:prop.indexKey];
}

static id DerivedProperty(id self, SEL _cmd)
{
	NSString *propertyName = NSStringFromSelector(_cmd);
	TRStructureDescriptionDerivedProperty *prop = [[[[self class] structureDescription] derivedProperties] objectForKey:propertyName];
	
	NSAssert(prop, @"Property for selector %@ cannot be null", propertyName);
	
	NSUInteger index = [[self valueForKeyPath:prop.indexKey] unsignedIntegerValue];
	id object = [[self valueForKeyPath:prop.levelArrayKey] objectAtIndex:index];
	
	return object;
}

@implementation TRStructureDescriptionDerivedProperty

+ (void)initialize
{
	expression = [[NSRegularExpression alloc] initWithPattern:lineRegexpString options:0 error:NULL];
}

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;
	
	NSTextCheckingResult *components = [expression firstMatchInString:fieldDescription options:0 range:NSMakeRange(0, fieldDescription.length)];
	
	NSAssert(components, @"Could not match regexp with line %@", fieldDescription);
	NSAssert(components.range.location != NSNotFound, @"Trouble matching %@ against regexp", fieldDescription);
	
	self.objectKey = [fieldDescription substringWithRange:[components rangeAtIndex:1]];
	self.levelArrayKey = [fieldDescription substringWithRange:[components rangeAtIndex:2]];
	self.indexKey = [fieldDescription substringWithRange:[components rangeAtIndex:3]];
	
	return self;
}

- (void)addMethodsToClass:(Class)class;
{
	SEL getterSelector = NSSelectorFromString(self.objectKey);
	class_addMethod(class, getterSelector, (IMP) DerivedProperty, "@@:");
	
	NSMutableString *setterSelectorString = [self.objectKey mutableCopy];
	[setterSelectorString insertString:@"set" atIndex:0];
	[setterSelectorString appendString:@":"];
	[setterSelectorString replaceCharactersInRange:NSMakeRange(3, 1) withString:[[self.objectKey substringToIndex:1] uppercaseString]];
	
	SEL setterSelector = NSSelectorFromString(setterSelectorString);
	class_addMethod(class, setterSelector, (IMP) SetDerivedProperty, "v@:@");
}

@end
