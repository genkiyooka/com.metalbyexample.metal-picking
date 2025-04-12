#include <metal_stdlib>
#include <simd/simd.h>

// Including header shared between this Metal shader code and Swift/C code executing Metal API commands
#include "Shaders_struct_BridgingHeader.h"

using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float4 color;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant const InstanceConstants &instance [[buffer(ShaderBufferIndex1)]])
{
    VertexOut out = {};

    float4 position(in.position, 1);
    float4 normal(in.normal, 0);
    
    out.position = instance.modelViewProjectionMatrix * position;
    out.normal = (instance.normalMatrix * normal).xyz;
    out.color = instance.color;

    return out;
}

fragment half4 fragment_main(VertexOut in [[stage_in]])
{
    float3 L(0, 0, 1);
    float3 N = normalize(in.normal);
    float NdotL = saturate(dot(N, L));

    float intensity = saturate(0.1 + NdotL);
    
    return half4(intensity * in.color);
}
