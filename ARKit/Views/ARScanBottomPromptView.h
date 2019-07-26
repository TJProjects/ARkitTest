//
//  ARScanBottomPromptView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/29.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARScanBottomPromptView : UIView
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIImageView *centerImageView;


@end

NS_ASSUME_NONNULL_END
