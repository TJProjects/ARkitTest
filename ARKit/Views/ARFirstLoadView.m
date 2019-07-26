//
//  ARFirstLoadView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/21.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARFirstLoadView.h"

@implementation ARFirstLoadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.explanTextView];
    [self addSubview:self.progressLabel];
    [self addSubview:self.progressBgView];
    [self.progressBgView addSubview:self.progressTopView];
    [self addSubview:self.slipView];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, (KIsiPhoneX?237:143), ScreenTJWidth-42-42, 96)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = BoldFontTJ(24);
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = kFirstLoadTitle;
    }
    return _titleLabel;
}
- (UITextView *)explanTextView {
    if (!_explanTextView) {
        _explanTextView = [[UITextView alloc] initWithFrame:CGRectMake(42, (KIsiPhoneX?355:261), ScreenTJWidth-42-42, 100)];
        _explanTextView.backgroundColor = [UIColor blackColor];
        _explanTextView.textColor = RGBTJ(186, 237, 255);
        _explanTextView.font = FontTJ(18);
        _explanTextView.text = kFirstLoadExplain;
        _explanTextView.userInteractionEnabled = NO;
    }
    return _explanTextView;
}
- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-50/2.0, ScreenTJHeight-(KIsiPhoneX?54:43)-8-15, 50, 15)];
        _progressLabel.textColor = RGBTJ(232, 232, 232);
        _progressLabel.font = FontTJ(12);
        _progressLabel.alpha = 0.4;
    }
    return _progressLabel;
}
- (UIImageView *)progressBgView {
    if (!_progressBgView) {
        _progressBgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, ScreenTJHeight-(KIsiPhoneX?54:43), ScreenTJWidth-80, 4)];
        _progressBgView.backgroundColor = RGBTJ(124, 125, 127);;
        _progressBgView.clipsToBounds = YES;
    }
    return _progressBgView;
}
- (UIImageView *)progressTopView {
    if (!_progressTopView) {
        _progressTopView = [[UIImageView alloc] initWithFrame:CGRectMake(-(ScreenTJWidth-80), 0, ScreenTJWidth-80, 4)];
        [_progressTopView setImage:kGetARImage(@"进度条-渐变")];
    }
    return _progressTopView;
}
- (UIImageView *)slipView {
    if (!_slipView) {
        _slipView = [[UIImageView alloc] initWithImage:kGetARImage(@"小飞机")];
        _slipView.center = CGPointMake(40, self.progressBgView.center.y);
    }
    return _slipView;
}

- (void)showProgressViewWith:(float)progress {
    if (progress >= 1) {
        self.progressTopView.frame = CGRectMake(0, 0, ScreenTJWidth-80, 4);
        self.slipView.center = CGPointMake(40+(ScreenTJWidth-80)*progress, self.progressBgView.center.y);
        self.progressLabel.text = [NSString stringWithFormat:@"100%@",@"%"];
    } else {
        self.progressTopView.frame = CGRectMake(-(ScreenTJWidth-80)+(ScreenTJWidth-80)*progress, 0, ScreenTJWidth-80, 4);
        self.slipView.center = CGPointMake(40+(ScreenTJWidth-80)*progress, self.progressBgView.center.y);
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f%@",progress*100,@"%"];
    }
}
- (void)removeSelf {
    [_timer invalidate];
    _timer = nil;
    [self removeFromSuperview];
}
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (void)timerRunAction {
    static float num = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (num >= 1) {
            if (self.loadBlock) {
                self.loadBlock(@"");
            }
        }
        [self showProgressViewWith:num];
        num += 0.1;
    });
}
- (void)showLoadOverAnimation {
    [self.timer setFireDate:[NSDate distantPast]];
}

@end
