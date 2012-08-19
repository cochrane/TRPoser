//
//  TRStructureDescriptionConstField.m
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionConstField.h"

@interface TRStructureDescriptionConstField ()

@property (nonatomic, assign, readwrite) TRStructureDescriptionPrimitiveType type;
@property (nonatomic, copy, readwrite) NSArray *expectedValues;

@end

@implementation TRStructureDescriptionConstField

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;
	
	NSScanner *scanner = [NSScanner scannerWithString:fieldDescription];
	
	if (![scanner scanString:@"const" intoString:NULL])
		return nil;
	
	TRStructureDescriptionPrimitiveType type;
	if (![scanner scanPrimitiveType:&type]) return nil;
	self.type = type;
	
	if (![scanner scanString:@"=" intoString:NULL]) return nil;
	
	NSMutableArray *expectedValues = [[NSMutableArray alloc] init];
	NSNumber *firstValue = nil;
	if (![scanner scanValueOfPrimitiveType:self.type intoNumber:&firstValue]) return nil;
	[expectedValues addObject:firstValue];
	
	while([scanner scanString:@"," intoString:NULL])
	{
		NSNumber *nextValue = nil;
		if (![scanner scanValueOfPrimitiveType:self.type intoNumber:&nextValue]) return nil;
		[expectedValues addObject:nextValue];
	}
	self.expectedValues = expectedValues;
	
	NSAssert([scanner isAtEnd], @"Line %@ goes too long", fieldDescription);
	
	return self;
}
- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
{
	NSAssert(![stream isAtEnd], @"Stream should not yet be over here.");
	
	NSNumber *found = [stream readNumberOfPrimitiveType:self.type];
	NSUInteger index = [self.expectedValues indexOfObject:found];
	if (index == NSNotFound)
		[NSException raise:NSInvalidArgumentException format:@"At location %lu expected any one of %@, got %@", stream.position, self.expectedValues, found];
}
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;
{
	[stream appendNumber:[self.expectedValues objectAtIndex:0] ofPrimitiveType:self.type];
}

@end
