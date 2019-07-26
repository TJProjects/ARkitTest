//
//  ARScanPromptView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/23.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARScanPromptView.h"

@implementation ARScanPromptView

- (instancetype)init {
    if (self = [super init]) {
        self.hidden = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.centerLabel = [[UILabel alloc] init];
        self.centerLabel.textColor = [UIColor whiteColor];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        self.centerLabel.font = FontTJ(18);
        self.centerLabel.numberOfLines = 0;
        [self addSubview:self.centerLabel];
        self.frame = CGRectMake(20, (KIsiPhoneX?125:88), ScreenTJWidth-20-20, 111);
        self.centerLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
    return self;
}
- (void)showScanPlane {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.frame = CGRectMake(20, (KIsiPhoneX?125:88), ScreenTJWidth-20-20, 111);
        self.centerLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.centerLabel.text = kScanPlane;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.hidden == NO) {
            [self showTapModel];
        }
    });
}
- (void)showTapModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.frame = CGRectMake(20, (KIsiPhoneX?125:92), ScreenTJWidth-20-20, 78);
        self.centerLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.centerLabel.text = kTapModel;
    });
}
- (void)showResetTapModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.frame = CGRectMake(20, (KIsiPhoneX?125:256), ScreenTJWidth-20-20, 78);
        self.centerLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.centerLabel.text = kResetTapModel;
    });
}
- (void)hiddenView {
    self.hidden = YES;
}

@end
