//
//  TR1StateChange.h
//  TR Poser
//
//  Created by Torsten Kammer on 13.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRStructure.h"

@class TR1AnimationDispatch;
@class TR1Level;

@interface TR1StateChange : TRStructure

@property (nonatomic, assign) NSUInteger stateID;
@property (nonatomic, assign) NSUInteger numAnimDispatches;
@property (nonatomic, assign) NSUInteger firstAnimDispatch;;

// Derived attributes
- (NSUInteger)countOfAnimDispatches;
- (TR1AnimationDispatch *)objectInAnimDispatchesAtIndex:(NSUInteger)index;

@end
