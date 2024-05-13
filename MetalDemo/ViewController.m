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
    MTKView*    _view;
    Renderer*   _renderer;
    
    float       _cameraAngle;
    CGPoint     _startingTouchPos;
    float       _startingPinchScale;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _view = (MTKView*)self.view;
    _view.device = MTLCreateSystemDefaultDevice();
    NSAssert(_view.device, @"Metal is not supported");

    _renderer = [[Renderer alloc] initWithMetalKitView:_view];
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];
    _cameraAngle = 0.0;
    
    _view.delegate = _renderer;
}

- (IBAction)handlePanGesture:(UIGestureRecognizer*)sender
{
    UIPanGestureRecognizer* gestureRecoginser = (UIPanGestureRecognizer*)sender;
    CGPoint currentTouchPos = [gestureRecoginser translationInView:_view];

    if ([gestureRecoginser state] == UIGestureRecognizerStateBegan)
    {
        _startingTouchPos = currentTouchPos;
        return;
    }
    
    _cameraAngle += (currentTouchPos.x < _startingTouchPos.x) ? -0.1 : 0.1;
    
    [_renderer rotateViewToAngle:_cameraAngle];
}

- (IBAction)handlePinchGesture:(UIGestureRecognizer*)sender
{
    UIPinchGestureRecognizer* gestureRecogniser = (UIPinchGestureRecognizer*)sender;
    float currentScale = [gestureRecogniser scale];
    
    if ([gestureRecogniser state] == UIGestureRecognizerStateBegan)
    {
        _startingPinchScale = currentScale;
        return;
    }
    
    float cameraZ = [_renderer cameraZ];
    if (currentScale < _startingPinchScale)
    {
        [_renderer setCameraZ:cameraZ - 0.5];
    }
    else
    {
        [_renderer setCameraZ:cameraZ + 0.5];
    }
}

@end
