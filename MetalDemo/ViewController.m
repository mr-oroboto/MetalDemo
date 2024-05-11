//
//  ViewController.m
//  MetalDemo
//

#import "ViewController.h"
#import "Renderer.h"

@interface ViewController ()

@end

@implementation ViewController
{
    MTKView* _view;
    Renderer* _renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _view = (MTKView*)self.view;
    _view.device = MTLCreateSystemDefaultDevice();
    
    _renderer = [[Renderer alloc] initWithMetalKitView:_view];
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];
    
    NSAssert(_view.device, @"Metal is not supported");
    
    _view.delegate = _renderer;
}


@end
