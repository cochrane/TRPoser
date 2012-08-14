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
		if (field.type != nil)
		{
			id object = [[field.type alloc] initFromDataStream:stream inLevel:self.level];
			[self setValue:object forKey:field.name];
		}
		else
		{
			NSNumber *number = [stream readNumberWithBits:field.bits signed:field.isSigned];
			[self setValue:number forKey:field.name];
		}
	}
	
	return self;
}

- (void)writeToStream:(TROutDataStream *)stream;
{
	for (TRSimpleStructureDescriptionField *field in self.class.structureDescription.fields)
	{
		if (field.type != nil)
		{
			id object = [self valueForKey:field.name];
			[object writeToStream:stream];
		}
		else
		{
			NSNumber *number = [self valueForKey:field.name];
			[stream appendNumber:number bits:field.bits signed:field.isSigned];
		}
	}
}

@end
