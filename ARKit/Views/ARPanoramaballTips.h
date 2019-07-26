//
//  ARPanoramaballTips.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/30.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARPanoramaballTips : UIView
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIImageView *imageViewTop;
@property (nonatomic, strong) UIImageView *imageViewleft;
@property (nonatomic, strong) UIImageView *imageViewRight;
@property (nonatomic, strong) UIImageView *imageViewBottom;

@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *promptLabel;

- (void)showScrollTips;
- (void)showMoveTips;
- (void)showPromptTips;
- (void)hiddenView;


@end

NS_ASSUME_NONNULL_END
