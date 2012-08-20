//
//  TRRenderLevel.h
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TR1Level;
@class TR1Texture;

@interface TRRenderLevel : NSObject

- (id)initWithLevel:(TR1Level *)aLevel;

@property (nonatomic, retain) TR1Level *level;

@property (nonatomic, readonly) CGImageRef textureImage;

//- (void)getTextureCoords:(float *)sixteenFloats forObjectTexture:(TR1Texture *)texture;

//- (NSImage *)combinedTexture;

@end
