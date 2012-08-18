//
//  TRStructureDescriptionPrimitiveType.h
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRInDataStream.h"
#import "TROutDataStream.h"

typedef enum {
	TRSDCP_invalid = 0,
	
	TRSDCP_bit8,
	TRSDCP_bit16,
	TRSDCP_bit32,
	
	TRSDCP_bitu8,
	TRSDCP_bitu16,
	TRSDCP_bitu32,
	
	TRSDCP_float32
} TRStructureDescriptionPrimitiveType;

@interface NSScanner (ScanPrimitiveType)

- (BOOL)scanPrimitiveType:(TRStructureDescriptionPrimitiveType *)type;
- (BOOL)scanValueOfPrimitiveType:(TRStructureDescriptionPrimitiveType)type intoNumber:(NSNumber *__autoreleasing *)number;

@end

@interface TRInDataStream (ReadPrimitiveType)

- (NSNumber *)readNumberOfPrimitiveType:(TRStructureDescriptionPrimitiveType)type;

@end

@interface TROutDataStream (WritePrimitiveType)

- (void)appendNumber:(NSNumber *)number ofPrimitiveType:(TRStructureDescriptionPrimitiveType)type;

@end
