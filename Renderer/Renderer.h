//
//  Renderer.h
//  MetalDemo
//

#ifndef Renderer_h
#define Renderer_h

@import MetalKit;

@interface Renderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView*)mtkView;

@end

#endif /* Renderer_h */
