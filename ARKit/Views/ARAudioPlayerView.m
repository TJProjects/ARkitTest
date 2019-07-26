//
//  ARAudioPlayerView.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/27.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARAudioPlayerView.h"

@implementation ARAudioPlayerView 

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}
- (void)creatSubView {
//    if ([kUserDefaults boolForKey:@"ARAudioPlayerViewIsFirst"]) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (self.audioBlock) {
//                self.audioBlock(@"close",0);
//            }
//            [self removeSelf];
//        });
//        return;
//    }
    [self addSubview:self.firstLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.firstLabel.hidden = YES;
        [self addSubview:self.centerLabel];
        [self addSubview:self.progressBgView];
        [self addSubview:self.progressTopView];
        [self addSubview:self.voiceButton];
        [self addSubview:self.closeButton];
        if (KIsEnglishLaunge) {
            self.centerLabel.text = kAudioPlayerCenter1;
        } else {
            self.centerLabel.text = kAudioPlayerCenterZH1;
        }
        [self.timer setFireDate:[NSDate distantPast]];
        [self.audioPlayer play];
        self.en_String_Num = 0;
        self.en_Animation_Num = 0;
        self.zh_String_Num = 0;
        self.zh_Animation_Num = 0;
    });
}
-(float)getWidthForString:(NSString *)value{
    CGSize size = [value sizeWithAttributes:@{NSFontAttributeName:BoldFontTJ(12)}];
    return size.width;
}

- (UIImageView *)progressBgView {
    if (!_progressBgView) {
        _progressBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenTJWidth, 4)];
        _progressBgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.63];
        _progressBgView.clipsToBounds = YES;
    }
    return _progressBgView;
}
- (UIImageView *)progressTopView {
    if (!_progressTopView) {
        _progressTopView = [[UIImageView alloc] initWithFrame:CGRectMake(-ScreenTJWidth, 0, ScreenTJWidth, 4)];
        [_progressTopView setImage:kGetARImage(@"进度条-渐变")];
    }
    return _progressTopView;
}
- (UILabel *)firstLabel {
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenTJWidth, 30)];
        _firstLabel.textAlignment = NSTextAlignmentCenter;
        _firstLabel.textColor = [UIColor whiteColor];
        _firstLabel.font = BoldFontTJ(12);
//        _firstLabel.numberOfLines = 0;
        _firstLabel.text = kAudioPlayerFirst;
    }
    return _firstLabel;
}
- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 10, ScreenTJWidth-69-5, 30)];
        _centerLabel.textColor = [UIColor whiteColor];
        _centerLabel.font = BoldFontTJ(12);
        _centerLabel.numberOfLines = 0;
    }
    return _centerLabel;
}

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.frame = CGRectMake(20, 10, 36, 36);
        [_voiceButton setImage:kGetARImage(@"声音按钮-开启") forState:UIControlStateNormal];
        [_voiceButton addTarget:self action:@selector(voiceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(ScreenTJWidth-20-61, 43, 61, 15);
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitle:kAudioPlayerButton forState:UIControlStateNormal];
        _closeButton.titleLabel.font = BoldFontTJ(12);
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:kAudioPlayerButton attributes:attribtDic];
        [_closeButton setAttributedTitle:attribtStr forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
-  (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"VO_En" ofType:@"mp3"];
//        if (KIsEnglishLaunge) {
//            filePath = [[NSBundle mainBundle] pathForResource:@"VO_En" ofType:@"mp3"];
//        } else {
//            filePath = [[NSBundle mainBundle] pathForResource:@"VO_Zh" ofType:@"mp3"];
//        }
        NSString *filePath = [kARFilePath stringByAppendingPathComponent:@"VO_En.mp3"];
        if (KIsEnglishLaunge) {
            filePath = [kARFilePath stringByAppendingPathComponent:@"VO_En.mp3"];
        } else {
            filePath = [kARFilePath stringByAppendingPathComponent:@"VO_Zh.mp3"];
        }
        
        NSURL *fileUrl = [NSURL URLWithString:filePath];
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
        _audioPlayer.delegate = self;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        if (audioSession.outputVolume > 0) {
            self.oldVolume = audioSession.outputVolume;
        } else {
            self.oldVolume = 0.5;
        }
        _audioPlayer.volume = self.oldVolume;
    }
    return _audioPlayer;
}
/**
 *    即将进入后台的处理
 */
- (void)applicationWillEnterForeground {
    [_audioPlayer play];
}

/**
 *    即将返回前台的处理
 */
- (void)applicationWillResignActive {
    [_audioPlayer pause];
}

- (void)play {
    [_audioPlayer play];
    [_timer setFireDate:[NSDate distantPast]];
    self.hidden = NO;
}
- (void)pause {
    [_audioPlayer pause];
    [_timer setFireDate:[NSDate distantFuture]];
    self.hidden = YES;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (void)timerRunAction {
    NSTimeInterval duration = _audioPlayer.duration;
    NSTimeInterval currentTime = _audioPlayer.currentTime;
    float progress = currentTime/duration;
    self.progressTopView.frame = CGRectMake(ScreenTJWidth*(progress-1), 0, ScreenTJWidth, 4);
//    NSLog(@"timerRunAction %f",currentTime);
    if (KIsEnglishLaunge) {
        [self checkShowENStingCurrentTime:currentTime];
    } else {
        [self checkShowZHStingCurrentTime:currentTime];
    }
}
- (void)checkShowZHStingCurrentTime:(double)currentTime {
    if (currentTime >= 0 && currentTime <= 7 ) {
        if (self.zh_Animation_Num == 0) {
            if (self.audioBlock) {
                self.audioBlock(@"location",7);
            }
            self.zh_Animation_Num++;
        }
    } else if (currentTime >= 7 && currentTime <= 9) {
        if (self.zh_Animation_Num == 1) {
            if (self.audioBlock) {
                self.audioBlock(@"terminal",2);
            }
            self.zh_Animation_Num++;
        }
    } else if (currentTime >= 10 && currentTime <= 20 ) {
        if (self.zh_Animation_Num == 2) {
            if (self.audioBlock) {
                self.audioBlock(@"runways",10);
            }
            self.zh_Animation_Num++;
        }
    } else if (currentTime >= 53 && currentTime <= 56 ) {
        if (self.zh_Animation_Num == 3) {
            if (self.audioBlock) {
                self.audioBlock(@"left",3);
            }
            self.zh_Animation_Num++;
        }
    } else if (currentTime >= 57 && currentTime <= 60 ) {
        if (self.zh_Animation_Num == 4) {
            if (self.audioBlock) {
                self.audioBlock(@"right",3);
            }
            self.zh_Animation_Num++;
        }
    }
    if (currentTime >= 0 && currentTime <= 3 ) {
        if (self.zh_String_Num == 0) {
            self.centerLabel.text = kAudioPlayerCenterZH1;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 4 && currentTime <= 6 ) {
        if (self.zh_String_Num == 1) {
            self.centerLabel.text = kAudioPlayerCenterZH2;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 7 && currentTime <= 9 ) {
        if (self.zh_String_Num == 2) {
            self.centerLabel.text = kAudioPlayerCenterZH3;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 10 && currentTime <= 12 ) {
        if (self.zh_String_Num == 3) {
            self.centerLabel.text = kAudioPlayerCenterZH4;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 13 && currentTime <= 15 ) {
        if (self.zh_String_Num == 4) {
            self.centerLabel.text = kAudioPlayerCenterZH5;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 16 && currentTime <= 21 ) {
        if (self.zh_String_Num == 5) {
            self.centerLabel.text = kAudioPlayerCenterZH6;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 22 && currentTime <= 31 ) {
        if (self.zh_String_Num == 6) {
            self.centerLabel.text = kAudioPlayerCenterZH7;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 32 && currentTime <= 37 ) {
        if (self.zh_String_Num == 7) {
            self.centerLabel.text = kAudioPlayerCenterZH8;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 38 && currentTime <= 40 ) {
        if (self.zh_String_Num == 8) {
            self.centerLabel.text = kAudioPlayerCenterZH9;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 41 && currentTime <= 43 ) {
        if (self.zh_String_Num == 9) {
            self.centerLabel.text = kAudioPlayerCenterZH10;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 44 && currentTime <= 46 ) {
        if (self.zh_String_Num == 10) {
            self.centerLabel.text = kAudioPlayerCenterZH11;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 47 && currentTime <= 49 ) {
        if (self.zh_String_Num == 11) {
            self.centerLabel.text = kAudioPlayerCenterZH12;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 50 && currentTime <= 52 ) {
        if (self.zh_String_Num == 12) {
            self.centerLabel.text = kAudioPlayerCenterZH13;
            self.zh_String_Num++;
        }
    } else if (currentTime >= 53 ) {
        if (self.zh_String_Num == 13) {
            self.centerLabel.text = @"";
            self.zh_String_Num++;
        }
    }
}
- (void)checkShowENStingCurrentTime:(double)currentTime {
    if (currentTime >= 6 && currentTime <= 11 ) {
        if (self.en_Animation_Num == 0) {
            if (self.audioBlock) {
                self.audioBlock(@"terminal",5);
            }
            self.en_Animation_Num++;
        }
    } else if (currentTime >= 12 && currentTime <= 18 ) {
        if (self.en_Animation_Num == 1) {
            if (self.audioBlock) {
                self.audioBlock(@"runways",6);
            }
            self.en_Animation_Num++;
        }
    } else if (currentTime >= 19 && currentTime <= 30 ) {
        if (self.en_Animation_Num == 2) {
            if (self.audioBlock) {
                self.audioBlock(@"location",11);
            }
            self.en_Animation_Num++;
        }
    } else if (currentTime >= 48 && currentTime <= 52 ) {
        if (self.en_Animation_Num == 3) {
            if (self.audioBlock) {
                self.audioBlock(@"left",4);
            }
            self.en_Animation_Num++;
        }
    } else if (currentTime >= 53 && currentTime <= 59 ) {
        if (self.en_Animation_Num == 4) {
            if (self.audioBlock) {
                self.audioBlock(@"right",6);
            }
            self.en_Animation_Num++;
        }
    }
    if (currentTime >= 0 && currentTime <= 6 ) {
        if (self.en_String_Num == 0) {
            self.centerLabel.text = kAudioPlayerCenter1;
            self.en_String_Num++;
        }
    } else if (currentTime >= 6 && currentTime <= 11 ) {
        if (self.en_String_Num == 1) {
            self.centerLabel.text = kAudioPlayerCenter2;
            self.en_String_Num++;
        }
    } else if (currentTime >= 11 && currentTime <= 19 ) {
        if (self.en_String_Num == 2) {
            self.centerLabel.text = kAudioPlayerCenter3;
            self.en_String_Num++;
        }
    } else if (currentTime >= 19 && currentTime <= 22 ) {
        if (self.en_String_Num == 3) {
            self.centerLabel.text = kAudioPlayerCenter4;
            self.en_String_Num++;
        }
    } else if (currentTime >= 22 && currentTime <= 25 ) {
        if (self.en_String_Num == 4) {
            self.centerLabel.text = kAudioPlayerCenter5;
            self.en_String_Num++;
        }
    } else if (currentTime >= 26 && currentTime <= 31 ) {
        if (self.en_String_Num == 5) {
            self.centerLabel.text = kAudioPlayerCenter6;
            self.en_String_Num++;
        }
    } else if (currentTime >= 31 && currentTime <= 36 ) {
        if (self.en_String_Num == 6) {
            self.centerLabel.text = kAudioPlayerCenter7;
            self.en_String_Num++;
        }
    } else if (currentTime >= 37 && currentTime <= 39 ) {
        if (self.en_String_Num == 7) {
            self.centerLabel.text = kAudioPlayerCenter8;
            self.en_String_Num++;
        }
    } else if (currentTime >= 39 ) {
        if (self.en_String_Num == 8) {
            self.centerLabel.text = @"";
            self.en_String_Num++;
        }
    }
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.audioBlock) {
        self.audioBlock(@"close",0);
    }
    [self removeSelf];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}
- (void)closeButtonAction {
    if (self.audioBlock) {
        self.audioBlock(@"close",0);
    }
    [self removeSelf];
}
- (void)voiceButtonAction {
    if (_audioPlayer.volume == 0) {
        [self.voiceButton setImage:kGetARImage(@"声音按钮-开启") forState:UIControlStateNormal];
        _audioPlayer.volume = self.oldVolume;
    } else {
        _audioPlayer.volume = 0;
        [self.voiceButton setImage:kGetARImage(@"声音按钮-关闭") forState:UIControlStateNormal];
    }
}
- (void)removeSelf {
    [kUserDefaults setBool:YES forKey:@"ARAudioPlayerViewIsFirst"];
    [kUserDefaults synchronize];
    [_audioPlayer stop];
    _audioPlayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
    [self removeFromSuperview];
}

@end
