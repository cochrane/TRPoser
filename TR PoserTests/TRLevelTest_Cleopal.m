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
	NSURL *palaceURL = [self cleopatraPalaceURL];
	
	STAssertTrue(palaceURL != nil, @"Tomb Raider 4 or LE data has to be on this computer for the test to work.");
	if (palaceURL == nil) return nil;
	
	NSData *palaceData = [NSData dataWithContentsOfURL:palaceURL];
	STAssertTrue(palaceData != nil, @"Cannot open cleopal.tr4");
	if (palaceData == nil) return nil;
	
	return [[TRInDataStream alloc] initWithData:palaceData];
}

- (void)testCleopatraPalace;
{
	TRInDataStream *stream = [self cleopatraPalaceData];
	if (!stream) return; // No TR2 on this computer
	
	TR4Level *level = [[TR4Level alloc] initFromDataStream:stream];
	STAssertTrue(level != nil, @"Level was not loaded");
	
	STAssertTrue([stream isAtEnd], @"Did not read entire level");
	
	STAssertEquals((NSUInteger) 8+8+5, level.textureTiles16.count, @"Count of tex tiles (16 bit)");
	STAssertEquals((NSUInteger) 8+8+5, level.textureTiles32.count, @"Count of tex tiles (32 bit)");
	STAssertEquals((NSUInteger)2, level.specialTextureTiles.count, @"Count of tex tiles (font and sky)");
	STAssertEquals((NSUInteger) 116, level.rooms.count, @"Count of rooms");
	STAssertEquals((NSUInteger) 520, level.meshPointers.count, @"Count of mesh pointers");
}

- (void)testCleopatraPalaceTranscode;
{
	TRInDataStream *originalStream = [self cleopatraPalaceData];
	if (!originalStream) return; // No TR2 on this computer
	
	TR4Level *original = [[TR4Level alloc] initFromDataStream:originalStream];
	
	TROutDataStream *outStream = [[TROutDataStream alloc] init];
	[original writeToStream:outStream];
	
	TRInDataStream *transcodedStream = [[TRInDataStream alloc] initWithData:outStream.data];
	
	TR4Level *level = [[TR4Level alloc] initFromDataStream:transcodedStream];
	STAssertTrue(level != nil, @"Transcoded level was not loaded");
	
	STAssertTrue([transcodedStream isAtEnd], @"Did not read entire level");
	
	STAssertEquals((NSUInteger) 8+8+5, level.textureTiles16.count, @"Count of tex tiles (16 bit)");
	STAssertEquals((NSUInteger) 8+8+5, level.textureTiles32.count, @"Count of tex tiles (32 bit)");
	STAssertEquals((NSUInteger)2, level.specialTextureTiles.count, @"Count of tex tiles (font and sky)");
	STAssertEquals((NSUInteger) 116, level.rooms.count, @"Count of rooms");
	STAssertEquals((NSUInteger) 520, level.meshPointers.count, @"Count of mesh pointers");
}

@end
