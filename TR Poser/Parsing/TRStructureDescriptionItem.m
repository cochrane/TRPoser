//
//  TR1SimpleStructureDescriptionItem.m
//  
//
//  Created by Torsten Kammer on 14.08.12.
//
//

#import "TRStructureDescriptionItem.h"

@implementation TRStructureDescriptionItem

- (id)initWithString:(NSString *)fieldDescription;
{
	if (!(self = [super init])) return nil;
	
	NSLog(@"Shouldn't call %@ of %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
	
	return self;
}

@end
