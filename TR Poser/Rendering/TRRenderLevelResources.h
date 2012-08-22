//
//  TRRenderLevelResources.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TR1Level;
@class TRRenderTexture;

@interface TRRenderLevelResources : NSObject

- (id)initWithLevel:(TR1Level *)aLevel;

@property (nonatomic, retain, readonly) TR1Level *level;
@property (nonatomic, retain, readonly) TRRenderTexture *renderTexture;

@end
