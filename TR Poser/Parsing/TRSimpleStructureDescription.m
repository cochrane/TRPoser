//
//  TRSimpleStructureDescription.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRSimpleStructureDescription.h"

#import "TRSimpleStructureDescriptionField.h"

@interface TRSimpleStructureDescription ()

@property (nonatomic, copy, readwrite) NSArray *fields;

@end

@implementation TRSimpleStructureDescription

- (id)initWithSource:(NSString *)description;
{
	if (!(self = [super init])) return nil;
	
	NSArray *lines = [description componentsSeparatedByString:@";"];
	
	NSMutableArray *mutableFields = [[NSMutableArray alloc] initWithCapacity:lines.count];
	
	for (NSString *line in lines)
	{
		NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if (trimmed.length == 0) continue;
		
		TRSimpleStructureDescriptionField *field = [[TRSimpleStructureDescriptionField alloc] initWithString:trimmed];
		[mutableFields addObject:field];
	}
	
	self.fields = mutableFields;
	
	return self;
}

@end
