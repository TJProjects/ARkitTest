//
//  ARWaterMark.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/28.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TJDefine.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARWaterMark : NSObject
+ (UIImage *)markWaterImageWithImage:(UIImage *)image name:(NSString *)name from:(NSString *)from hour:(NSString *)hour year:(NSString *)year;

+ (void)markWaterImageWithVideo:(NSString *)path name:(NSString *)name from:(NSString *)from hour:(NSString *)hour year:(NSString *)year completionHandler:(void (^)(NSURL* outPutURL, int code))handler;


@end

NS_ASSUME_NONNULL_END
