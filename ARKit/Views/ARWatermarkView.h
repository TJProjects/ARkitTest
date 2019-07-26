//
//  ARWatermarkView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/28.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
#import "TJAVplayerView.h"
#import "ARWatermarkTableViewCell.h"
#import "ARWaterMark.h"

typedef void(^ARWatermarkViewBlock)(NSString *type,UIImage * _Nullable image,NSString * _Nullable path);

NS_ASSUME_NONNULL_BEGIN

@interface ARWatermarkView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) TJAVplayerView *playerView;
@property (nonatomic, strong) UIButton *promptButton;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UIButton *fromButton;
@property (nonatomic, strong) UIImageView *fromImageView;
@property (nonatomic, strong) UITableView *fromTableView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UILabel *toastLabel;

@property (nonatomic, copy) ARWatermarkViewBlock watermarkBlock;
@property (nonatomic, strong) UIImageView *maskUpView;





- (void)showWithImage:(UIImage *)image;
- (void)showWithVideo:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
