//
//  TRLevelTest_Jungle.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRLevelTest_Jungle.h"

#import "TR3Level.h"
#import "TRInDataStream.h"

@implementation TRLevelTest_Jungle

- (NSURL *)jungleURL;
{
	NSTask *mdFindTask = [[NSTask alloc] init];
	
	mdFindTask.launchPath = @"/usr/bin/mdfind";
	mdFindTask.arguments = @[ @"(kMDItemDisplayName = \"JUNGLE.TR2\") && (kMDItemFSSize = 3360001)" ];
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

- (TRInDataStream *)jungleData;
{
	NSURL *jungleURL = [self jungleURL];
	
	STAssertTrue(jungleURL != nil, @"Tomb Raider 3 level data has to be present on this computer.");
	if (jungleURL == nil) return nil;
	
	NSData *cavesData = [NSData dataWithContentsOfURL:jungleURL];
	STAssertTrue(cavesData != nil, @"Cannot open JUNGLE.TR2");
	if (cavesData == nil) return nil;
	
	return [[TRInDataStream alloc] initWithData:cavesData];
}

- (void)testJungle;
{
	TRInDataStream *stream = [self jungleData];
	if (!stream) return; // No TR2 on this computer
	
	TR3Level *level = [[TR3Level alloc] initFromDataStream:stream];
	STAssertTrue(level != nil, @"Level was not loaded");
	
	STAssertTrue([stream isAtEnd], @"Did not read entire level");
}

@end
