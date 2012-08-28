//
//  TR4FlybyCamera.h
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@interface TR4FlybyCamera : TRStructure

@property (nonatomic, assign) NSInteger position1X;
@property (nonatomic, assign) NSInteger position1Y;
@property (nonatomic, assign) NSInteger position1Z;
@property (nonatomic, assign) NSInteger position2X;
@property (nonatomic, assign) NSInteger position2Y;
@property (nonatomic, assign) NSInteger position2Z;

@property (nonatomic, assign) NSUInteger index1;
@property (nonatomic, assign) NSUInteger index2;

@property (nonatomic, assign) NSUInteger unknown1;
@property (nonatomic, assign) NSUInteger unknown2;
@property (nonatomic, assign) NSUInteger unknown3;
@property (nonatomic, assign) NSUInteger unknown4;
@property (nonatomic, assign) NSUInteger unknown5;

@property (nonatomic, assign) NSUInteger cameraID;

@end
