//
//  ARCheckVIew.m
//  CGTN
//
//  Created by YangTengJiao on 2019/6/27.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARCheckVIew.h"

@implementation ARCheckVIew

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews {
    self.backgroundColor = [UIColor blackColor];
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, (KIsiPhoneX?237:143), ScreenTJWidth-42-42, 96)];
    self.topLabel.font = BoldFontTJ(24);
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.numberOfLines = 0;
    self.topLabel.text = kFirstLoadTitle;
    [self addSubview:self.topLabel];
    
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, (KIsiPhoneX?361:261), ScreenTJWidth-42-42, 44)];
    self.centerLabel.font = FontTJ(18);
    self.centerLabel.textColor = RGBTJ(186, 237, 255);
    self.centerLabel.numberOfLines = 0;
    [self addSubview:self.centerLabel];
    
    self.pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pushButton.frame = CGRectMake(50, ScreenTJHeight-(KIsiPhoneX?112:94), ScreenTJWidth-50-50, 60);
    self.pushButton.titleLabel.font = FontTJ(18);
    self.pushButton.titleLabel.textColor = [UIColor whiteColor];
    self.pushButton.titleLabel.numberOfLines = 0;
    self.pushButton.layer.masksToBounds = YES;
    self.pushButton.layer.borderColor = [UIColor colorWithWhite:151.0/255.0 alpha:1.0].CGColor;
    self.pushButton.layer.borderWidth = 1;
    [self.pushButton addTarget:self action:@selector(pushButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pushButton setTitle:KCheckPushButton forState:UIControlStateNormal];
    [self addSubview:self.pushButton];
}

- (void)pushButtonAction {
    if (self.checkBlock) {
        self.checkBlock(nil);
    }
}

- (void)showViewUnARkit {
    self.centerLabel.text = KCheckCenterText1;
}
- (void)showViewUnNewVersion {
    self.centerLabel.text = KCheckCenterText2;
}
- (void)showViewUnCamareOpen {
    self.centerLabel.text = KCheckCenterText3;
}

@end
