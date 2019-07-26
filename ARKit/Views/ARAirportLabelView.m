//
//  ARAirportLabelView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/6/14.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARAirportLabelView.h"

@implementation ARAirportLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView {
    self.labelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.labelButton.frame = CGRectMake(0, 0, 84, 24);
    self.labelButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.labelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.labelButton.layer.borderWidth = 1.5;
    self.labelButton.titleLabel.font = FontTJ(12);
    [self.labelButton addTarget:self action:@selector(labelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.labelButton];
    
    self.bgPoint = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.0-33/2.0, 24, 33, 33)];
    [self.bgPoint setImage:kGetARImage(@"高亮光晕")];
    self.bgPoint.alpha = 0;
    [self addSubview:self.bgPoint];

    self.point = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    self.point.backgroundColor = [UIColor whiteColor];
    self.point.center = self.bgPoint.center;
    self.point.layer.masksToBounds = YES;
    self.point.layer.cornerRadius = 13/2.0;
    [self addSubview:self.point];
}
- (void)labelButtonAction {
    if (self.buttonBlock) {
        self.buttonBlock(nil);
    }
}

- (void)showViewWith:(NSString *)title {
    [self.labelButton setTitle:title forState:UIControlStateNormal];
}

- (void)showAnimationWith:(CGFloat)time {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:time/2.0 animations:^{
        weakSelf.bgPoint.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time/2.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            weakSelf.bgPoint.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (void)showAnimation {
    [UIView animateWithDuration:1.0 animations:^{
        self.bgPoint.alpha = 0.3;
        self.point.backgroundColor = RGBTJ(158, 196, 255);
    } completion:^(BOOL finished) {
        self.bgPoint.alpha = 0;
        self.point.backgroundColor = [UIColor whiteColor];
    }];
}


@end
