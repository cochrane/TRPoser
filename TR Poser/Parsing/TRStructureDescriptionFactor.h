//
//  TRStructureDescriptionFactor.h
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructureDescriptionItem.h"

typedef enum {
	TRStructureDescriptionFactor_Unsigned,
	TRStructureDescriptionFactor_Signed,
	TRStructureDescriptionFactor_Double,
} TRStructureDescriptionFactor_Type ;

@interface TRStructureDescriptionFactor : TRStructureDescriptionItem

- (id)initWithString:(NSString *)fieldDescription;

@property (nonatomic, copy) NSString *derivedFieldName;
@property (nonatomic, copy) NSString *originalFieldName;
@property (nonatomic, assign) TRStructureDescriptionFactor_Type type;
@property (nonatomic, copy) NSNumber *factor;
@property (nonatomic, assign) BOOL divide;

- (void)addMethodsToClass:(Class)class;

@end
