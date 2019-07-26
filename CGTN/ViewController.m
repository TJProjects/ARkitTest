//
//  ViewController.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/15.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ViewController.h"
#import "TJDefine.h"
#import "ARkitViewController.h"

#import "TJAVplayerView.h"
#import "ARFirstLoadView.h"
#import "ARFunctionTips.h"
#import "ARScanPromptView.h"
#import "ARAudioPlayerView.h"
#import "ARScanBottomView.h"
#import "ARWatermarkView.h"
#import "ARScanBottomPromptView.h"
#import "ARLabelSelectView.h"
#import "ARPanoramaballTips.h"
#import "ARAirportLabelView.h"
#import "ARCheckVIew.h"

@interface ViewController ()

@property (nonatomic, strong)ARkitViewController *arVC;
@property (weak, nonatomic) IBOutlet UIButton *artest;
@property (weak, nonatomic) IBOutlet UIButton *test;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.test.hidden = YES;
}
- (IBAction)artest:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    ARkitViewController *arVC = [[ARkitViewController alloc] init];
    [self.navigationController pushViewController:arVC animated:YES];
    //分享回调
    arVC.shareBlock = ^(NSString *type, UIImage * _Nullable image, NSString * _Nullable path) {
        //判断type为 top image video
    };
    arVC.getLaunge = ^NSString * _Nullable{
        return @"";//返回当前语言版本
    };
    arVC.isNewVersion = ^BOOL{
        return YES;//返回是否为新版本
    };
    arVC.pushWebView = ^(NSString * _Nullable type) {
        //跳转移动端⽹网⻚页版本
    };
    
    
}
- (void)startLoad {
    static float time = 0.01;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        time = time + 0.05;
//        [self.arVC showLoadProgress:time];
//        if (time < 1) {
//            [self startLoad];
//        }
//        if (time >= 1) {
//            [self.arVC loadOver];
//        }
    });
}

- (IBAction)testAction:(id)sender {
    //播放视频
//    TJAVplayerView *playerView = [[TJAVplayerView alloc] init];
//    playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    [self.view addSubview:playerView];
//    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
//    [playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
    //首页测试
//    ARFirstLoadView *firstLoadView = [[ARFirstLoadView alloc] initWithFrame:self.view.bounds];
//    firstLoadView.tag = 101;
//    [self.view addSubview:firstLoadView];
//    [self timeChange];
    //ar提示页测试
//    ARFunctionTips *arTips = [[ARFunctionTips alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:arTips];
    //ar扫描提示测试
//    ARScanPromptView *prompt = [[ARScanPromptView alloc] init];
//    [self.view addSubview:prompt];
//    [prompt showScanPlane];
//    [prompt showTapModel];
//    [prompt showResetTapModel];
    //音频播放测试
//    ARAudioPlayerView *audioPalyer = [[ARAudioPlayerView alloc] initWithFrame:CGRectMake(0, 83, ScreenTJWidth, 60)];
//    [self.view addSubview:audioPalyer];
    //视频录制按钮
//    ARScanBottomView *bottomView = [[ARScanBottomView alloc] initWithFrame:CGRectMake(0, ScreenTJHeight-76-(KIsiPhoneX?59:42), ScreenTJWidth, 80)];
//    [self.view addSubview:bottomView];
//    [bottomView showLeftAnimationWith:5];
    //添加水印
//    ARWatermarkView *waterView = [[ARWatermarkView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:waterView];
//    [waterView showWithImage:kGetARImage(@"遮罩")];
//    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
//    NSString *moviePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"output.mp4"];
//    [waterView showWithVideo:moviePath];
    //Ar按钮提示
//    ARScanBottomPromptView *prompt = [[ARScanBottomPromptView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:prompt];
    //模型标签说明
//    ARLabelSelectView *label = [[ARLabelSelectView alloc] initWithFrame:CGRectMake(0, (KIsiPhoneX?84:69), ScreenTJWidth, 130)];
//    [self.view addSubview:label];
//    [label showTerminal];
    //全景球提示
//    ARPanoramaballTips *ball = [[ARPanoramaballTips alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:ball];
    
//    ARAirportLabelView *label = [[ARAirportLabelView alloc] initWithFrame:CGRectMake(50, 200, 84, 50)];
//    [label showViewWith:@"TERMINAL"];
//    [label showAnimationWith:5];
//    [self.view addSubview:label];
    //请求失败提示
    ARCheckVIew *checkView = [[ARCheckVIew alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:checkView];
    [checkView showViewUnNewVersion];

}
- (void)timeChange {
    static float time = 0.01;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        time = time + 0.01;
        ARFirstLoadView *firstLoadView = [self.view viewWithTag:101];
        [firstLoadView showProgressViewWith:time];
        if (time < 1) {
            [self timeChange];
        }
    });
}


@end
