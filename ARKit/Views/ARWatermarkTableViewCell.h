//
//  ARWatermarkTableViewCell.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/28.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARWatermarkTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *centerLabel;

- (void)showViewWith:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
