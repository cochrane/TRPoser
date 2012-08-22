//
//  TR3Room.m
//  TR Poser
//
//  Created by Torsten Kammer on 20.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#import "TR3Room.h"

#import "TRInDataStream.h"
#import "TROutDataStream.h"

@implementation TR3Room

- (void)readGlobalLightState:(TRInDataStream *)stream;
{
	self.ambientIntensity1 = [stream readUint16];
	self.lightMode = [stream readUint16];
}
- (void)writeGlobalLightState:(TROutDataStream *)stream;
{
	[stream appendUint16:(uint16_t) self.ambientIntensity1];
	[stream appendUint16:(uint16_t) self.lightMode];
}

- (void)readRoomFooter:(TRInDataStream *)stream;
{
	self.param1 = [stream readUint8];
	self.unknown1 = [stream readUint8];
	self.unknown2 = [stream readUint8];
}
- (void)writeRoomFooter:(TROutDataStream *)stream;
{
	[stream appendUint8:(uint8_t) self.param1];
	[stream appendUint8:(uint8_t) self.unknown1];
	[stream appendUint8:(uint8_t) self.unknown2];
}

@end
