//
//  TR1CinematicFrame.h
//  TR Poser
//
//  Created by Torsten Kammer on 15.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@interface TR1CinematicFrame : TRStructure

@property (nonatomic, assign) NSInteger rotX;
@property (nonatomic, assign) NSInteger rotY;
@property (nonatomic, assign) NSInteger rotZ;
@property (nonatomic, assign) NSInteger rotZ2;

@property (nonatomic, assign) NSInteger posX;
@property (nonatomic, assign) NSInteger posY;
@property (nonatomic, assign) NSInteger posZ;

@end
