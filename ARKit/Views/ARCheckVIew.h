//
//  ARCheckVIew.h
//  CGTN
//
//  Created by YangTengJiao on 2019/6/27.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
typedef void(^ARCheckVIewBlock)(NSString * _Nullable type);

NS_ASSUME_NONNULL_BEGIN

@interface ARCheckVIew : UIView
@property (nonatomic, copy) ARCheckVIewBlock checkBlock;
@property (nonatomic, strong) UIButton *pushButton;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *centerLabel;

- (void)showViewUnARkit;
- (void)showViewUnNewVersion;
- (void)showViewUnCamareOpen;


@end

NS_ASSUME_NONNULL_END
