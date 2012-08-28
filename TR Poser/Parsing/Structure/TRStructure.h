//
//  TRSimpleStructure.h
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRStructureDescription;

@class TRInDataStream;
@class TROutDataStream;

@class TR1Level;

/**
 * @abstract Base class for all data that uses the simplified
 * structure format.
 *
 * @description The TRStructure system seems fairly complex. It implements its
 * own domain-specific language specifically to read TR files. Any specific
 * structure will be a subclass of this class. The important information for
 * each class is encapsulated in a TRStructureDescription. The class can create
 * its own or just provide the source code (this is preferred).
 */
@interface TRStructure : NSObject

+ (TRStructureDescription *)structureDescription;
+ (NSString *)structureDescriptionSource;

- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level substreams:(NSDictionary * __autoreleasing *)substreams;
- (void)parseStream:(TRInDataStream *)stream description:(TRStructureDescription *)description substreams:(NSDictionary * __autoreleasing *)substreams;
- (void)writeToStream:(TROutDataStream *)stream;
- (void)writeToStream:(TROutDataStream *)stream substreams:(NSDictionary *)substreams;
- (void)writeToStream:(TROutDataStream *)stream description:(TRStructureDescription *)description substreams:(NSDictionary *)substreams;

@property (nonatomic, weak, readonly) TR1Level *level;

@end
