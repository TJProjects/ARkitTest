//
//  ARFirstLoadView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/21.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
typedef void(^ARFirstLoadViewBlock)(NSString * _Nullable type);

NS_ASSUME_NONNULL_BEGIN

@interface ARFirstLoadView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *explanTextView;
@property (nonatomic, strong) UIImageView *progressBgView;
@property (nonatomic, strong) UIImageView *progressTopView;
@property (nonatomic, strong) UIImageView *slipView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) ARFirstLoadViewBlock loadBlock;

- (void)showProgressViewWith:(float)progress;
- (void)showLoadOverAnimation;
- (void)removeSelf;

@end

NS_ASSUME_NONNULL_END
