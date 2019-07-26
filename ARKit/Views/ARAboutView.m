//
//  ARAboutView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/6/6.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARAboutView.h"

@implementation ARAboutView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(15, (KIsiPhoneX?35:22.5), 35, 35);
    [self.backButton setImage:kGetARImage(@"返回") forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(75, 90, ScreenTJWidth-75-75, ScreenTJHeight-90-90)];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.font = FontTJ(12);
    self.textView.text = @"Andrea Samuels and Gabby; Carrie Brown, Grant Smith, and Sam; Lauren Moraski, Craig Hettich, and Sundance; Lucas Jackson, Mr Harrison, and Eleanor; Maryanne Murray and Edie; Pamela Holzapfel and Buzz; Ryan McNeill and Winston; Brynn White, American Kennel Club archivist\n\nSOURCES\nAmerican Kennel Club; Westminster Kennel Club Dog Show; American Pet Products Association; French Bulldog Club of America; Basset Hound Club of America; American Boxer Club; Papillon Club of America; American Shetland Sheepdog Association; Canadian Kennel Club; Australian National Kennel Council; The Kennel Club; Nielsen\nAdditional work by Christine Chan, Matthew Weber, Wen Foo and Adam Wiesen\nJudging tactics photos by Keith Bedford, Shannon Stapleton and Eduardo Munoz\nEditing by Sandra Maler and Elizabeth Culliford";
    self.textView.userInteractionEnabled = NO;
    [self addSubview:self.textView];
}

- (void)backAction {
    if (self.viewBlock) {
        self.viewBlock(@"back");
    }
    [self removeFromSuperview];
}


@end
