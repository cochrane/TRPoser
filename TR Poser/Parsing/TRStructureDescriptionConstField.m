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
@property (nonatomic, copy, readwrite) NSNumber *expectedValue;

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
	
	NSNumber *expectedValue = nil;
	if (![scanner scanValueOfPrimitiveType:self.type intoNumber:&expectedValue]) return nil;
	self.expectedValue = expectedValue;
	
	return self;
}
- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
{
	NSNumber *found = [stream readNumberOfPrimitiveType:self.type];
	if (![found isEqual:self.expectedValue])
		[NSException raise:NSInvalidArgumentException format:@"At location %lu expected value %@, got %@", stream.position, self.expectedValue, found];
}
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;
{
	[stream appendNumber:self.expectedValue ofPrimitiveType:self.type];
}

@end
