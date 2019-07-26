//
//  ARkitViewController.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/16.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
////分享回调
typedef void(^ARkitViewControllerShareBlock)(NSString * _Nullable type,UIImage * _Nullable image,NSString * _Nullable path);
typedef NSString *_Nullable(^ARkitViewControllerGetLaunge)(void);
typedef BOOL(^ARkitViewControllerIsNewVersion)(void);
typedef void(^ARkitViewControllerPushWebView)(NSString * _Nullable type);


NS_ASSUME_NONNULL_BEGIN

@interface ARkitViewController : UIViewController
@property (nonatomic, copy) ARkitViewControllerShareBlock shareBlock;
@property (nonatomic, copy) ARkitViewControllerGetLaunge getLaunge;
@property (nonatomic, copy) ARkitViewControllerIsNewVersion isNewVersion;
@property (nonatomic, copy) ARkitViewControllerPushWebView pushWebView;

@property (nonatomic, strong) NSString *filePath;



@end

NS_ASSUME_NONNULL_END
