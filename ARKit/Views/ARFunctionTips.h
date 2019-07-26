//
//  ARFunctionTips.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/23.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

typedef void(^ARFunctionTipsBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARFunctionTips : UIView
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *enbutton;
@property (nonatomic, strong) UIButton *zhButton;
@property (nonatomic, strong) UIView *enLine;
@property (nonatomic, strong) UIView *zhLine;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, copy) ARFunctionTipsBlock tipsBlock;

@end

NS_ASSUME_NONNULL_END
