//
//  TRDocument.m
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRDocument.h"

#import "TR2Level.h"
#import "TR2RoomVertex.h"
#import "TRRenderLevelSCN.h"
#import "TRRenderLevelResources.h"
#import "TRRenderMoveable.h"
#import "TRRenderMoveableDescription.h"

@interface TRDocument ()

@property (nonatomic, retain) TRRenderLevelResources *renderLevelResources;
@property (nonatomic, retain) TRRenderLevelSCN *renderLevel;

- (void)setupLevelWithURL:(NSURL *)url;
- (void)setupGraphicsWithLevel:(TR1Level *)level;

@end

@implementation TRDocument

- (id)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"TRDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	self.sceneView.scene = [SCNScene scene];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	// You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
	@throw exception;
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	// Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
	// You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
	// If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
	@throw exception;
	return YES;
}

- (IBAction)loadLevel:(id)sender;
{
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	panel.allowedFileTypes = @[ @"phd", @"tr2", @"tr4" ];
	[panel beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSInteger result) {
		if (result != NSOKButton) return;
		
		[self setupLevelWithURL:panel.URL];
	}];
}
- (IBAction)saveLevel:(id)sender;
{
	NSSavePanel *panel = [NSSavePanel savePanel];
	panel.allowedFileTypes = @[ @"phd", @"tr2", @"tr4" ];
	[panel beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSInteger result){
		if (result != NSOKButton) return;
		
		NSData *data = [self.renderLevelResources.level writeToData];
		[data writeToURL:panel.URL atomically:YES];
	}];
}

- (void)setupLevelWithURL:(NSURL *)url;
{
	NSData *data = [NSData dataWithContentsOfURL:url];
	NSAssert(data != nil, @"Can't load %@", url);
	
	TR2Level *level = [[TR2Level alloc] initWithData:data];
	NSAssert(level != nil, @"Can't create level for %@", url);
	
	[self setupGraphicsWithLevel:level];
}
- (void)setupGraphicsWithLevel:(TR1Level *)level;
{
	self.renderLevelResources = [[TRRenderLevelResources alloc] initWithLevel:level];
	self.renderLevel = [[TRRenderLevelSCN alloc] initWithResources:self.renderLevelResources];
	
	if (self.sceneView.scene.rootNode.childNodes.count != 0)
		[self.sceneView.scene.rootNode.childNodes[0] removeFromParentNode];
	
	[self.sceneView.scene.rootNode addChildNode:self.renderLevel.rootNode];
}

@end
