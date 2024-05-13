//
//  Renderer.h
//  MetalDemo
//

#ifndef Renderer_h
#define Renderer_h

@import MetalKit;

@interface Renderer : NSObject<MTKViewDelegate>

@property (nonatomic) float cameraZ;

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView*)mtkView;
- (void)rotateViewToAngle:(float)radians;

@end

#endif /* Renderer_h */
