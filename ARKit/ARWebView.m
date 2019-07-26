//
//  ARWebView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/30.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARWebView.h"

@implementation ARWebView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatView];
    }
    return self;
}
- (void)creatView {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(15, (KIsiPhoneX?35:22.5), 35, 35)];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:kGetARImage(@"返回") forState:UIControlStateNormal];
    [self addSubview:back];
}
- (void)backAction {
    [self removeFromSuperview];
    if (self.webBlock) {
        self.webBlock(@"back");
    }
}

@end
