//
//  TRSimpleStructureDescription.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRSimpleStructureDescription : NSObject

- (id)initWithSource:(NSString *)description;

@property (nonatomic, copy, readonly) NSArray *fields;

@end
