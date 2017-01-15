//
//  DialogTest.m
//  对话框测试
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import "DialogTest.h"
static UIWindow * window = nil;
@interface DialogViewController : UIViewController
{
    UIView * _myView;
    BOOL _model;
}
@property (assign,readwrite,nonatomic)UIView * myView;
@property (assign,readwrite,nonatomic)BOOL model;
+ (DialogViewController *)defaultDialogViewController;
@end

@implementation DialogViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_model) {
        return;
    }
    UITouch * touch = [touches anyObject];
    CGPoint  point=[touch locationInView:self.view];
    if (!CGRectContainsPoint(_myView.frame, point)) {
        closeDialog(_myView, YES, CloseDiaolgAnimationCenter, ^(BOOL finish) {
            NSLog(@"关闭");
        });
    }
    
}

+ (DialogViewController *)defaultDialogViewController
{
    static DialogViewController * dia = nil;
    if (!dia)
    {
        dia = [[DialogViewController alloc]init];
    }
    return dia;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mainScreenHight = [UIScreen mainScreen].bounds.size.height;
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight||toInterfaceOrientation == UIDeviceOrientationLandscapeLeft)
    {
        _myView.center = CGPointMake(mainScreenHight/2.0, mainScreenWidth/2.0);
    }
    else
    {
        _myView.center = CGPointMake(mainScreenWidth/2.0, mainScreenHight/2.0);
    }
}

- (void)setMyView:(UIView *)myView
{
        [myView retain];
        _myView = myView;

    CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mainScreenHight = [UIScreen mainScreen].bounds.size.height;
    UIDeviceOrientation  Orientation = [UIDevice currentDevice].orientation;
    
    if (Orientation == UIDeviceOrientationLandscapeLeft||Orientation == UIDeviceOrientationLandscapeRight)
    {
        _myView.center = CGPointMake(mainScreenHight/2.0, mainScreenWidth/2.0);
    }
    else
    {
        _myView.center = CGPointMake(mainScreenWidth/2.0, mainScreenHight/2.0);
    }
    
    [self.view addSubview:_myView];
    [myView release];
}
@end
DialogViewController * dia;

void showDialog(UIView * view,BOOL model,ShowDiaolgAnimationStyle type,complete result)
{
    if (window == nil)
    {
        window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        window.windowLevel = UIWindowLevelAlert;
        [window makeKeyAndVisible];
    }
    dia = [[DialogViewController alloc]init];
    window.rootViewController = dia;
    if (type == ShowDiaolgAnimationNone)
    {
        dia.myView = view;
        result(YES);
    }
    else if (type == ShowDiaolgAnimationTop)
    {
        view.layer.transform = CATransform3DMakeTranslation(0, -165, 0);
        dia.myView = view;
    }
    else if (type == ShowDiaolgAnimationBotton)
    {
        view.layer.transform = CATransform3DMakeTranslation(0, 165, 0);
        dia.myView = view;
    }
    else if (type == ShowDiaolgAnimationLeft)
    {
        view.layer.transform = CATransform3DMakeTranslation(-260, 0, 0);
        dia.myView = view;
    }
    else if (type == ShowDiaolgAnimationRight)
    {
        view.layer.transform = CATransform3DMakeTranslation(260, 0, 0);
        dia.myView = view;
    }
    else if (type == ShowDiaolgAnimationCenter)
    {
        view.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        dia.myView = view;
    }
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        view.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        if (result!=nil) {
            result(YES);
        }
    }];
}
void closeDialog(UIView * view,BOOL model,CloseDiaolgAnimationStyle type,complete result)
{
    if (!window)
    {
        return;
    }
    
    if (type == CloseDiaolgAnimationNone)
    {
        [window release];
        window = nil;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (type == CloseDiaolgAnimationBotton)
        {
            view.layer.transform = CATransform3DMakeTranslation(0, 165, 0);
        }
        else if (type == CloseDiaolgAnimationCenter)
        {
            view.layer.transform = CATransform3DMakeScale(0, 0, 1);
        }
        else if (type == CloseDiaolgAnimationLeft)
        {
            view.layer.transform = CATransform3DMakeTranslation(260, 0, 0);
        }
        else if (type == CloseDiaolgAnimationRight)
        {
            view.layer.transform = CATransform3DMakeTranslation(-260, 0, 0);
        }
        else if (type == CloseDiaolgAnimationTop)
        {
            view.layer.transform = CATransform3DMakeTranslation(0, -165, 0);
        }
    } completion:^(BOOL finished) {
        result(YES);
        [window release];
        window = nil;
        [dia release];
    }];
}
