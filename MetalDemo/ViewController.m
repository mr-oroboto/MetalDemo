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
    CGPoint     _previousTouchPos;
    float       _startingPinchScale;
    
    NSTimer*    _rotateTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _view = (MTKView*)self.view;
    _view.device = MTLCreateSystemDefaultDevice();
    NSAssert(_view.device, @"Metal is not supported");

    _renderer = [[Renderer alloc] initWithMetalKitView:_view];
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _cameraAngle = 0.0;
    _rotateTimer = nil;
    
    _view.delegate = _renderer;
}

- (IBAction)handlePanGesture:(UIGestureRecognizer*)sender
{
    UIPanGestureRecognizer* gestureRecoginser = (UIPanGestureRecognizer*)sender;
    CGPoint currentTouchPos = [gestureRecoginser translationInView:_view];

    if ([gestureRecoginser state] == UIGestureRecognizerStateBegan)
    {
        _previousTouchPos = currentTouchPos;
        return;
    }

    if ([gestureRecoginser state] == UIGestureRecognizerStateChanged && !_rotateTimer)
    {
        _cameraAngle += (currentTouchPos.x < _previousTouchPos.x) ? -0.1 : 0.1;
        _previousTouchPos = currentTouchPos;
        [_renderer rotateViewToAngle:_cameraAngle];
    }
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

- (IBAction)handleDoubleTapGesture:(UIGestureRecognizer *)sender
{
    if (_rotateTimer)
    {
        [_rotateTimer invalidate];
        _rotateTimer = nil;
    }
    else
    {
        _rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                        target:self
                                                      selector:@selector(rotateCamera)
                                                      userInfo:nil
                                                       repeats:YES];
    }
}

- (void)rotateCamera
{
    _cameraAngle += 0.1;
    [_renderer rotateViewToAngle:_cameraAngle];
}

@end
