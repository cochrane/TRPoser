//
//  TRStructureDescriptionPrimitiveType.m
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionPrimitiveType.h"

@implementation NSScanner (ScanPrimitiveType)

- (BOOL)scanPrimitiveType:(TRStructureDescriptionPrimitiveType *)type
{
	if ([self scanString:@"bit8" intoString:NULL])
	{
		*type = TRSDCP_bit8;
		return YES;
	}
	else if ([self scanString:@"bit16" intoString:NULL])
	{
		*type = TRSDCP_bit16;
		return YES;
	}
	else if ([self scanString:@"bit32" intoString:NULL])
	{
		*type = TRSDCP_bit32;
		return YES;
	}
	else if ([self scanString:@"bitu8" intoString:NULL])
	{
		*type = TRSDCP_bitu8;
		return YES;
	}
	else if ([self scanString:@"bitu16" intoString:NULL])
	{
		*type = TRSDCP_bitu16;
		return YES;
	}
	else if ([self scanString:@"bitu32" intoString:NULL])
	{
		*type = TRSDCP_bitu32;
		return YES;
	}
	else if ([self scanString:@"float32" intoString:NULL])
	{
		*type = TRSDCP_float32;
		return YES;
	}
	else
		return NO;
}

@end

@implementation TRInDataStream (ReadPrimitiveType)

- (NSNumber *)readNumberOfPrimitiveType:(TRStructureDescriptionPrimitiveType)type;
{
	switch(type)
	{
		case TRSDCP_bit8:
			return @([self readInt8]);
		case TRSDCP_bit16:
			return @([self readInt16]);
		case TRSDCP_bit32:
			return @([self readInt32]);
		case TRSDCP_bitu8:
			return @([self readUint8]);
		case TRSDCP_bitu16:
			return @([self readUint16]);
		case TRSDCP_bitu32:
			return @([self readUint32]);
		case TRSDCP_float32:
			return @([self readFloat32]);
		default:
			[NSException raise:NSInvalidArgumentException format:@"Value %u is no primitive data type", type];
			return nil; // Just to silence warning.
	}
}

@end

@implementation TROutDataStream (WritePrimitiveType)

- (void)appendNumber:(NSNumber *)number ofPrimitiveType:(TRStructureDescriptionPrimitiveType)type
{	switch(type)
	{
		case TRSDCP_bit8:
			[self appendInt8:number.charValue];
			break;
		case TRSDCP_bit16:
			[self appendInt16:number.shortValue];
			break;
		case TRSDCP_bit32:
			[self appendInt32:number.intValue];
			break;
		case TRSDCP_bitu8:
			[self appendUint8:number.unsignedCharValue];
			break;
		case TRSDCP_bitu16:
			[self appendUint16:number.unsignedShortValue];
			break;
		case TRSDCP_bitu32:
			[self appendUint32:number.unsignedIntValue];
			break;
		case TRSDCP_float32:
			[self appendFloat32:number.floatValue];
			break;
		default:
			[NSException raise:NSInvalidArgumentException format:@"Value %u is no primitive data type", type];
	}
}

@end
