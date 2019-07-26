//
//  ARAudioPlayerView.h
//  CGTN
//
//  Created by YangTengJiao on 2019/5/27.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^ARAudioPlayerViewBlock)(NSString * _Nullable type,NSInteger time);

NS_ASSUME_NONNULL_BEGIN

@interface ARAudioPlayerView : UIView <AVAudioPlayerDelegate>
@property (nonatomic, strong) UIImageView *progressBgView;
@property (nonatomic, strong) UIImageView *progressTopView;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat oldVolume;

@property (nonatomic, assign) NSInteger en_String_Num;
@property (nonatomic, assign) NSInteger en_Animation_Num;
@property (nonatomic, assign) NSInteger zh_String_Num;
@property (nonatomic, assign) NSInteger zh_Animation_Num;


@property (nonatomic, copy)ARAudioPlayerViewBlock audioBlock;

- (void)removeSelf;
- (void)play;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
