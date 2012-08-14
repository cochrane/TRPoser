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

@end

@implementation TRSimpleStructureDescriptionField

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;
	
	NSScanner *scanner = [NSScanner scannerWithString:fieldDescription];
	if ([scanner scanString:@"bit" intoString:NULL])
	{
		self.isSigned = ![scanner scanString:@"u" intoString:NULL];
		
		NSString *bits;
		[scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&bits];
		
		self.bits = bits.integerValue;
		
		NSString *name;
		[scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&name];
		
		self.name = name;
	}
	else
	{
		NSString *class;
		[scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&class];
		[scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
		
		NSString *name;
		[scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&name];
		
		self.name = name;
		self.type = NSClassFromString(class);
	}
	
	return self;
}

@end
