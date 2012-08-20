//
//  TRLevelTest_Caves.m
//  TR Poser
//
//  Created by Torsten Kammer on 19.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRLevelTest_Caves.h"

#import "TR1Level.h"
#import "TRInDataStream.h"

@implementation TRLevelTest_Caves

- (NSURL *)cavesURL;
{
	NSTask *mdFindTask = [[NSTask alloc] init];
	
	mdFindTask.launchPath = @"/usr/bin/mdfind";
	mdFindTask.arguments = @[ @"(kMDItemDisplayName = \"LEVEL1.PHD\") && (kMDItemFSSize = 2533634)" ];
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

- (TRInDataStream *)cavesData;
{
	NSURL *cavesURL = [self cavesURL];
	
	STAssertTrue(cavesURL != nil, @"Tomb Raider 2 has to be installed on this computer for the test to work.");
	if (cavesURL == nil) return nil;
	
	NSData *cavesData = [NSData dataWithContentsOfURL:cavesURL];
	STAssertTrue(cavesData != nil, @"Cannot open LEVEL1.PHD");
	if (cavesData == nil) return nil;
	
	return [[TRInDataStream alloc] initWithData:cavesData];
}

- (void)testCaves;
{
	TRInDataStream *stream = [self cavesData];
	if (!stream) return; // No TR1 on this computer
	
	TR1Level *level = [[TR1Level alloc] initFromDataStream:stream];
	STAssertTrue(level != nil, @"Level was not loaded");
	
	STAssertTrue([stream isAtEnd], @"Did not read entire level");
}


@end
