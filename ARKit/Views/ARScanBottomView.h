//
//  ARScanBottomView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/27.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^ARScanBottomViewBlock)(NSString * _Nonnull type);

NS_ASSUME_NONNULL_BEGIN

@interface ARScanBottomView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *ARButton;
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) UIButton *infoListButton;
@property (nonatomic, strong) UIImageView *rightView;



@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, copy) ARScanBottomViewBlock bottomBlock;

@property (nonatomic, assign) BOOL isCheckingMicrophone;

- (void)showLeftAnimationWith:(CGFloat)time;
- (void)showRightAnimationWith:(CGFloat)time;


@end

NS_ASSUME_NONNULL_END
