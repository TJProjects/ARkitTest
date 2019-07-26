//
//  ARNetErrorView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/6/21.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARNetErrorView.h"

@implementation ARNetErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bgButton.frame = self.bounds;
        [self.bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        
        self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-201/2.0, ScreenTJHeight/2.0-200/2.0, 201, 200)];
        [self.centerImageView setImage:kGetARImage(@"Group")];
        [self addSubview:self.centerImageView];
        
        self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-60/2.0, 70, 60, 17)];
        [self.topImageView setImage:kGetARImage(@"CGTN_LOGO_RGB")];
        [self addSubview:self.topImageView];
        
        self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-269/2.0, ScreenTJHeight/2.0+200/2.0+30, 269, 41)];
        [self.bottomImageView setImage:kGetARImage(@"UNNETTEXT")];
        [self addSubview:self.bottomImageView];
        
    }
    return self;
}
- (void)bgButtonAction {
    if (self.errorBlock) {
        self.errorBlock(@"");
    }
}

- (void)showErrorView {
    self.hidden = NO;
}

@end
