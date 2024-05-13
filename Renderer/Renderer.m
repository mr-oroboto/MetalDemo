//
//  Renderer.m
//  MetalDemo
//

@import simd;
@import MetalKit;

#import "Renderer.h"
#import "ShaderSharedTypes.h"
#import "SceneData.h"
#import "MetalMatrix.h"

@implementation Renderer
{
    id<MTLDevice>               _device;        // Metal's abstraction for the GPU
    id<MTLCommandQueue>         _cmdQueue;      // Queue of encoded commands to send to GPU
    id<MTLRenderPipelineState>  _pipelineState; // the render pipeline (with configured shaders etc)

    SceneData*                  _sceneData;     // draws whatever it contains

    simd_float4x4               _viewMatrix;
    simd_float4x4               _projectionMatrix;
    vector_uint2                _viewSize;      // x,y size of current viewport
}

- (nonnull instancetype)initWithMetalKitView:(MTKView *)mtkView
{
    self = [super init];
    if (self)
    {
        _device = mtkView.device;
        _cmdQueue = [_device newCommandQueue];
        _sceneData = [[SceneData alloc] initWithDevice:_device];

        // Describe the render pipeline (eg. which shaders to use, format of texture etc).
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexShader = [defaultLibrary newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentShader = [defaultLibrary newFunctionWithName:@"fragmentShader"];
        
        MTLRenderPipelineDescriptor* pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineDescriptor.label = @"Demo pipeline";
        pipelineDescriptor.vertexFunction = vertexShader;
        pipelineDescriptor.fragmentFunction = fragmentShader;
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

        NSError* error;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert(_pipelineState, @"Failed to create pipeline: %@", error);
        
        _viewMatrix = [MetalMatrix mm_lookAtWithEyeX:0
                                            withEyeY:0
                                            withEyeZ:-10.0
                                         withCenterX:0
                                         withCenterY:0
                                         withCenterZ:0
                                             withUpX:0
                                             withUpY:1.0
                                             withUpZ:0];
        
        _projectionMatrix = [MetalMatrix mm_perspectiveWithFovy:90.0
                                                     withAspect:1.0
                                                       withNear:0.1
                                                        withFar:100.0];
    }
    
    return self;
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size
{
    _viewSize.x = size.width;
    _viewSize.y = size.height;
    
    _projectionMatrix = [MetalMatrix mm_perspectiveWithFovy:90.0
                                                  withWidth:size.width
                                                 withHeight:size.height
                                                   withNear:0.1
                                                    withFar:100.0];
}

- (void)drawInMTKView:(MTKView *)view
{
    // Create a new command buffer for the current render pass.
    id<MTLCommandBuffer> cmdBuffer = [_cmdQueue commandBuffer];
    cmdBuffer.label = @"Render";
    
    // Get a render pass descriptor from the view.
    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor == nil)
    {
        return;
    }
    
    // Create a render command encoder to encode our drawing commands.
    id<MTLRenderCommandEncoder> encoder = [cmdBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    
    // Pipeline needs final viewport dimensions in order to transform to device coordinates.
    [encoder setViewport:(MTLViewport){
            .originX = 0.0,
            .originY = 0.0,
            .width = _viewSize.x,
            .height = _viewSize.y,
            .znear = 0.0,
            .zfar = 1.0}];
    
    // Bind the shaders, drawable pixel format etc.
    [encoder setRenderPipelineState:_pipelineState];
    
    [encoder setVertexBytes:&_viewMatrix
                     length:[MetalMatrix mm_matrixSize]
                    atIndex:VertexDataInputIndexViewMatrix];
    
    [encoder setVertexBytes:&_projectionMatrix
                     length:[MetalMatrix mm_matrixSize]
                    atIndex:VertexDataInputIndexProjectionMatrix];
    
    // Ask data source to render objects into the command buffer.
    [_sceneData renderIntoEncoder:encoder];
    
    [encoder endEncoding];
    
    // All commands are now encoded, the last command is to present (show) the current drawable.
    [cmdBuffer presentDrawable:view.currentDrawable];

    // Push the command buffer to the GPU.
    [cmdBuffer commit];
}

@end
