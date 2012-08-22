//
//  TRRenderMesh.h
//  
//
//  Created by Torsten Kammer on 22.08.12.
//
//

#import <Foundation/Foundation.h>

@class TR1Mesh;

@class TRRenderLevelResources;

@interface TRRenderMesh : NSObject

- (id)initWithMesh:(TR1Mesh *)mesh resources:(TRRenderLevelResources *)resources;

@property (nonatomic, retain, readonly) TR1Mesh *mesh;
@property (nonatomic, weak, readonly) TRRenderLevelResources *resources;


@property (nonatomic, assign, readonly) BOOL internalLighting;
@property (nonatomic, assign, readonly) BOOL hasAlpha;

/* Format:
 * position - 3 floats
 * normals - 3 floats OR color - 3 floats
 * tex coord - 2 floats
 */
- (NSData *)createVertexDataVectorCount:(NSUInteger *)vectorCount;

/* Format: uint16t_s, disjoint triangles.
 * First the ones without alpha, then the ones
 * with alpha.
 */
- (NSData *)createElementsNormalCount:(NSUInteger *)normalCount alphaCount:(NSUInteger *)alphaCount;

@end
