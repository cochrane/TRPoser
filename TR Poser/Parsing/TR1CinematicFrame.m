//
//  TR1CinematicFrame.m
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1CinematicFrame.h"

@interface TR1CinematicFrame ()

@property (nonatomic, assign) NSUInteger unknown;

@end

@implementation TR1CinematicFrame

+ (NSString *)structureDescriptionSource
{
	return @"bit16 rotY;\
	bit16 rotZ;\
	bit16 rotZ2;\
	bit16 posZ;\
	bit16 posY;\
	bit16 posX;\
	bitu16 unknown;\
	bit16 rotX;";
}

@end
