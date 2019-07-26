//
//  ARWatermarkView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/28.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARWatermarkView.h"

@implementation ARWatermarkView 

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor greenColor];
//        self.hidden = YES;
        self.dataArray = [[NSMutableArray alloc] init];
        if (KIsEnglishLaunge) {
            [self.dataArray addObjectsFromArray:@[@"Tokyo",@"Amsterdam",@"Dubai",@"Copenhagen",@"Ho Chi Minh City",@"Phnom penh",@"Los Angeles",@"Bangkok",@"Seoul",@"Sydney"]];
        } else {
            [self.dataArray addObjectsFromArray:@[@"东京",@"阿姆斯特丹",@"迪拜",@"哥本哈根",@"胡志明市",@"金边",@"洛杉矶",@"曼谷",@"首尔",@"悉尼"]];
        }
    }
    return self;
}
- (void)showWithImage:(UIImage *)image {
    self.image = image;
    [self.bgImageView setImage:image];
    self.bgImageView.hidden = NO;
    self.maskUpView.hidden = NO;
    self.promptButton.hidden = NO;
    self.bgView.hidden = YES;
    self.backButton.hidden = NO;
}
- (void)showWithVideo:(NSString *)path {
    self.path = path;
    self.bgImageView.hidden = YES;
    self.playerView = [[TJAVplayerView alloc] init];
    self.playerView.frame = self.bounds;
    [self addSubview:self.playerView];
    self.maskUpView.hidden = NO;
    self.playerView.isNoUI = YES;
    self.playerView.isPlayAgain = YES;
    [self.playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:path]];
    self.promptButton.hidden = NO;
    self.bgView.hidden = YES;
    self.backButton.hidden = NO;
}
- (void)backVC {
    if (self.watermarkBlock) {
        self.watermarkBlock(@"back", nil, nil);
    }
    [_playerView removeSelf];
    [self removeFromSuperview];
}
- (void)promptButtonAction {
    self.promptButton.hidden = YES;
    self.bgView.hidden = NO;
    self.nameLabel.hidden = NO;
    self.nameTextField.hidden = NO;
    self.fromLabel.hidden = NO;
    self.fromButton.hidden = NO;
    self.nextButton.hidden = NO;
}
- (void)formButtonAction {
    [self.nameTextField resignFirstResponder];
    if (!_fromTableView) {
        self.fromTableView.hidden = NO;
        [self.fromImageView setImage:kGetARImage(@"上拉菜单")];
        self.nextButton.hidden = YES;
        return;
    }
    if (self.fromTableView.hidden) {
        self.fromTableView.hidden = NO;
        [self.fromImageView setImage:kGetARImage(@"上拉菜单")];
        self.nextButton.hidden = YES;
    } else {
        self.fromTableView.hidden = YES;
        [self.fromImageView setImage:kGetARImage(@"下拉菜单")];
        self.nextButton.hidden = NO;
    }
}
- (void)nextButtonAction {
    if (self.image) {
        self.image = [ARWaterMark markWaterImageWithImage:self.image name:self.nameTextField.text from:self.fromButton.titleLabel.text hour:[self getHourByTime] year:[self getYearByTime]];
        [self.bgImageView setImage:self.image];
    } else {
        __weak typeof(self) weakSelf = self;
        [ARWaterMark markWaterImageWithVideo:self.path name:self.nameTextField.text from:self.fromButton.titleLabel.text hour:[self getHourByTime] year:[self getYearByTime] completionHandler:^(NSURL * _Nonnull outPutURL, int code) {
            NSLog(@"%@",outPutURL);
            weakSelf.path = outPutURL.path;
            [weakSelf.playerView settingPlayerItemWithUrl:outPutURL];
        }];
//        [ARWaterMark addWaterPicWithVideoPath:self.path];
//         [self.playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:path]];
    }
    self.bgView.hidden = YES;
    self.nameLabel.hidden = YES;
    self.nameTextField.hidden = YES;
    self.fromLabel.hidden = YES;
    self.fromButton.hidden = YES;
    self.nextButton.hidden = YES;
    self.loadButton.hidden = NO;
    self.shareButton.hidden = NO;
}

- (NSString *)getHourByTime {
    // 定义一个遵循某个历法的日历对象 NSGregorianCalendar国际历法(iOS 8之前的,之后用NSCalendarIdentifierGregorian)
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitNanosecond | NSCalendarUnitCalendar | NSCalendarUnitTimeZone;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    
    NSString *hour = [NSString stringWithFormat:@"%02ld:%02ld AM",comps.hour,comps.minute];
    if (comps.hour >= 12) {
        hour = [NSString stringWithFormat:@"%02ld:%02ld PM",comps.hour-12,comps.minute];
    }
    return hour;
}
- (NSString *)getYearByTime {
    // 定义一个遵循某个历法的日历对象 NSGregorianCalendar国际历法(iOS 8之前的,之后用NSCalendarIdentifierGregorian)
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitNanosecond | NSCalendarUnitCalendar | NSCalendarUnitTimeZone;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
//    NSString *hour = [NSString stringWithFormat:@"%02ld:%02ld AM",comps.hour,comps.minute];
//    if (comps.hour >= 12) {
//        hour = [NSString stringWithFormat:@"%02ld:%02ld PM",comps.hour-12,comps.minute];
//    }
    
    NSString *month = @"JANUARY";
    switch (comps.month) {
        case 1:
        {
            month = @"JANUARY";
        }
            break;
        case 2:
        {
            month = @"FEBRUARY";
        }
            break;
        case 3:
        {
            month = @"MARCH";
        }
            break;
        case 4:
        {
            month = @"APRIL";
        }
            break;
        case 5:
        {
            month = @"MAY";
        }
            break;
        case 6:
        {
            month = @"JUNE";
        }
            break;
        case 7:
        {
            month = @"JULY";
        }
            break;
        case 8:
        {
            month = @"AUGUST";
        }
            break;
        case 9:
        {
            month = @"SEPTEMBER";
        }
            break;
        case 10:
        {
            month = @"OCTOBER";
        }
            break;
        case 11:
        {
            month = @"NOVEMBER";
        }
            break;
        case 12:
        {
            month = @"DECEMBER";
        }
            break;
            
        default:
            break;
    }
    NSString *year = [NSString stringWithFormat:@"%@ %02ld,%ld",month,comps.day,comps.year];
    return year;
}
- (void)loadButtonAction {
    if (self.image) {
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    } else {
        UISaveVideoAtPathToSavedPhotosAlbum(self.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
//
}
// 图片保存回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self showToastViewWith:@"保存失败"];
    } else {
        [self showToastViewWith:@"保存成功"];
    }
}
// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [self showToastViewWith:@"保存失败"];
    } else {
        [self showToastViewWith:@"保存成功"];
    }
}
- (void)shareButtonAction {
    if (self.watermarkBlock) {
        self.watermarkBlock(@"",self.image, self.path);
    }
}
- (UIImageView *)maskUpView {
    if (!_maskUpView) {
        _maskUpView = [[UIImageView alloc] initWithImage:kGetARImage(@"遮罩-上")];
        _maskUpView.frame = CGRectMake(0, 0, ScreenTJWidth, ScreenTJWidth*(798.0/1125.0));
        [self addSubview:_maskUpView];
    }
    return _maskUpView;
}
- (UIButton *)backButton {//65:78 22.5 102 35
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(15, (KIsiPhoneX?35:22.5), 35, 35);
        [_backButton setImage:kGetARImage(@"返回") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    return _backButton;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}
- (UIButton *)promptButton {//91 75
    if (!_promptButton) {
        _promptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _promptButton.frame = CGRectMake(ScreenTJWidth/2.0-270/2.0, ScreenTJHeight-(KIsiPhoneX?103:64)-72, 270, 72);
        [_promptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _promptButton.titleLabel.font = FontTJ(18);
        _promptButton.titleLabel.numberOfLines = 0;
        [_promptButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
        _promptButton.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
        _promptButton.layer.borderWidth = 1.5;
        [_promptButton setTitle:KWatermarkPrompt forState:UIControlStateNormal];
        [_promptButton addTarget:self action:@selector(promptButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_promptButton];
    }
    return _promptButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, (KIsiPhoneX?197:125), ScreenTJWidth-33-33, 24)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = FontTJ(24);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = KWatermarkNameLabel;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(33, (KIsiPhoneX?251:179), ScreenTJWidth-33-33, 50)];
        _nameTextField.textColor = [UIColor whiteColor];
        _nameTextField.font = FontTJ(18);
        _nameTextField.textAlignment = NSTextAlignmentCenter;
        _nameTextField.backgroundColor = RGBATJ(19, 19, 20, 0.3);
        _nameTextField.layer.borderColor = RGBTJ(199, 199, 199).CGColor;;
        _nameTextField.layer.borderWidth = 1.5;
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc] initWithString:KWatermarkNameText];
        [textColor addAttribute:NSForegroundColorAttributeName
                          value:[UIColor whiteColor]
                          range:[KWatermarkNameText rangeOfString:KWatermarkNameText]];
        _nameTextField.attributedPlaceholder = textColor;
        _nameTextField.delegate = self;
        [self addSubview:_nameTextField];
    }
    return _nameTextField;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _nameTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.nameTextField.text.length >= 15) {
            self.nameTextField.text = [textField.text substringToIndex:15];
            return NO;
        }
    }
    return YES;
}

- (UILabel *)fromLabel {
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, (KIsiPhoneX?383:293), ScreenTJWidth-33-33, 24)];
        _fromLabel.textColor = [UIColor whiteColor];
        _fromLabel.font = FontTJ(24);
        _fromLabel.textAlignment = NSTextAlignmentCenter;
        _fromLabel.text = KWatermarkFromLabel;
        [self addSubview:_fromLabel];
    }
    return _fromLabel;
}
- (UIButton *)fromButton {
    if (!_fromButton) {
        _fromButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fromButton.frame = CGRectMake(33, (KIsiPhoneX?451:361), ScreenTJWidth-33-33, 50);
        [_fromButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _fromButton.titleLabel.font = FontTJ(18);
        [_fromButton setBackgroundColor:RGBATJ(19, 19, 20, 0.3)];
        _fromButton.layer.borderColor = RGBTJ(199, 199, 199).CGColor;
        _fromButton.layer.borderWidth = 1.5;
        [_fromButton setTitle:self.dataArray[0] forState:UIControlStateNormal];
        [_fromButton addTarget:self action:@selector(formButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_fromButton addSubview:self.fromImageView];
//        [_fromButton setImage:kGetARImage(@"下拉菜单") forState:UIControlStateNormal];
//        _fromButton.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
//        _fromButton.imageEdgeInsets = UIEdgeInsetsMake(0, (14+150), 0, -(14+150));
        [self addSubview:_fromButton];
    }
    return _fromButton;
}

- (UIImageView *)fromImageView {
    if (!_fromImageView) {
        _fromImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenTJWidth-33-33-30-14, 50/2.0-15/2.0, 14, 15)];
        [_fromImageView setImage:kGetARImage(@"下拉菜单")];
    }
    return _fromImageView;
}


- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:kGetARImage(@"next")];
        imageView.frame = CGRectMake(4, 0, 52, 52);
        [_nextButton addSubview:imageView];
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 60, 25)];
        text.text = @"NEXT";
        text.textColor = [UIColor whiteColor];
        text.font = FontTJ(18);
        text.textAlignment = NSTextAlignmentCenter;
        [_nextButton addSubview:text];
        _nextButton.frame = CGRectMake(ScreenTJWidth/2.0-60/2.0, (KIsiPhoneX?590:475), 60, 90);
        [_nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
    }
    return _nextButton;
}

- (UITableView *)fromTableView {
    if (!_fromTableView) {//57 128
        _fromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.fromButton.frame.origin.y+self.fromButton.frame.size.height, ScreenTJWidth, ScreenTJHeight-self.fromButton.frame.origin.y-self.fromButton.frame.size.height-(KIsiPhoneX?54:54))];
        _fromTableView.backgroundColor = [UIColor clearColor];
        _fromTableView.rowHeight = 27;
        [_fromTableView registerClass:[ARWatermarkTableViewCell class] forCellReuseIdentifier:@"ARWatermarkTableViewCell"];
        _fromTableView.delegate = self;
        _fromTableView.dataSource = self;
        _fromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_fromTableView];
    }
    return _fromTableView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ARWatermarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ARWatermarkTableViewCell" forIndexPath:indexPath];
    if (cell) {
        cell = [[ARWatermarkTableViewCell alloc] init];
    }
    [cell showViewWith:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.fromTableView.hidden = YES;
    [self.fromImageView setImage:kGetARImage(@"下拉菜单")];
    [self.fromButton setTitle:self.dataArray[indexPath.row] forState:UIControlStateNormal];
    self.nextButton.hidden = NO;
}

- (UIButton *)loadButton {
    if (!_loadButton) {
        _loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadButton.frame = CGRectMake(ScreenTJWidth-56-20, (KIsiPhoneX?33:22), 56, 56);
        [_loadButton setImage:kGetARImage(@"下载按钮") forState:UIControlStateNormal];
        [_loadButton addTarget:self action:@selector(loadButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loadButton];
    }
    return _loadButton;
}
- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(ScreenTJWidth-56-20, (KIsiPhoneX?33:22)+56+15, 56, 56);
        [_shareButton setImage:kGetARImage(@"分享按钮") forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
    }
    return _shareButton;
}
- (UILabel *)toastLabel {
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenTJHeight/2.0-111/2.0, ScreenTJWidth-20-20, 111)];
        _toastLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        _toastLabel.layer.borderWidth = 1.5;
        _toastLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.font = FontTJ(24);
        _toastLabel.numberOfLines = 0;
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_toastLabel];
    }
    return _toastLabel;
}
- (void)showToastViewWith:(NSString *)toast {
    [self bringSubviewToFront:self.toastLabel];
    self.toastLabel.hidden = NO;
    self.toastLabel.text = toast;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.toastLabel.hidden = YES;
    });
}

@end
