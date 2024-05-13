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
                                     constant VertexData* vertices [[buffer(VertexDataInputIndexVertices)]])
{
    RasterizerOutput out;
    
    // TODO: implement shader
    out.position.x = 0;
    out.position.y = 0;
    out.position.z = 0;
    
    out.colour = 0;
    
    return out;
}

fragment float4 fragmentShader(RasterizerOutput in [[stage_in]])
{
    return in.colour;
}
