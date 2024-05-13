//
//  SceneData.m
//  MetalDemo
//

#import "SceneData.h"
#import "ShaderSharedTypes.h"
#import "MetalMatrix.h"

@import MetalKit;

// Define a 3D cube and the vertex indices that describe its faces.
static const VertexData cubeVertices[] =
{
    //    3D positions,    RGBA colors
    { {  -1,  1,  1, 1 }, { 1, 1, 1, 1 } },     // front top left
    { {   1,  1,  1, 1 }, { 1, 1, 1, 1 } },     // front top right
    { {   1, -1,  1, 1 }, { 0, 1, 0, 1 } },     // front bottom right
    { {  -1, -1,  1, 1 }, { 0, 1, 0, 1 } },     // front bottom left
    { {  -1,  1, -1, 1 }, { 1, 1, 1, 1 } },        // back top left
    { {   1,  1, -1, 1 }, { 1, 1, 1, 1 } },     // back top right
    { {   1, -1, -1, 1 }, { 0, 1, 0, 1 } },     // back bottom right
    { {  -1, -1, -1, 1 }, { 0, 1, 0, 1 } },     // back bottom left
};

static const UInt32 cubeIndices[] = {
    // front face
    0, 1, 3,    // front top left, front top right, front bottom left
    1, 2, 3,    // front top right, front bottom right, front bottom left
    
    // right face
    1, 2, 6,    // front top right, front bottom right, back bottom right
    1, 5, 6,    // front top right, back top right, back bottom right
    
    // rear face
    4, 5, 7,    // back top left, back top right, back bottom left
    5, 6, 7,    // back top right, back bottom right, back bottom left
    
    // left face
    3, 4, 7,    // front bottom left, back top left, back bottom left
    0, 3, 4,    // front top left, front bottom left, back top left
    
    // top face
    0, 1, 4,    // front top left, front top right, back top left
    1, 4, 5,    // front top right, back top left, back top right
    
    // bottom face
    2, 3, 6,    // front bottom right, front bottom left, back bottom right
    3, 6, 7,    // front bottom left, back bottom right, back bottom left
};

@implementation SceneData
{
    id<MTLBuffer> _cubeIndexBuffer;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device
{
    self = [super init];
    if (self)
    {
        _cubeIndexBuffer = [device newBufferWithBytes:cubeIndices
                                               length:sizeof(cubeIndices)
                                              options:MTLResourceStorageModeShared];
    }
    
    return self;
}

- (void)renderIntoEncoder:(id<MTLRenderCommandEncoder>)encoder
{
    simd_float4x4 modelMatrix = [MetalMatrix mm_identity];
    
    [encoder setVertexBytes:cubeVertices
                     length:sizeof(cubeVertices)
                    atIndex:VertexDataInputIndexVertices];

    [encoder setVertexBytes:&modelMatrix
                     length:[MetalMatrix mm_matrixSize]
                    atIndex:VertexDataInputIndexModelMatrix];
    
    [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                        indexCount:sizeof(cubeIndices) / sizeof(UInt32)
                         indexType:MTLIndexTypeUInt32
                       indexBuffer:_cubeIndexBuffer
                 indexBufferOffset:0];
    
    NSLog(@"SceneData drew");
}

@end
