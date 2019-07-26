//
//  ARNetErrorView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/6/21.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
typedef void(^ARNetErrorViewBlock)(NSString * _Nonnull type);

NS_ASSUME_NONNULL_BEGIN

@interface ARNetErrorView : UIView
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, copy) ARNetErrorViewBlock errorBlock;

- (void)showErrorView;



@end

NS_ASSUME_NONNULL_END
