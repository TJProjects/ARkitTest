//
//  ARToastView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/6/17.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARToastView : UIView
@property (nonatomic, strong) UILabel *centerLabel;

- (void)showToastWith:(NSString *)toast;

@end

NS_ASSUME_NONNULL_END
