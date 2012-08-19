//
//  TR2SoundDetails.m
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1SoundDetails.h"

@interface TR1SoundDetails ()

@property (nonatomic, assign) NSUInteger unknown1;
@property (nonatomic, assign) NSUInteger unknown2;

@end

@implementation TR1SoundDetails

+ (NSString *)structureDescriptionSource
{
	return @"bitu16 sample;\
	bitu16 volume;\
	bitu16 unknown1;\
	bitu16 unknown2;";
}

@end
