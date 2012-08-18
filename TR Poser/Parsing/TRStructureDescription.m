//
//  TRSimpleStructureDescription.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescription.h"

#import "TRStructureDescriptionField.h"
#import "TRStructureDescriptionDerivedProperty.h"
#import "TRStructureDescriptionFactor.h"

@interface TRStructureDescription ()

@property (nonatomic, copy, readwrite) NSArray *fields;
@property (nonatomic, copy, readwrite) NSDictionary *derivedProperties;
@property (nonatomic, copy, readwrite) NSDictionary *factorProperties;

@end

@implementation TRStructureDescription

- (id)initWithSource:(NSString *)description;
{
	if (!(self = [super init])) return nil;
	
	NSArray *lines = [description componentsSeparatedByString:@";"];
	
	NSMutableArray *mutableFields = [[NSMutableArray alloc] init];
	NSMutableDictionary *mutableDerivedProperties = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *mutableFactors = [[NSMutableDictionary alloc] init];
	
	for (NSString *line in lines)
	{
		NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if (trimmed.length == 0) continue;
		
		if ([trimmed hasPrefix:@"@derived"])
		{
			TRStructureDescriptionDerivedProperty *property = [[TRStructureDescriptionDerivedProperty alloc] initWithString:trimmed];
			[mutableDerivedProperties setObject:property forKey:property.objectKey];
		}
		else if ([trimmed hasPrefix:@"@factor"])
		{
			TRStructureDescriptionFactor *property = [[TRStructureDescriptionFactor alloc] initWithString:trimmed];
			[mutableFactors setObject:property forKey:property.derivedFieldName];
		}
		else
		{
			TRStructureDescriptionField *field = [[TRStructureDescriptionField alloc] initWithString:trimmed];
			NSAssert(field != nil, @"Could not load field %@", trimmed);
			[mutableFields addObject:field];
		}
	}
	
	self.fields = mutableFields;
	self.derivedProperties = mutableDerivedProperties;
	self.factorProperties = mutableFactors;
	
	return self;
}

@end
