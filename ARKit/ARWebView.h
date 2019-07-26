//
//  ARWebView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/30.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

typedef void(^ARWebViewBlock)(NSString * _Nullable type);

NS_ASSUME_NONNULL_BEGIN

@interface ARWebView : UIView

@property (nonatomic, copy) ARWebViewBlock webBlock;

@end

NS_ASSUME_NONNULL_END
