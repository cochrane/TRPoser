//
//  TRRenderRoomGeometry.h
//  
//
//  Created by Torsten Kammer on 23.08.12.
//
//

#import <Foundation/Foundation.h>

@class TR1Room;
@class TRRenderLevelResources;

@interface TRRenderRoomGeometry : NSObject

- (id)initWithRoom:(TR1Room *)room resources:(TRRenderLevelResources *)resources;

@property (nonatomic, retain, readonly) TR1Room *room;
@property (nonatomic, weak, readonly) TRRenderLevelResources *resources;

/* Format:
 * position - 3 floats
 * color - 3 floats
 * tex coord - 2 floats
 */
- (NSData *)createVertexDataVectorCount:(NSUInteger *)vectorCount;

/* Format: uint16t_s, disjoint triangles.
 * First the ones without alpha, then the ones
 * with alpha.
 */
- (NSData *)createElementsNormalCount:(NSUInteger *)normalCount alphaCount:(NSUInteger *)alphaCount;


@end
