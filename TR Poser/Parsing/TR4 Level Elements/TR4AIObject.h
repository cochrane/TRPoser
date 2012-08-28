//
//  TR4AIObject.h
//  TR Poser
//
//  Created by Torsten Kammer on 28.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TRStructure.h"

@interface TR4AIObject : TRStructure

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, assign) NSUInteger roomIndex;
@property (nonatomic, assign) NSInteger positionX;
@property (nonatomic, assign) NSInteger positionY;
@property (nonatomic, assign) NSInteger positionZ;
@property (nonatomic, assign) NSUInteger ocb;
@property (nonatomic, assign) NSUInteger flags;
@property (nonatomic, assign) NSUInteger angle;

@end
