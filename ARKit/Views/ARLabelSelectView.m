//
//  ARLabelSelectView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/30.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARLabelSelectView.h"

@implementation ARLabelSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatView];
        self.hidden = YES;
    }
    return self;
}
- (void)creatView {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, ScreenTJWidth, 29)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = BoldFontTJ(24);
    self.titleLabel.text = kTerminal;
    [self addSubview:self.titleLabel];
    
    self.explainLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 38, ScreenTJWidth, 22)];
    self.explainLabel1.textColor = [UIColor whiteColor];
    self.explainLabel1.font = FontTJ(18);
    self.explainLabel1.text = kTerminal1;
    [self addSubview:self.explainLabel1];
    
    self.explainLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, ScreenTJWidth, 22)];
    self.explainLabel2.textColor = [UIColor colorWithRed:186.0f/255.0f green:237.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    self.explainLabel2.font = FontTJ(18);
    self.explainLabel2.text = kTerminal2;
    [self addSubview:self.explainLabel2];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(30, 87, 58, 36);
    self.closeButton.titleLabel.font = FontTJ(16);
    [self.closeButton setTitle:@"close" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.layer.borderWidth = 1.0;
    self.closeButton.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    [self addSubview:self.closeButton];
}
- (void)closeButtonAction {
    if (self.selectBlock) {
        self.selectBlock(nil);
    }
    [self hiddenView];
}

- (void)showLocation {
    self.hidden = NO;
    self.explainLabel1.hidden = YES;
    self.explainLabel2.hidden = YES;
    self.titleLabel.text = kLocation;
    self.closeButton.frame = CGRectMake(30, 35, 58, 36);
}
- (void)showTerminal {
    self.hidden = NO;
    self.explainLabel1.hidden = NO;
    self.explainLabel2.hidden = NO;
    self.titleLabel.text = kTerminal;
    self.explainLabel1.text = kTerminal1;
    self.explainLabel2.text = kTerminal2;
    self.closeButton.frame = CGRectMake(30, 87, 58, 36);
}
- (void)showRunways {
    self.hidden = NO;
    self.explainLabel1.hidden = YES;
    self.explainLabel2.hidden = YES;
    self.titleLabel.text = kRunways;
    self.closeButton.frame = CGRectMake(30, 35, 58, 36);
}

- (void)hiddenView {
    self.hidden = YES;
}
@end
