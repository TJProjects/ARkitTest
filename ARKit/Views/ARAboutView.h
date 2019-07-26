//
//  ARAboutView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/6/6.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
typedef void(^ARAboutViewBlock)(NSString * _Nullable type);


NS_ASSUME_NONNULL_BEGIN

@interface ARAboutView : UIView
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) ARAboutViewBlock viewBlock;

@end

NS_ASSUME_NONNULL_END
