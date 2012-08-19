//
//  TR4MeshFace.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR3MeshFace.h"

@interface TR4MeshFace : TR3MeshFace

@property (nonatomic, assign, readwrite) BOOL hasAlpha;
@property (nonatomic, assign, readwrite) NSUInteger shininess;

@end
