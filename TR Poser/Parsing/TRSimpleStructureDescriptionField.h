//
//  TRSimpleStructureDescriptionField.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRSimpleStructureDescriptionField : NSObject

- (id)initWithString:(NSString *)fieldDescription;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, retain) Class type;
@property (nonatomic, readonly, assign) BOOL isSigned;
@property (nonatomic, readonly, assign) NSUInteger bits;
@property (nonatomic, readonly, assign) NSUInteger fixedArrayLength;
@property (nonatomic, readonly, assign) NSUInteger countFieldBits;

@end
