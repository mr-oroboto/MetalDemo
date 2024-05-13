//
//  SceneData.m
//  MetalDemo
//

@import simd;

#import "SceneData.h"
#import "ShaderSharedTypes.h"
#import "MetalMatrix.h"

@import MetalKit;

// Define a 3D cube and the vertex indices that describe its faces.
static VertexData cubeVertices[] =
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
    id<MTLBuffer>   _cubeIndexBuffer;
    float           _sigma, _beta, _rho;
    vector_float3   _cubePositions[65536];
    UInt16          _currentCubePosition;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device
{
    self = [super init];
    if (self)
    {
        _cubeIndexBuffer = [device newBufferWithBytes:cubeIndices
                                               length:sizeof(cubeIndices)
                                              options:MTLResourceStorageModeShared];

        _sigma = 10.0f;
        _beta = 8.0f / 3.0f;
        _rho = 28;
        
        _currentCubePosition = 0;
        _cubePositions[_currentCubePosition] = simd_make_float3(1, 1, 1);
        
        // Every 20ms, add a new cube positioned based on a Lorenz attractor.
        [NSTimer scheduledTimerWithTimeInterval:0.02
                                         target:self
                                       selector:@selector(addCube:)
                                       userInfo:nil
                                        repeats:YES];
    }
    
    return self;
}

- (void)addCube:(NSTimer*)timer
{
    simd_float3 lastCubePosition = _cubePositions[_currentCubePosition];
    simd_float3 newCubePosition = lastCubePosition;
    simd_float3 derivatives;
    
    derivatives.x = _sigma * (lastCubePosition.y - lastCubePosition.x);
    derivatives.y = (lastCubePosition.x * (_rho - lastCubePosition.z)) - lastCubePosition.y;
    derivatives.z = (lastCubePosition.x * lastCubePosition.y) - (_beta * lastCubePosition.z);

    newCubePosition.x += (derivatives.x * 0.01);
    newCubePosition.y += (derivatives.y * 0.01);
    newCubePosition.z += (derivatives.z * 0.01);
    
    _currentCubePosition = _currentCubePosition + 1;
    _cubePositions[_currentCubePosition] = newCubePosition;
}

- (void)renderIntoEncoder:(id<MTLRenderCommandEncoder>)encoder
{
    simd_float4x4 modelMatrix = [MetalMatrix mm_identity];
    
    for (UInt16 i = 0; i < _currentCubePosition; i++) 
    {
        cubeVertices[2].colour = simd_make_float4(0, 0, 1 - ((i % 999) * 0.001), 1);
        cubeVertices[3].colour = simd_make_float4(0, 0, 1 - ((i % 999) * 0.001), 1);
        cubeVertices[6].colour = simd_make_float4(0, 0, 1 - ((i % 999) * 0.001), 1);
        cubeVertices[7].colour = simd_make_float4(0, 0, 1 - ((i % 999) * 0.001), 1);

        [encoder setVertexBytes:cubeVertices
                         length:sizeof(cubeVertices)
                        atIndex:VertexDataInputIndexVertices];

        modelMatrix = simd_mul([MetalMatrix mm_translate:_cubePositions[i]], [MetalMatrix mm_scale:0.1]);
        [encoder setVertexBytes:&modelMatrix
                         length:[MetalMatrix mm_matrixSize]
                        atIndex:VertexDataInputIndexModelMatrix];
        
        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                            indexCount:sizeof(cubeIndices) / sizeof(UInt32)
                             indexType:MTLIndexTypeUInt32
                           indexBuffer:_cubeIndexBuffer
                     indexBufferOffset:0];
    }
}

@end
