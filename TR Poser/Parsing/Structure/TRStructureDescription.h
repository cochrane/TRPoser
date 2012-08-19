//
//  TRSimpleStructureDescription.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRStructureDescription : NSObject

- (id)initWithSource:(NSString *)description;

@property (nonatomic, copy, readonly) NSArray *fields;
@property (nonatomic, copy, readonly) NSDictionary *derivedProperties;
@property (nonatomic, copy, readonly) NSDictionary *factorProperties;

@end
