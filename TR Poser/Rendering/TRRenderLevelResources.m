//
//  TRRenderLevelResources.m
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRRenderLevelResources.h"

#import "TR1Level.h"

#import "TRRenderTexture.h"

@interface TRRenderLevelResources ()

@end


@implementation TRRenderLevelResources

- (id)initWithLevel:(TR1Level *)aLevel;
{
	if (!(self = [super init])) return nil;
	
	_level = aLevel;
	_renderTexture = [[TRRenderTexture alloc] initWithLevel:_level];
	
	
	return self;
}

@end
