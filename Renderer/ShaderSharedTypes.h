//
//  ShaderSharedTypes.h
//  MetalDemo
//

#ifndef ShaderSharedTypes_h
#define ShaderSharedTypes_h

#include <simd/simd.h>

// Defines the vertex data that is sent to the vertex shader. The
// definition is shared between the renderer and the shader code.
typedef struct
{
    vector_float4 position;
    vector_float4 colour;
} VertexData;

// Allows for easy (named) referencing of vertex shader inputs.
typedef enum VertexDataInputIndex
{
    VertexDataInputIndexVertices = 0,
    VertexDataInputIndexModelMatrix = 1,
    VertexDataInputIndexViewMatrix = 2,
    VertexDataInputIndexProjectionMatrix = 3
} VertexDataInputIndex;

#endif /* ShaderSharedTypes_h */
