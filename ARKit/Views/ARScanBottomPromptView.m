//
//  ARScanBottomPromptView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/29.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARScanBottomPromptView.h"

@implementation ARScanBottomPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView {
    self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bgButton.frame = self.bounds;
    self.bgButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgButton];
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, (KIsiPhoneX?163:101), ScreenTJWidth-32-32, 88)];
    self.topLabel.font = FontTJ(18);
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.numberOfLines = 0;
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.text = KBottomPromptTop;
    [self addSubview:self.topLabel];
    
//    self.topOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, (KIsiPhoneX?154:100), ScreenTJWidth-60-60, 44)];
//    self.topOneLabel.font = FontTJ(18);
//    self.topOneLabel.textColor = [UIColor whiteColor];
//    self.topOneLabel.numberOfLines = 0;
//    self.topOneLabel.textAlignment = NSTextAlignmentCenter;
//    self.topOneLabel.text = KBottomPromptTopOne;
//    [self addSubview:self.topOneLabel];
//
//    self.topTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, (KIsiPhoneX?210:156), ScreenTJWidth-60-60, 44)];
//    self.topTwoLabel.font = FontTJ(18);
//    self.topTwoLabel.textColor = [UIColor whiteColor];
//    self.topTwoLabel.text = KBottomPromptTopTwo;
//    self.topTwoLabel.numberOfLines = 0;
//    self.topTwoLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.topTwoLabel];
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, ScreenTJHeight-(KIsiPhoneX?172:172)-44, 118, 44)];
    self.leftLabel.font = FontTJ(18);
    self.leftLabel.textColor = [UIColor whiteColor];
    self.leftLabel.text = KBottomPromptleft;
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.numberOfLines = 0;
    [self addSubview:self.leftLabel];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenTJWidth-23-140, ScreenTJHeight-(KIsiPhoneX?172:172)-44, 140, 44)];
    self.rightLabel.font = FontTJ(18);
    self.rightLabel.textColor = [UIColor whiteColor];
    self.rightLabel.text = KBottomPromptRight;
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.rightLabel];
    //42 132   14 44  29+15-7
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, ScreenTJHeight-(KIsiPhoneX?123:123)-44, 14, 44)];
    [self.leftImageView setImage:kGetARImage(@"箭头")];
    [self addSubview:self.leftImageView];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenTJWidth-85, ScreenTJHeight-(KIsiPhoneX?123:123)-44, 14, 44)];
    [self.rightImageView setImage:kGetARImage(@"箭头")];
    [self addSubview:self.rightImageView];
    
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, ScreenTJHeight-(KIsiPhoneX?240:240)-50, ScreenTJWidth-40-40, 50)];
    self.centerLabel.font = FontTJ(18);
    self.centerLabel.textColor = [UIColor whiteColor];
    self.centerLabel.text = KBottomPromptCenter;
    self.centerLabel.numberOfLines = 0;
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.centerLabel];
    
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-14/2.0, ScreenTJHeight-(KIsiPhoneX?128:128)-95, 14, 95)];
    [self.centerImageView setImage:kGetARImage(@"箭头")];
    [self addSubview:self.centerImageView];
    
}
- (void)bgButtonAction {
    if (self.centerLabel.hidden == NO) {
        self.leftLabel.hidden = YES;
        self.leftImageView.hidden = YES;
        self.centerImageView.hidden = YES;
        self.centerLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        self.rightImageView.hidden = YES;
        self.topLabel.text = KBottomPromptTop2;
    } else {
        [self removeFromSuperview];
    }
}

@end
