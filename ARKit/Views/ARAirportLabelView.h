//
//  ARAirportLabelView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/6/14.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

typedef void(^ARAirportLabelViewBlock)(NSString * _Nonnull type);

NS_ASSUME_NONNULL_BEGIN

@interface ARAirportLabelView : UIView
@property (nonatomic, strong) UIButton *labelButton;
@property (nonatomic, strong) UIImageView *bgPoint;
@property (nonatomic, strong) UIImageView *point;
@property (nonatomic, copy) ARAirportLabelViewBlock buttonBlock;

- (void)showViewWith:(NSString *)title;
- (void)showAnimationWith:(CGFloat)time;


@end

NS_ASSUME_NONNULL_END
