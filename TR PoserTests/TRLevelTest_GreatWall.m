//
//  TRLevelTest_GreatWall.m
//  TR Poser
//
//  Created by Torsten Kammer on 18.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRLevelTest_GreatWall.h"

#import "TRInDataStream.h"
#import "TR2Level.h"

@implementation TRLevelTest_GreatWall

- (NSURL *)greatWallURL;
{
	NSURL *tr2URL = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:@"com.aspyr.tombraider2"];
	NSURL *contents = [tr2URL URLByAppendingPathComponent:@"Contents"];
	NSURL *tr2Data = [contents URLByAppendingPathComponent:@"Tomb Raider 2 Data"];
	NSURL *data = [tr2Data URLByAppendingPathComponent:@"Data"];
	return [data URLByAppendingPathComponent:@"WALL.TR2"];
}

- (TRInDataStream *)greatWallData;
{
	NSURL *wallURL = [self greatWallURL];
	
	STAssertTrue(wallURL != nil, @"Tomb Raider 2 has to be installed on this computer for the test to work.");
	if (wallURL == nil) return nil;
	
	NSData *wallData = [NSData dataWithContentsOfURL:wallURL];
	STAssertTrue(wallData != nil, @"Cannot open WALL.TR2");
	if (wallData == nil) return nil;
	
	return [[TRInDataStream alloc] initWithData:wallData];
}

- (void)testGreatWall;
{
	TRInDataStream *stream = [self greatWallData];
	
	TR2Level *level = [[TR2Level alloc] initFromDataStream:stream];
	STAssertTrue(level != nil, @"Level was not loaded");
	
	STAssertTrue([stream isAtEnd], @"Did not read entire level");
	
	STAssertEquals((NSUInteger) 11, level.textureTiles8.count, @"Count of tex tiles (8 bit)");
	STAssertEquals((NSUInteger) 11, level.textureTiles16.count, @"Count of tex tiles (16 bit)");
	STAssertEquals((NSUInteger) 84, level.rooms.count, @"Count of rooms");
	STAssertEquals((NSUInteger) 373, level.meshPointers.count, @"Count of mesh pointers");
}

@end
