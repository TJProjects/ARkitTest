//
//  ARLabelSelectView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/30.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
typedef void(^ARLabelSelectViewBlock)(NSString * _Nonnull type);
NS_ASSUME_NONNULL_BEGIN

@interface ARLabelSelectView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *explainLabel1;
@property (nonatomic, strong) UILabel *explainLabel2;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, copy) ARLabelSelectViewBlock selectBlock;

- (void)showLocation;
- (void)showTerminal;
- (void)showRunways;
- (void)hiddenView;


@end

NS_ASSUME_NONNULL_END
