//
//  TR2Room.m
//  TR Poser
//
//  Created by Torsten Kammer on 14.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR2Room.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@implementation TR2Room

- (void)readGlobalLightState:(TRInDataStream *)stream;
{
	self.ambientIntensity1 = [stream readUint16];
	self.ambientIntensity2 = [stream readUint16];
	self.lightMode = [stream readUint16];
}
- (void)writeGlobalLightState:(TROutDataStream *)stream;
{
	[stream appendUint16:(uint16_t) self.ambientIntensity1];
	[stream appendUint16:(uint16_t) self.ambientIntensity2];
	[stream appendUint16:(uint16_t) self.lightMode];
}

@end
