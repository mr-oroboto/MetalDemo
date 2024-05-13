//
//  SceneData.m
//  MetalDemo
//

#import "SceneData.h"
#import "ShaderSharedTypes.h"

@import MetalKit;

@implementation SceneData
{
}

- (void)renderIntoEncoder:(id<MTLRenderCommandEncoder>)encoder
{
    static const VertexData triangle[] =
    {
        {{0, 0, 0, 1}, {1, 1, 1, 1}},
        {{0, 0, 0, 1}, {1, 1, 1, 1}},
        {{0, 0, 0, 1}, {1, 1, 1, 1}},
    };
    
    [encoder setVertexBytes:triangle
                           length:sizeof(triangle)
                          atIndex:VertexDataInputIndexVertices];

    [encoder drawPrimitives:MTLPrimitiveTypeTriangle
                vertexStart:0
                vertexCount:3];
}

@end
