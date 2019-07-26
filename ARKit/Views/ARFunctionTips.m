//
//  ARFunctionTips.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/23.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARFunctionTips.h"

@implementation ARFunctionTips

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatView];
    }
    return self;
}
- (void)creatView {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self addSubview:self.topImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.enbutton];
    [self addSubview:self.zhButton];
    [self addSubview:self.enLine];
    [self addSubview:self.zhLine];
    self.zhLine.hidden = YES;
    [self addSubview:self.bottomButton];
    [self addSubview:self.bottomLabel];
    
    if (KIsEnglishLaunge) {
        [self enbuttonAction];
    } else {
        [self zhbuttonAction];
    }
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:kGetARImage(@"ar")];
        _topImageView.frame = CGRectMake(ScreenTJWidth/2.0-33/2.0, (KIsiPhoneX?76:53), 33, 38);
    }
    return _topImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, self.topImageView.frame.origin.y+self.topImageView.frame.size.height+10, ScreenTJWidth-90-90, 40)];
        _titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        _titleLabel.font = BoldFontTJ(12);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = kTipsTitle;
    }
    return _titleLabel;
}
- (UIButton *)enbutton {
    if (!_enbutton) {
        _enbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enbutton.frame = CGRectMake(ScreenTJWidth/2.0-25, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, 25, 18);
        [_enbutton setTitleColor:RGBTJ(186, 237, 255) forState:UIControlStateNormal];
        _enbutton.titleLabel.font = BoldFontTJ(12);
        [_enbutton setTitle:@"EN" forState:UIControlStateNormal];
        [_enbutton addTarget:self action:@selector(enbuttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enbutton;
}
- (UIButton *)zhButton {
    if (!_zhButton) {
        _zhButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _zhButton.frame = CGRectMake(ScreenTJWidth/2.0, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, 25, 18);
        [_zhButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateNormal];
        _zhButton.titleLabel.font = BoldFontTJ(12);
        [_zhButton setTitle:@"中文" forState:UIControlStateNormal];
        [_zhButton addTarget:self action:@selector(zhbuttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zhButton;
}
- (UIView *)enLine {
    if (!_enLine) {
        _enLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-22.5, self.enbutton.frame.origin.y+20, 20, 2)];
        _enLine.backgroundColor = RGBTJ(186, 237, 255);
    }
    return _enLine;
}
- (UIView *)zhLine {
    if (!_zhLine) {
        _zhLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0+2.5, self.enbutton.frame.origin.y+20, 20, 2)];
        _zhLine.backgroundColor = RGBTJ(186, 237, 255);
    }
    return _zhLine;
}
- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(21, self.enbutton.frame.origin.y+25+(KIsiPhoneX?47:14), ScreenTJWidth-21-21, ScreenTJHeight-(KIsiPhoneX?112:78)-self.enbutton.frame.origin.y-25-(KIsiPhoneX?47:14));
        _bottomButton.layer.borderWidth = 2.0;
        _bottomButton.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
        [_bottomButton addTarget:self action:@selector(bottombuttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, ScreenTJHeight-(KIsiPhoneX?134:83)-50, ScreenTJWidth-80-80, 50)];
        _bottomLabel.textColor = RGBTJ(250, 249, 249);
        _bottomLabel.font = FontTJ(18);
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.text = kTipsBottom;
    }
    return _bottomLabel;
}


- (void)enbuttonAction {
    KSetIsEnglishLaunge(YES);
    [self.enbutton setTitleColor:RGBTJ(186, 237, 255) forState:UIControlStateNormal];
    [self.zhButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateNormal];
    self.enLine.hidden = NO;
    self.zhLine.hidden = YES;
    self.titleLabel.text = kTipsTitle;
    self.bottomLabel.text = kTipsBottom;
}
- (void)zhbuttonAction {
    KSetIsEnglishLaunge(NO);
    [self.enbutton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateNormal];
    [self.zhButton setTitleColor:RGBTJ(186, 237, 255) forState:UIControlStateNormal];
    self.enLine.hidden = YES;
    self.zhLine.hidden = NO;
    self.titleLabel.text = kTipsTitle;
    self.bottomLabel.text = kTipsBottom;
}
- (void)bottombuttonAction {
    if (self.tipsBlock) {
        self.tipsBlock(nil);
        [self removeFromSuperview];
    }
}

@end
