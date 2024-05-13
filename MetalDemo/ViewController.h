//
//  ViewController.h
//  MetalDemo
//

#import <UIKit/UIKit.h>

@import MetalKit;

@interface ViewController : UIViewController

- (IBAction)handlePanGesture:(UIGestureRecognizer*)sender;
- (IBAction)handlePinchGesture:(UIGestureRecognizer*)sender;
- (IBAction)handleDoubleTapGesture:(UIGestureRecognizer*)sender;

@end

