//
//  ARWatermarkTableViewCell.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/28.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARWatermarkTableViewCell.h"

@implementation ARWatermarkTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenTJWidth, 27)];
        self.centerLabel.textColor = [UIColor whiteColor];
        self.centerLabel.font = FontTJ(18);
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.centerLabel];
    }
    return self;
}
- (void)showViewWith:(NSString *)title {
    self.centerLabel.text = title;
}

@end
