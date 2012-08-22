//
//  TRRenderRoomGeometry.h
//  TR Poser
//
//  Created by Torsten Kammer on 22.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "TRRenderRoomGeometry.h"

@interface TRRenderRoomGeometrySCN : TRRenderRoomGeometry

- (SCNGeometry *)roomGeometry;

@property (nonatomic, assign, readonly) SCNVector3 offset;

@end
