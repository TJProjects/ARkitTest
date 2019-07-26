//
//  ARScanPromptView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/23.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARScanPromptView : UIView
@property (nonatomic, strong) UILabel *centerLabel;

- (void)showScanPlane;
- (void)showTapModel;
- (void)showResetTapModel;
- (void)hiddenView;

@end

NS_ASSUME_NONNULL_END
