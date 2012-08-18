//
//  TRSimpleStructureDescriptionDerivedProperty.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionItem.h"

@interface TRStructureDescriptionDerivedProperty : TRStructureDescriptionItem

@property (nonatomic, copy, readonly) NSString *objectKey;
@property (nonatomic, copy, readonly) NSString *levelArrayKey;
@property (nonatomic, copy, readonly) NSString *indexKey;

- (void)addMethodsToClass:(Class)class;

@end
