//
//  TRRenderTexture.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TR1Level;
@class TR1Texture;

@interface TRRenderTexture : NSObject

- (id)initWithLevel:(TR1Level *)level;

@property (nonatomic, retain, readonly) TR1Level *level;
@property (nonatomic, assign, readonly) NSUInteger width;
@property (nonatomic, assign, readonly) NSUInteger height;

- (NSData *)create32BitData;

- (void)getTextureCoords:(float *)coords forTexture:(TR1Texture *)texture corner:(NSUInteger)corner;
- (void)getTextureCoords:(float *)coords forColorIndex:(uint8_t)colorIndex;

@end
