//
//  TR1SimpleStructureDescriptionItem.h
//  
//
//  Created by Torsten Kammer on 14.08.12.
//
//

#import <Foundation/Foundation.h>

@class TRInDataStream;
@class TROutDataStream;
@class TRStructure;

@interface TRStructureDescriptionField : NSObject

// This will create an instance of a subclass. Do not
// call it from subclasses
- (id)initWithString:(NSString *)fieldDescription;

// Subclasses should override either of these sets of
// methods.
- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure;
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure;

- (void)parseFromStream:(TRInDataStream *)stream intoObject:(TRStructure *)structure substreams:(NSDictionary *__autoreleasing*)substreams;
- (void)writeToStream:(TROutDataStream *)stream fromObject:(TRStructure *)structure substreams:(NSDictionary *)substreams;

@end
