//
//  SceneData.h
//  MetalDemo
//

#ifndef SceneData_h
#define SceneData_h

@import MetalKit;

@interface SceneData : NSObject

- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)renderIntoEncoder:(id<MTLRenderCommandEncoder>)encoder;

@end


#endif /* SceneData_h */
