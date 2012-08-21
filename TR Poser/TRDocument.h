//
//  TRDocument.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SceneKit/SceneKit.h>

@interface TRDocument : NSDocument

@property IBOutlet SCNView *sceneView;
@property IBOutlet NSTextField *lightValueTextfield;

- (IBAction)loadLevel:(id)sender;
- (IBAction)saveLevel:(id)sender;

- (IBAction)setAllLightingTo:(id)sender;

@end
