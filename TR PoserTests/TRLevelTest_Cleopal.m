//
//  TRLevelTest_Cleopal.m
//  TR Poser
//
//  Created by Torsten Kammer on 27.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRLevelTest_Cleopal.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"
#import "TR4Level.h"

@implementation TRLevelTest_Cleopal

- (NSURL *)cleopatraPalaceURL;
{
	NSTask *mdFindTask = [[NSTask alloc] init];
	
	mdFindTask.launchPath = @"/usr/bin/mdfind";
	mdFindTask.arguments = @[ @"(kMDItemDisplayName = \"cleopal.tr4\") && (kMDItemFSSize = 8085914)" ];
	NSPipe *pipe = [[NSPipe alloc] init];
	mdFindTask.standardOutput = pipe;
	
	[mdFindTask launch];
	
	NSData *read = [[pipe fileHandleForReading] readDataToEndOfFile];
	[mdFindTask waitUntilExit];
	
	if (read.length == 0) return nil;
	
	NSString *readString = [[NSString alloc] initWithData:read encoding:NSUTF8StringEncoding];
	NSArray *paths = [readString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	NSString *firstPath = [paths objectAtIndex:0];
	
	return [NSURL fileURLWithPath:firstPath];
}

- (TRInDataStream *)cleopatraPalaceData;
{
	NSURL *wallURL = [self greatWallURL];
	
	STAssertTrue(wallURL != nil, @"Tomb Raider 2 has to be installed on this computer for the test to work.");
	if (wallURL == nil) return nil;
	
	NSData *wallData = [NSData dataWithContentsOfURL:wallURL];
	STAssertTrue(wallData != nil, @"Cannot open WALL.TR2");
	if (wallData == nil) return nil;
	
	return [[TRInDataStream alloc] initWithData:wallData];
}

- (void)testCleopatraPalace;
{
	TRInDataStream *stream = [self greatWallData];
	if (!stream) return; // No TR2 on this computer
	
	TR4Level *level = [[TR4Level alloc] initFromDataStream:stream];
	STAssertTrue(level != nil, @"Level was not loaded");
	
	STAssertTrue([stream isAtEnd], @"Did not read entire level");
	
	STAssertEquals((NSUInteger) 11, level.textureTiles8.count, @"Count of tex tiles (8 bit)");
	STAssertEquals((NSUInteger) 11, level.textureTiles16.count, @"Count of tex tiles (16 bit)");
	STAssertEquals((NSUInteger) 84, level.rooms.count, @"Count of rooms");
	STAssertEquals((NSUInteger) 373, level.meshPointers.count, @"Count of mesh pointers");
}

- (void)testCleopatraPalaceTranscode
{
	TRInDataStream *originalStream = [self greatWallData];
	if (!originalStream) return; // No TR2 on this computer
	
	TR4Level *original = [[TR4Level alloc] initFromDataStream:originalStream];
	
	TROutDataStream *outStream = [[TROutDataStream alloc] init];
	[original writeToStream:outStream];
	
	TRInDataStream *transcodedStream = [[TRInDataStream alloc] initWithData:outStream.data];
	
	TR2Level *level = [[TR2Level alloc] initFromDataStream:transcodedStream];
	STAssertTrue(level != nil, @"Transcoded level was not loaded");
	
	STAssertTrue([transcodedStream isAtEnd], @"Did not read entire level");
	
	STAssertEquals((NSUInteger) 11, level.textureTiles8.count, @"Count of tex tiles (8 bit)");
	STAssertEquals((NSUInteger) 11, level.textureTiles16.count, @"Count of tex tiles (16 bit)");
	STAssertEquals((NSUInteger) 84, level.rooms.count, @"Count of rooms");
	STAssertEquals((NSUInteger) 373, level.meshPointers.count, @"Count of mesh pointers");
}

@end
