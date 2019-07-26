//
//  ARPanoramaballTips.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/30.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARPanoramaballTips.h"

@implementation ARPanoramaballTips

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatView];
        self.hidden = YES;
    }
    return self;
}
- (void)creatView {
    self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bgButton.frame = self.bounds;
    [self.bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgButton];
    
    
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    self.centerLabel.center = self.center;
    self.centerLabel.text = kPanoramaballcenter;
    self.centerLabel.font = FontTJ(18);
    self.centerLabel.numberOfLines = 0;
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.centerLabel];
    
    self.imageViewTop = [[UIImageView alloc] initWithImage:kGetARImage(@"箭头")];
    self.imageViewTop.transform = CGAffineTransformMakeRotation(M_PI);
    self.imageViewTop.center = CGPointMake(self.center.x, self.center.y-130);
    [self addSubview:self.imageViewTop];
    
    self.imageViewBottom = [[UIImageView alloc] initWithImage:kGetARImage(@"箭头")];
    self.imageViewBottom.center = CGPointMake(self.center.x, self.center.y+130);
    [self addSubview:self.imageViewBottom];
    
    self.imageViewleft = [[UIImageView alloc] initWithImage:kGetARImage(@"箭头")];
    self.imageViewleft.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.imageViewleft.center = CGPointMake(self.center.x-130, self.center.y);
    [self addSubview:self.imageViewleft];
    
    self.imageViewRight = [[UIImageView alloc] initWithImage:kGetARImage(@"箭头")];
    self.imageViewRight.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.imageViewRight.center = CGPointMake(self.center.x+130, self.center.y);
    [self addSubview:self.imageViewRight];
    
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenTJHeight-(KIsiPhoneX?75:50), ScreenTJWidth, 22)];
    self.bottomLabel.text = kPanoramaballbottom;
    self.bottomLabel.font = FontTJ(18);
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.bottomLabel];
    //250 198
    
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, (KIsiPhoneX?250:198), ScreenTJWidth-37-37, 80)];
    self.promptLabel.text = kPanoramaballprompt;
    self.promptLabel.font = FontTJ(18);
    self.promptLabel.numberOfLines = 0;
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.layer.borderWidth = 1.0;
    self.promptLabel.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    self.promptLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self addSubview:self.promptLabel];
    
}
- (void)bgButtonAction {
    [self hiddenView];
}

- (void)showScrollTips {
    self.hidden = NO;
    self.bgButton.hidden = NO;
    self.centerLabel.hidden = NO;
    self.imageViewTop.hidden = NO;
    self.imageViewRight.hidden = NO;
    self.imageViewleft.hidden = NO;
    self.imageViewBottom.hidden = NO;
    self.bottomLabel.hidden = YES;
    self.promptLabel.hidden = YES;
}
- (void)showMoveTips {
    self.hidden = NO;
    self.bgButton.hidden = YES;
    self.centerLabel.hidden = YES;
    self.imageViewTop.hidden = YES;
    self.imageViewRight.hidden = YES;
    self.imageViewleft.hidden = YES;
    self.imageViewBottom.hidden = YES;
    self.bottomLabel.hidden = NO;
    self.promptLabel.hidden = YES;
}
- (void)showPromptTips {
    self.hidden = NO;
    self.bgButton.hidden = YES;
    self.centerLabel.hidden = YES;
    self.imageViewTop.hidden = YES;
    self.imageViewRight.hidden = YES;
    self.imageViewleft.hidden = YES;
    self.imageViewBottom.hidden = YES;
    self.bottomLabel.hidden = YES;
    self.promptLabel.hidden = NO;
}
- (void)hiddenView {
    self.hidden = YES;
}

@end
