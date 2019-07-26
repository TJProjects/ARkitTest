//
//  ARScanBottomView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/27.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARScanBottomView.h"

#define kCenterWidth 80
#define kLineWidth 6.0

@implementation ARScanBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.progress = 0.0;
        self.timerIndex = 0;
        self.clipsToBounds = NO;
        [self creatView];
    }
    return self;
}
- (void)creatView {
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    [self addSubview:self.ARButton];
    [self addSubview:self.centerButton];
    [self addSubview:self.infoListButton];
}
-(void)drawRect:(CGRect)rect {
//    if (self.progress == 0) {
//        return;
//    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    CGFloat startA = - M_PI_2; //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2.0 * self.progress; //圆终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(ScreenTJWidth/2.0, kCenterWidth/2.0) radius:kCenterWidth/2.0-3 startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(ctx,kLineWidth); //设置线条宽度
    [RGBTJ(195, 230, 255) setStroke];
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx); //渲染
}
- (void)reloadProgress:(CGFloat )progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
//    NSLog(@"progress %lf",progress);
    self.progress = progress;
    [self setNeedsDisplay];
    });
}


- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenTJWidth/2.0-kCenterWidth/2.0)/2.0-70/2.0, kCenterWidth/2.0-70/2.0, 70, 70)];
        [_leftView setImage:kGetARImage(@"数据入口-按钮-高亮")];
        _leftView.alpha = 0;
    }
    return _leftView;
}

- (UIButton *)ARButton {
    if (!_ARButton) {
        _ARButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ARButton.frame = CGRectMake((ScreenTJWidth/2.0-kCenterWidth/2.0)/2.0-70/2.0, kCenterWidth/2.0-70/2.0, 70, 70);
        [_ARButton setImage:kGetARImage(@"数据入口-按钮") forState:UIControlStateNormal];
        [_ARButton addTarget:self action:@selector(ARButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ARButton;
}

- (UIButton *)centerButton {
    if (!_centerButton) {//228 76
        _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerButton.frame = CGRectMake(ScreenTJWidth/2.0-kCenterWidth/2.0, 0, kCenterWidth, kCenterWidth);
        [_centerButton setImage:kGetARImage(@"拍摄按钮") forState:UIControlStateNormal];
        [_centerButton addTarget:self action:@selector(centerButtonAction) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *pahGestureRecognizer=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerStateChanged:)];
        pahGestureRecognizer.delegate = self; //指定委托
        pahGestureRecognizer.minimumPressDuration = 0.3; //最少按压响应时间
        [_centerButton addGestureRecognizer:pahGestureRecognizer];//指定对象为scrollView
    }
    return _centerButton;
}
- (UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenTJWidth-(ScreenTJWidth/2.0-kCenterWidth/2.0)/2.0-70/2.0, kCenterWidth/2.0-70/2.0, 70, 70)];
        [_rightView setImage:kGetARImage(@"专访视频入口-按钮-高亮")];
        _rightView.alpha = 0;
    }
    return _rightView;
}
- (UIButton *)infoListButton {
    if (!_infoListButton) {
        _infoListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _infoListButton.frame = CGRectMake(ScreenTJWidth-(ScreenTJWidth/2.0-kCenterWidth/2.0)/2.0-70/2.0, kCenterWidth/2.0-70/2.0, 70, 70);
        [_infoListButton setImage:kGetARImage(@"专访视频入口-按钮") forState:UIControlStateNormal];
        [_infoListButton addTarget:self action:@selector(infoListButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoListButton;
}


- (void)ARButtonAction {
    if (self.bottomBlock) {
        self.bottomBlock(@"info");
    }
}
- (void)centerButtonAction {
    if (self.bottomBlock) {
        self.bottomBlock(@"photo");
    }
}
- (void)infoListButtonAction {
    if (self.bottomBlock) {
        self.bottomBlock(@"video");
    }
}
//实现委托方法：判断手势状态 动作开始、移动变化、结束
- (void)longPressGestureRecognizerStateChanged:(UIGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"UIGestureRecognizerStateBegan");
            if ([self checkMicrophone]) {
                [self startTimer];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"UIGestureRecognizerStateEnded");
            if (!self.isCheckingMicrophone) {
                if ([self checkMicrophone]) {
                    [self stopTimer];
                }
            }
            break;
        }
        case UIGestureRecognizerStatePossible: {
            
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        case UIGestureRecognizerStateFailed: {
            
            break;
        }
    }
}
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (void)startTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timerIndex = 0;
        [self.timer setFireDate:[NSDate distantPast]];
        self.ARButton.hidden = YES;
        self.infoListButton.hidden = YES;
        if (self.bottomBlock) {
            self.bottomBlock(@"start");
        }
    });
}
- (void)stopTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timerIndex = 0;
        [self reloadProgress:0.0];
        self.ARButton.hidden = NO;
        self.infoListButton.hidden = NO;
        if (self.bottomBlock) {
            self.bottomBlock(@"over");
        }
    });
}
- (void)timerRunAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timerIndex += 1;
        if (self.timerIndex >= 100) {
            [self stopTimer];
        } else {
            [self reloadProgress:self.timerIndex/100.0];
        }
    });
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

//检测麦克风
- (BOOL)checkMicrophone {
    // 用户是否允许麦克风使用
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    // 不允许弹出提示框
    __weak typeof(self) weakSelf = self;
    if (authorizationStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    } else if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied || authorizationStatus == AVAuthorizationStatusNotDetermined) {
        self.isCheckingMicrophone = YES;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            NSLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
            weakSelf.isCheckingMicrophone = NO;
        }];
        return NO;
    } else {
        return NO;
    }
}
- (void)showLeftAnimationWith:(CGFloat)time {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:time/2.0 animations:^{
        weakSelf.leftView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time/2.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            weakSelf.leftView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (void)showRightAnimationWith:(CGFloat)time {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:time/2.0 animations:^{
        weakSelf.rightView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time/2.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            weakSelf.rightView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

@end
