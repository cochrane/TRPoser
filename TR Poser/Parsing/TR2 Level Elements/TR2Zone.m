//
//  TR2Zone.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2Zone.h"

@implementation TR2Zone

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 ground1Normal;\
	bitu16 ground2Normal;\
	bitu16 ground3Normal;\
	bitu16 ground4Normal;\
	bitu16 flyNormal;\
	bitu16 ground1Alternate;\
	bitu16 ground2Alternate;\
	bitu16 ground3Alternate;\
	bitu16 ground4Alternate;\
	bitu16 flyAlternate;";
}

@end
