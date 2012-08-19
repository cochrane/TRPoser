//
//  TR1Level.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR1Level.h"

#import "TRInDataStream.h"

#import "TR1Vertex.h"
#import "TR1RoomLight.h"
#import "TR1RoomVertex.h"

@implementation TR1Level

- (NSUInteger)gameVersion;
{
	return 1;
}

- (Class)versionedClassForName:(NSString *)classNameSuffix;
{
	for (NSUInteger i = self.gameVersion; i > 0; i--)
	{
		NSString *versionedName = [NSString stringWithFormat:@"TR%lu%@", i, classNameSuffix];
		Class result = NSClassFromString(versionedName);
		if (result) return result;
	}
	return nil;
}

@end
