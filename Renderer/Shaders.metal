//
//  Shaders.metal
//  MetalDemo
//

#include <metal_stdlib>
using namespace metal;

#include "ShaderSharedTypes.h"

// This is the structure of data output by the vertex shader into
// the rasterizer.
struct RasterizerOutput
{
    float4 position [[position]];   // hint as to which attribute is the clip space position of the vertex
    float4 colour;
};

vertex RasterizerOutput vertexShader(uint vertexId [[vertex_id]],
                                     constant VertexData* vertices [[buffer(VertexDataInputIndexVertices)]],
                                     constant float4x4* modelMatrix [[buffer(VertexDataInputIndexModelMatrix)]],
                                     constant float4x4* viewMatrix [[buffer(VertexDataInputIndexViewMatrix)]],
                                     constant float4x4* projectionMatrix [[buffer(VertexDataInputIndexProjectionMatrix)]])
{
    RasterizerOutput out;
    
    out.position = projectionMatrix[0] * viewMatrix[0] * modelMatrix[0] * vertices[vertexId].position;
    out.colour = vertices[vertexId].colour;
    
    return out;
}

fragment float4 fragmentShader(RasterizerOutput in [[stage_in]])
{
    return in.colour;
}
