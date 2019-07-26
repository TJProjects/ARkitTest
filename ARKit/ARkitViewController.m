//
//  ARkitViewController.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/16.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARkitViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>
#import "ARFirstLoadView.h"
#import "ARFunctionTips.h"
#import "ARScanPromptView.h"
#import "TJAVplayerView.h"
#import "ARAudioPlayerView.h"
#import "ARScanBottomView.h"
#import "ARWatermarkView.h"
#import "ARScanBottomPromptView.h"
#import "ARWebView.h"
#import "GSDownloadManager.h"
#import "SSZipArchive.h"
#import "ARAboutView.h"
#import "ARAirportLabelView.h"
#import "ARLabelSelectView.h"
#import "ARToastView.h"
#import "ARPanoramaballTips.h"
#import "ARNetErrorView.h"
#import "ARCheckVIew.h"


#define kDefaultScale 0.001
#define kDefaultRange 0.5


typedef NS_ENUM(NSInteger, WZRecordStatus)  {
    WZRecordStatusIdle,
    WZRecordStatusRecording,
    WZRecordStatusFinish,
};

@interface ARkitViewController ()<ARSCNViewDelegate,ARSessionDelegate,UIGestureRecognizerDelegate,AVAudioRecorderDelegate>
@property (nonatomic,strong) ARSCNView *arscnView;//ARview
@property (nonatomic,strong) ARWorldTrackingConfiguration *arConfiguration;//世界追踪
@property (nonatomic,strong) ARPlaneAnchor *planeAnchor;//平面检测的锚点
@property (nonatomic,strong) ARFrame *currentFrame;//会话的当前帧
@property (nonatomic,strong) SCNNode *heziNode;//模型
@property (nonatomic,strong) SCNNode *pingmianNode;//模型
@property (nonatomic,strong) SCNNode *quanjingNode;//模型
@property (nonatomic,strong) SCNPlane *scnPlane;
@property (nonatomic, assign) float airprtScale;
@property (nonatomic, assign) BOOL isRuningQuanJingAnimation;
@property (nonatomic, assign) float quanJingAnimationProgress;
@property (nonatomic, strong) NSArray *quanJingImageArray;
@property (nonatomic, assign) NSInteger quanJingNum;
@property (nonatomic,strong) SCNNode *Innerball;//模型
@property (nonatomic,strong) SCNNode *Outerball;//模型

@property (nonatomic, strong) ARFirstLoadView *firstLoadView;
@property (nonatomic, strong) ARScanPromptView *scanPrompt;
@property (nonatomic, strong) TJAVplayerView *playerView;
@property (nonatomic, strong) ARAudioPlayerView *audioPlayer;
@property (nonatomic, strong) ARScanBottomView *bottomView;
@property (nonatomic, strong) ARScanBottomPromptView *bottomPromptView;

@property (nonatomic, strong) SCNRenderer *renderer;// 渲染器 要给renderer赋值 renderer.scene = sceneView.scene;
@property (nonatomic, strong) AVAssetWriter *writer;
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor;
@property (nonatomic, assign) WZRecordStatus status;
@property (nonatomic, strong) dispatch_queue_t videoQueue; //写入的队列
@property (nonatomic, strong) dispatch_queue_t  audioQueue;    //写入的队列
@property (nonatomic, strong) NSString *videoPath;   //路径
@property (nonatomic, strong) NSString *audioPath;   //路径
@property (nonatomic, strong) NSString *outputPath;
@property (nonatomic, assign) CGSize outputSize;
@property (nonatomic, assign) int count;

@property (nonatomic, strong) AVAudioSession * recordingSession;
@property (nonatomic, strong) AVAudioRecorder * audioRecorder;
@property (nonatomic, assign) BOOL isFirstWriter;  //是否是第一次写入

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) ARAirportLabelView *locationView;
@property (nonatomic, strong) ARAirportLabelView *terminalView;
@property (nonatomic, strong) ARAirportLabelView *runwaysView;
@property (nonatomic, strong) ARLabelSelectView *labelSelectView;
@property (nonatomic, strong) ARToastView *toastView;
@property (nonatomic, strong) ARNetErrorView *errorView;
@property (nonatomic, strong) ARCheckVIew *checkView;

@property (nonatomic, strong) UIImageView *maskUpView;
@property (nonatomic, strong) UIImageView *maskDownView;


@end

@implementation ARkitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    self.maskUpView.hidden = NO;
    self.maskDownView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    
    self.firstLoadView = [[ARFirstLoadView alloc] initWithFrame:self.view.bounds];
    self.firstLoadView.loadBlock = ^(NSString * _Nullable type) {
        [weakSelf loadOver];
    };
    [self.view addSubview:self.firstLoadView];
    
    if (@available(iOS 11.0, *)) {
        if ([ARWorldTrackingConfiguration isSupported]) {
            
        } else {
            [self.checkView showViewUnARkit];
            return;
        }
    } else {
        [self.checkView showViewUnARkit];
        return;
    }
    
    if (!self.isNewVersion) {
        [self.checkView showViewUnNewVersion];
        return;
    }
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    AVAuthorizationStatusNotDetermined = 0,判断是否启用相册权限
    //    AVAuthorizationStatusRestricted    = 1,受限制
    //    AVAuthorizationStatusDenied        = 2,不允许
    //    AVAuthorizationStatusAuthorized    = 3,允许
    NSLog(@"authStatus %ld",(long)authStatus);
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //第一次成功的操作
                    [weakSelf checkLoadViewShow];
                });
            }else{
                [weakSelf.checkView showViewUnCamareOpen];
                return;
            }
        }];
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [weakSelf.checkView showViewUnCamareOpen];
        return;
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //第一次成功的操作
            [weakSelf checkLoadViewShow];
        });
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    if (_bottomView) {
    //        [self.arscnView.session runWithConfiguration:self.arConfiguration];
    //    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.arscnView.session pause];
}
-(BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - 逻辑判断
//判断开始逻辑
- (void)checkLoadViewShow {
    [self creatArscnView];
    self.filePath = kARFilePath;
    [self checkIsNeedLoadFile];
}
//下载文件的进度回调
- (void)showLoadProgress:(float)progress {
    [self.firstLoadView showProgressViewWith:progress];
}
//下载完成回调
- (void)loadOver {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkShowARTipsView];
    });
}
//展示ar介绍页逻辑
- (void)checkShowARTipsView {
    [self.firstLoadView removeSelf];
    self.playerView = [[TJAVplayerView alloc] init];
    self.playerView.isNoUI = YES;
    self.playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:self.playerView];
//#if DEBUG
#if 0
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp4"];
    [self.playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
#else
    NSString *moviePath = @"";
    if (KIsEnglishLaunge) {
        NSInteger x = arc4random() % 2;
        if (x == 0) {
            moviePath = @"https://newstest.cgtn.com/training_video/guideVideo_En_Men_V.mp4";
        } else {
            moviePath = @"https://newstest.cgtn.com/training_video/guideVideo_En_Women_V.mp4";
        }
    } else {
        moviePath = @"https://newstest.cgtn.com/training_video/guideVideo_Zh_Women_V.mp4";
    }
    NSLog(@"%@",moviePath);
    [self.playerView settingPlayerItemWithUrl:[NSURL URLWithString:moviePath]];
#endif
    
    __weak typeof(self) weakSelf = self;
    self.playerView.overBlock = ^(NSString *type) {
        ARFunctionTips *tips = [[ARFunctionTips alloc] initWithFrame:weakSelf.view.bounds];
        tips.tipsBlock = ^(NSString *type) {
            [weakSelf.playerView removeSelf];
            weakSelf.playerView = nil;
            [weakSelf.view addSubview:weakSelf.backButton];
            [weakSelf.view addSubview:weakSelf.aboutButton];
            [weakSelf.view addSubview:weakSelf.shareButton];
            [weakSelf.scanPrompt showScanPlane];
            [weakSelf.arscnView.session runWithConfiguration:weakSelf.arConfiguration];
        };
        [weakSelf.view addSubview:tips];
    };
}

#pragma mark - 创建UI
- (void)backButtonAction {
    if (self.quanjingNode && self.quanjingNode.hidden == NO) {
        SCNMatrix4 mat = SCNMatrix4FromMat4(self.currentFrame.camera.transform);
        if ([self checkIsNeedShowQuanJing:self.heziNode.simdWorldPosition x:mat.m41 y:mat.m42 z:mat.m43]) {
            [self.toastView showToastWith:kToastBack];
        } else {
            [self hiddenQuanJingUI];
        }
        return;
    }
    [self backVC];
}
- (void)backVC {
    [_audioPlayer removeSelf];
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(15, (KIsiPhoneX?35:22.5), 35, 35);
        [_backButton setImage:kGetARImage(@"返回") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIButton *)aboutButton {
    if (!_aboutButton) {
        _aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aboutButton.frame = CGRectMake(ScreenTJWidth-15-35-50, (KIsiPhoneX?35:22.5), 50, 35);
        [_aboutButton setTitle:@"ABOUT" forState:UIControlStateNormal];
        _aboutButton.titleLabel.font = FontTJ(12);
        [_aboutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_aboutButton addTarget:self action:@selector(aboutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aboutButton;
}
- (void)aboutButtonAction {
    ARAboutView *aboutView = [[ARAboutView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) weakSelf = self;
    aboutView.viewBlock = ^(NSString * _Nullable type) {
        if ([type isEqualToString:@"back"]) {
            [weakSelf.audioPlayer play];
        }
    };
    [self.view addSubview:aboutView];
    [weakSelf.audioPlayer pause];
}
- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(ScreenTJWidth-15-35, (KIsiPhoneX?35:22.5), 35, 35);
        [_shareButton setImage:kGetARImage(@"分享") forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (void)shareButtonAction {
    if (self.shareBlock) {
        self.shareBlock(@"top", nil, nil);
    }
}
- (ARScanPromptView *)scanPrompt {
    if (!_scanPrompt) {
        _scanPrompt = [[ARScanPromptView alloc] init];
        [self.view addSubview:_scanPrompt];
    }
    return _scanPrompt;
}
- (ARScanBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView =  [[ARScanBottomView alloc] initWithFrame:CGRectMake(0, ScreenTJHeight-76-(KIsiPhoneX?59:42), ScreenTJWidth, 80)];
        [self.view addSubview:_bottomView];
        // 创建SCNRenderer
        self.renderer = [SCNRenderer rendererWithDevice:nil options:nil];
        // 将sceneView的sceneView传给renderer
        self.renderer.scene = self.arscnView.scene;
        // 创建图像处理队列
        self.videoQueue = dispatch_queue_create("com.TJ.video.queue", NULL);
        self.audioQueue = dispatch_queue_create("com.TJ.audio.queue", NULL);
        self.isFirstWriter = YES;
        // 设置输出分辨率
        self.outputSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*3.0, [UIScreen mainScreen].bounds.size.height*3.0);
        
        self.videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"video.mp4"];
        self.audioPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"recorder.caf"];
        self.outputPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"output.mp4"];
        
        //如果有就先清除
        //        [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
        //        [[NSFileManager defaultManager] removeItemAtPath:self.audioPath error:nil];
        //        [[NSFileManager defaultManager] removeItemAtPath:self.outputPath error:nil];
        
        __weak typeof(self) weakSelf = self;
        _bottomView.bottomBlock = ^(NSString *type) {
            if ([type isEqualToString:@"info"]) {
                ARWebView *webView = [[ARWebView alloc] initWithFrame:weakSelf.view.bounds];
                webView.webBlock = ^(NSString *type) {
                    [weakSelf.audioPlayer play];
                };
                [weakSelf.view addSubview:webView];
                [weakSelf.audioPlayer pause];
            } else if ([type isEqualToString:@"photo"]) {
                [weakSelf takePhoto];
                [weakSelf.audioPlayer pause];
            } else if ([type isEqualToString:@"video"]) {
                TJAVplayerView *playerView = [[TJAVplayerView alloc] init];
                playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [weakSelf.view addSubview:playerView];
                NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
                [playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
                playerView.viewBlock = ^(NSString * _Nullable type) {
                    if ([type isEqualToString:@"back"]) {
                        [weakSelf.audioPlayer play];
                    }
                };
                [weakSelf.audioPlayer pause];
            } else if ([type isEqualToString:@"start"]) {
                // 开始录制
                [weakSelf startRecording];
                [weakSelf.audioPlayer pause];
            } else if ([type isEqualToString:@"over"]) {
                // 结束录制
                [weakSelf finishRecording];
                [weakSelf.audioPlayer pause];
            }
        };
    }
    return _bottomView;
}
- (ARAirportLabelView *)locationView {
    if (!_locationView) {
        _locationView = [[ARAirportLabelView alloc] initWithFrame:CGRectMake(-84, -50, 84, 50)];
        [_locationView showViewWith:kLocation];
        __weak typeof(self) weakSelf = self;
        _locationView.buttonBlock = ^(NSString * _Nonnull type) {
            [weakSelf.labelSelectView showLocation];
            [weakSelf.audioPlayer pause];
            weakSelf.locationView.hidden = YES;
            weakSelf.terminalView.hidden = YES;
            weakSelf.runwaysView.hidden = YES;
            for (SCNNode *subNode in [weakSelf.heziNode childNodes]) {
                if ([subNode.name isEqualToString:@"pm_e_location"]) {
                    subNode.hidden = !KIsEnglishLaunge;
                }
                if ([subNode.name isEqualToString:@"pm_c_location"]) {
                    subNode.hidden = KIsEnglishLaunge;
                }
                if ([subNode.name isEqualToString:@"pm_e_terminal"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_c_terminal"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_e_runways"]) {
                    subNode.hidden = YES;
                }
            }
        };
        [self.view addSubview:_locationView];
    }
    return _locationView;
}
- (ARAirportLabelView *)terminalView {
    if (!_terminalView) {
        _terminalView = [[ARAirportLabelView alloc] initWithFrame:CGRectMake(-84, -50, 84, 50)];
        [_terminalView showViewWith:kTerminal];
        __weak typeof(self) weakSelf = self;
        _terminalView.buttonBlock = ^(NSString * _Nonnull type) {
            [weakSelf.labelSelectView showTerminal];
            [weakSelf.audioPlayer pause];
            weakSelf.locationView.hidden = YES;
            weakSelf.terminalView.hidden = YES;
            weakSelf.runwaysView.hidden = YES;
            for (SCNNode *subNode in [weakSelf.heziNode childNodes]) {
                if ([subNode.name isEqualToString:@"pm_e_location"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_c_location"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_e_terminal"]) {
                    subNode.hidden = !KIsEnglishLaunge;
                }
                if ([subNode.name isEqualToString:@"pm_c_terminal"]) {
                    subNode.hidden = KIsEnglishLaunge;
                }
                if ([subNode.name isEqualToString:@"pm_e_runways"]) {
                    subNode.hidden = YES;
                }
            }
        };
        [self.view addSubview:_terminalView];
    }
    return _terminalView;
}
- (ARAirportLabelView *)runwaysView {
    if (!_runwaysView) {
        _runwaysView = [[ARAirportLabelView alloc] initWithFrame:CGRectMake(-84, -50, 84, 50)];
        [_runwaysView showViewWith:kRunways];
        __weak typeof(self) weakSelf = self;
        _runwaysView.buttonBlock = ^(NSString * _Nonnull type) {
            [weakSelf.labelSelectView showRunways];
            [weakSelf.audioPlayer pause];
            weakSelf.locationView.hidden = YES;
            weakSelf.terminalView.hidden = YES;
            weakSelf.runwaysView.hidden = YES;
            for (SCNNode *subNode in [weakSelf.heziNode childNodes]) {
                if ([subNode.name isEqualToString:@"pm_e_location"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_c_location"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_e_terminal"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_c_terminal"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_e_runways"]) {
                    subNode.hidden = NO;
                }
            }
        };
        [self.view addSubview:_runwaysView];
    }
    return _runwaysView;
}
- (ARLabelSelectView *)labelSelectView {
    if (!_labelSelectView) {
        _labelSelectView = [[ARLabelSelectView alloc] initWithFrame:CGRectMake(0, (KIsiPhoneX?84:69), ScreenTJWidth, 130)];
        __weak typeof(self) weakSelf = self;
        _labelSelectView.selectBlock = ^(NSString * _Nonnull type) {
            [weakSelf.labelSelectView hiddenView];
            [weakSelf.audioPlayer play];
            weakSelf.locationView.hidden = NO;
            weakSelf.terminalView.hidden = NO;
            weakSelf.runwaysView.hidden = NO;
            for (SCNNode *subNode in [weakSelf.heziNode childNodes]) {
                if ([subNode.name isEqualToString:@"pm_e_location"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_c_location"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_e_terminal"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_c_terminal"]) {
                    subNode.hidden = YES;
                }
                if ([subNode.name isEqualToString:@"pm_e_runways"]) {
                    subNode.hidden = YES;
                }
            }
        };
        [self.view addSubview:_labelSelectView];
    }
    return _labelSelectView;
}
- (ARToastView *)toastView {
    if (!_toastView) {
        _toastView = [[ARToastView alloc] init];
        [self.view addSubview:_toastView];
    }
    return _toastView;
}

- (UIImageView *)maskUpView {
    if (!_maskUpView) {
        _maskUpView = [[UIImageView alloc] initWithImage:kGetARImage(@"遮罩-上")];
        _maskUpView.frame = CGRectMake(0, 0, ScreenTJWidth, ScreenTJWidth*(798.0/1125.0));
        [self.view addSubview:_maskUpView];
    }
    return _maskUpView;
}
- (UIImageView *)maskDownView {
    if (!_maskDownView) {
        _maskDownView = [[UIImageView alloc] initWithImage:kGetARImage(@"遮罩-下")];
        _maskDownView.frame = CGRectMake(0, ScreenTJHeight-ScreenTJWidth*(666.0/1125.0), ScreenTJWidth, ScreenTJWidth*(666.0/1125.0));
        [self.view addSubview:_maskDownView];
    }
    return _maskDownView;
}
- (ARNetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[ARNetErrorView alloc] initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf = self;
        _errorView.errorBlock = ^(NSString * _Nonnull type) {
            [weakSelf backVC];
        };
        [self.view addSubview:_errorView];
    }
    return _errorView;
}

- (ARCheckVIew *)checkView {
    if (!_checkView) {
        _checkView = [[ARCheckVIew alloc] initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf = self;
        _checkView.checkBlock = ^(NSString * _Nullable type) {
            [weakSelf backVC];
            if (weakSelf.pushWebView) {
                weakSelf.pushWebView(nil);
            }
        };
        [self.view addSubview:_checkView];
    }
    return _checkView;
}

#pragma mark - get arkit UI
- (void)creatArscnView {
    self.arscnView = [[ARSCNView alloc]initWithFrame:self.view.bounds];
    //AR会话，负责管理相机追踪配置及3D相机坐标
    ARSession *arSession = [[ARSession alloc] init];
    arSession.delegate = self;
    self.arscnView.session = arSession;
    self.arscnView.delegate = self;
    //    self.arscnView.showsStatistics = YES;
    self.arscnView.debugOptions =  ARSCNDebugOptionShowFeaturePoints;
    self.arscnView.automaticallyUpdatesLighting = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.arscnView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.arscnView addGestureRecognizer:doubleTapGesture];
    
    
    //    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    //    longPress.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
    //    [self.arscnView addGestureRecognizer:longPress];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.arscnView addGestureRecognizer:pinch];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.arscnView addGestureRecognizer:pan];
    
    [self.view insertSubview:self.arscnView atIndex:0];
}
- (ARWorldTrackingConfiguration *)arConfiguration {
    if (!_arConfiguration) {
        _arConfiguration = [[ARWorldTrackingConfiguration alloc]init];
        _arConfiguration.planeDetection = ARPlaneDetectionHorizontal;
        _arConfiguration.lightEstimationEnabled = YES;
    }
    return _arConfiguration;
}
#pragma mark - arkit手势
#pragma mark 拖拽手势
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //获取偏移量
    // 返回的是相对于最原始的手指的偏移量
    if (self.quanjingNode && self.quanjingNode.hidden == NO) {
        CGPoint transP = [pan velocityInView:self.arscnView];
                NSLog(@"pan: %f %f",transP.x,transP.y);
        //        self.quanjingNode.transform = SCNMatrix4Rotate(self.quanjingNode.transform, (transP.y/10000.0)*M_PI, 1, 0, 0);
        self.quanjingNode.transform = SCNMatrix4Rotate(self.quanjingNode.transform, (-transP.x/ScreenTJWidth*0.01)*M_PI, 0, 1, 0);
    }
    //    if (self.heziNode.hidden == NO) {
    //        CGPoint transP = [pan velocityInView:self.arscnView];
    //        NSLog(@"pan: %f %f",transP.x,transP.y);
    //        self.heziNode.position = SCNVector3Make(
    //                                                self.heziNode.position.x+transP.x/ScreenTJWidth*0.01,
    //                                                self.heziNode.position.y,
    //                                                self.heziNode.position.z+transP.y/ScreenTJHeight*0.01
    //                                                );
    //    }
}
#pragma mark 捏合手势  控制放大缩小的倍数
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    if (!self.heziNode || self.heziNode.hidden == YES) {
        return;
    }
    CGFloat scale = (recognizer.scale-1)*kDefaultScale;
    self.airprtScale = self.airprtScale+scale;
    //    NSLog(@"handlePinch %f %f %f",recognizer.scale,recognizer.scale-1,scale);
    recognizer.scale = 1;
    if (self.airprtScale/kDefaultScale > 5) {
        self.airprtScale = kDefaultScale*5;
    } else if (self.airprtScale/kDefaultScale < 0.5) {
        self.airprtScale = kDefaultScale*0.5;
    }
    [self.heziNode setScale:SCNVector3Make(self.airprtScale, self.airprtScale, self.airprtScale)];
}
#pragma mark 长按手势
//- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
//    CGPoint tapPoint = [longPress locationInView:self.arscnView];
//    NSArray<ARHitTestResult *> *result = [self.arscnView hitTest:tapPoint types:ARHitTestResultTypeFeaturePoint];
//    if (result.count == 0) {
//        return;
//    }
//    ARHitTestResult * hitResult = [result firstObject];
//    self.heziNode.position = SCNVector3Make(
//                                            hitResult.worldTransform.columns[3].x,
//                                            hitResult.worldTransform.columns[3].y,
//                                            hitResult.worldTransform.columns[3].z
//                                            );
//}
#pragma mark 双击手势
- (void)doubleTapGesture:(UITapGestureRecognizer *)tap {
    NSLog(@"doubleTapGesture");
    CGPoint tapPoint = [tap locationInView:self.arscnView];
    NSArray<ARHitTestResult *> *result = [self.arscnView hitTest:tapPoint types:ARHitTestResultTypeFeaturePoint];
    if (result.count == 0) {
        NSLog(@"点击范围不对");
        return;
    }
    if (!self.heziNode || self.heziNode.hidden == YES) {
        return;
    }
    ARHitTestResult * hitResult = [result firstObject];
    SCNMatrix4 mat = SCNMatrix4FromMat4(self.currentFrame.camera.transform);
    float distance = sqrt(pow((hitResult.worldTransform.columns[3].x - mat.m41), 2) + pow((hitResult.worldTransform.columns[3].z - mat.m43), 2));
    if (distance < kDefaultRange) {
        [self.toastView showToastWith:kToastPan];
        return;
    }
    self.heziNode.position = SCNVector3Make(
                                            hitResult.worldTransform.columns[3].x,
                                            hitResult.worldTransform.columns[3].y,
                                            hitResult.worldTransform.columns[3].z
                                            );
}


#pragma mark 点击手势
- (void)tap:(UITapGestureRecognizer *)tap {
    NSLog(@"tap");
    CGPoint tapPoint = [tap locationInView:self.arscnView];
    if (!self.heziNode) {
        //        NSArray<ARHitTestResult *> *result = [self.arscnView hitTest:tapPoint types:ARHitTestResultTypeExistingPlaneUsingExtent];
        NSArray<ARHitTestResult *> *result = [self.arscnView hitTest:tapPoint types:ARHitTestResultTypeFeaturePoint];
        if (result.count == 0) {
            NSLog(@"点击范围不对");
            return;
        }
        ARHitTestResult * hitResult = [result firstObject];
        SCNMatrix4 mat = SCNMatrix4FromMat4(self.currentFrame.camera.transform);
        float distance = sqrt(pow((hitResult.worldTransform.columns[3].x - mat.m41), 2) + pow((hitResult.worldTransform.columns[3].z - mat.m43), 2));
        if (distance < kDefaultRange) {
            [self.toastView showToastWith:kToastPan];
            return;
        }
        [self.scanPrompt hiddenView];
        self.bottomView.hidden = NO;
        self.maskDownView.hidden = NO;
        if (![self insertGeometry:hitResult]) {
            [self.toastView showToastWith:@"模型文件有问题"];
            return;
        }
        self.audioPlayer = [[ARAudioPlayerView alloc] initWithFrame:CGRectMake(0, 83, ScreenTJWidth, 60)];
        __weak typeof(self) weakSelf = self;
        self.audioPlayer.audioBlock = ^(NSString * _Nullable type, NSInteger time) {
            if ([type isEqualToString:@"close"]) {
                weakSelf.bottomPromptView = [[ARScanBottomPromptView alloc] initWithFrame:weakSelf.view.bounds];
                [weakSelf.view addSubview:weakSelf.bottomPromptView];
            } else if ([type isEqualToString:@"terminal"]) {
                [weakSelf.terminalView showAnimationWith:time];
            } else if ([type isEqualToString:@"runways"]) {
                [weakSelf.runwaysView showAnimationWith:time];
            } else if ([type isEqualToString:@"location"]) {
                [weakSelf.locationView showAnimationWith:time];
            } else if ([type isEqualToString:@"left"]) {
                [weakSelf.bottomView showLeftAnimationWith:time];
            } else if ([type isEqualToString:@"right"]) {
                [weakSelf.bottomView showRightAnimationWith:time];
            } else if ([type isEqualToString:@""]) {
                
            }
        };
        [self.view addSubview:self.audioPlayer];
    } else {
        __weak typeof(self) weakSelf = self;
        NSArray<SCNHitTestResult *> * results= [self.arscnView hitTest:tapPoint options:nil];
        if (results.count == 0) {
            return;
        }
        for (SCNHitTestResult *res in results) {//遍历所有的返回结果中的node
            if (res.node == self.heziNode) {
                NSLog(@"hezi %@",res.node.name);
            } else {
                NSLog(@"Node %@",res.node.name);
                [self checkQuanJingPointWith:res.node.name];
            }
        }
    }
}
#pragma mark 全景球动画处理
- (NSArray *)quanJingImageArray {
    if (!_quanJingImageArray) {
        _quanJingImageArray = @[@"b2-离港-1.jpg",@"b2-进港-1.jpg",@"1-迎客厅-1.jpg",@"2-东c柱-1.jpg",@"2-指廊-1.jpg",@"4-中心点-6.jpg",@"4-中心点-8.jpg"];
    }
    return _quanJingImageArray;
}
- (void)checkQunJingiAnimation {
    if (!self.quanjingNode) {
        return;
    }
    if (self.isRuningQuanJingAnimation) {
        if (self.quanJingAnimationProgress >= 1) {
            self.isRuningQuanJingAnimation = NO;
            [self showPanormicBallLabelWith:self.quanJingNum];
            return;
        }
        self.Innerball.geometry.firstMaterial.transparency = 1-self.quanJingAnimationProgress;
        self.quanJingAnimationProgress += 0.01;
        NSLog(@"checkQunJingiAnimation %f",self.quanJingAnimationProgress);
    }
}
- (void)checkQuanJingPointWith:(NSString *)name {
    if (!self.quanjingNode || self.quanjingNode.hidden == YES) {
        return;
    }
    if ([name isEqualToString:@"b2_railhub_arrivals_3x_0"]) {
        [self playQuanJingAnimationWith:1];
    } else if ([name isEqualToString:@"b2_railhub_departures_3x_1"]) {
        [self playQuanJingAnimationWith:0];
    } else if ([name isEqualToString:@"stfloor_passengerlounge_3x_1"]) {
        [self playQuanJingAnimationWith:2];
    } else if ([name isEqualToString:@"b2_railhub_arrivals_3x_2"]) {
        [self playQuanJingAnimationWith:1];
    } else if ([name isEqualToString:@"ndfloorairportpiers_3x_2"]) {
        [self playQuanJingAnimationWith:4];
    } else if ([name isEqualToString:@"interlayer_seismic_isolation_technoogy_2x_2"]) {
        
    } else if ([name isEqualToString:@"c_shape_column_3"]) {
        
    } else if ([name isEqualToString:@"thfloor2_3x_3"]) {
        [self playQuanJingAnimationWith:6];
    } else if ([name isEqualToString:@"thfloor_3x_4"]) {
        [self playQuanJingAnimationWith:5];
    } else if ([name isEqualToString:@"stfloor_passengerlounge_3x_4"]) {
        [self playQuanJingAnimationWith:2];
    } else if ([name isEqualToString:@"garden_4"]) {
        
    } else if ([name isEqualToString:@"ndfloorairportpiers_3x_5"]) {
        [self playQuanJingAnimationWith:4];
    } else if ([name isEqualToString:@"thfloor2_3x_5"]) {
        [self playQuanJingAnimationWith:6];
    } else if ([name isEqualToString:@"thfloor_3x_6"]) {
        [self playQuanJingAnimationWith:5];
    } else if ([name isEqualToString:@"ndfloor-c-shape-column@3x_6"]) {
        [self playQuanJingAnimationWith:3];
    } else if ([name isEqualToString:@""]) {
        
    }
}
- (void)hiddenPanormicBallAllLabel {
    for (SCNNode *subNode in [self.quanjingNode childNodes]) {
        if ([subNode.name isEqualToString:@"b2_railhub_arrivals_3x_0"] ||
            [subNode.name isEqualToString:@"stfloor_passengerlounge_3x_1"] ||
            [subNode.name isEqualToString:@"b2_railhub_departures_3x_1"] ||
            [subNode.name isEqualToString:@"ndfloorairportpiers_3x_2"] ||
            [subNode.name isEqualToString:@"b2_railhub_arrivals_3x_2"] ||
            [subNode.name isEqualToString:@"interlayer_seismic_isolation_technoogy_2x_2"] ||
            [subNode.name isEqualToString:@"thfloor2_3x_3"] ||
            [subNode.name isEqualToString:@"c_shape_column_3"] ||
            [subNode.name isEqualToString:@"garden_4"] ||
            [subNode.name isEqualToString:@"thfloor_3x_4"] ||
            [subNode.name isEqualToString:@"stfloor_passengerlounge_3x_4"] ||
            [subNode.name isEqualToString:@"ndfloorairportpiers_3x_5"] ||
            [subNode.name isEqualToString:@"thfloor2_3x_5"] ||
            [subNode.name isEqualToString:@"ndfloor-c-shape-column@3x_6"] ||
            [subNode.name isEqualToString:@"thfloor_3x_6"]) {
            subNode.hidden = YES;
        }
    }
}
- (void)showPanormicBallLabelWith:(NSInteger )num {
    for (SCNNode *subNode in [self.quanjingNode childNodes]) {
        switch (num) {
            case 0:
            {
                if ([subNode.name isEqualToString:@"b2_railhub_arrivals_3x_0"]) {
                    subNode.hidden = NO;
                }
            }
                break;
            case 1:
            {
                if ([subNode.name isEqualToString:@"stfloor_passengerlounge_3x_1"] ||
                    [subNode.name isEqualToString:@"b2_railhub_departures_3x_1"]) {
                    subNode.hidden = NO;
                }
            }
                break;
            case 2:
            {
                if ([subNode.name isEqualToString:@"ndfloorairportpiers_3x_2"] ||
                    [subNode.name isEqualToString:@"b2_railhub_arrivals_3x_2"] ||
                    [subNode.name isEqualToString:@"interlayer_seismic_isolation_technoogy_2x_2"]) {
                    subNode.hidden = NO;
                }
            }
                break;
            case 3:
            {
                if ([subNode.name isEqualToString:@"thfloor2_3x_3"] ||
                    [subNode.name isEqualToString:@"c_shape_column_3"]) {
                    subNode.hidden = NO;
                }
            }
                break;
            case 4:
            {
                if ([subNode.name isEqualToString:@"garden_4"] ||
                    [subNode.name isEqualToString:@"thfloor_3x_4"] ||
                    [subNode.name isEqualToString:@"stfloor_passengerlounge_3x_4"]) {
                    subNode.hidden = NO;
                }
            }
                break;
            case 5:
            {
                if ([subNode.name isEqualToString:@"ndfloorairportpiers_3x_5"] ||
                    [subNode.name isEqualToString:@"thfloor2_3x_5"]) {
                    subNode.hidden = NO;
                }
            }
                break;
            case 6:
            {
                if ([subNode.name isEqualToString:@"ndfloor-c-shape-column@3x_6"] ||
                    [subNode.name isEqualToString:@"thfloor_3x_6"]) {
                    subNode.hidden = NO;
                }
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)playQuanJingAnimationWith:(NSInteger )num {
    self.quanJingNum = num;
    static NSString *oldImage = @"";
    if (oldImage.length == 0) {
        oldImage = [self.quanJingImageArray objectAtIndex:5];
    }
    NSString *newImage = self.quanJingImageArray[num];
    [self hiddenPanormicBallAllLabel];
    UIImage *image1 = kGetARImage(oldImage);
    //    UIImage *image1 = [UIImage imageNamed:oldImage];
    //    image1 = [UIImage imageWithCGImage:image1.CGImage scale:image1.scale orientation:UIImageOrientationUpMirrored];
    self.Innerball.geometry.firstMaterial.diffuse.contents = image1;
    self.Innerball.geometry.firstMaterial.transparency = 1;
    UIImage *image2 = kGetARImage(newImage);
    //    UIImage *image2 = [UIImage imageNamed:newImage];
    //    image2 = [UIImage imageWithCGImage:image2.CGImage scale:image2.scale orientation:UIImageOrientationUpMirrored];
    self.Outerball.geometry.firstMaterial.diffuse.contents = image2;
    NSLog(@"%@ %@",oldImage,newImage);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isRuningQuanJingAnimation = YES;
        self.quanJingAnimationProgress = 0.0;
    });
    oldImage = newImage;
}
- (void)showPanormicBallWith:(NSInteger )num {
    for (SCNNode *subNode in [self.quanjingNode childNodes]) {
        if ([subNode.name isEqualToString:@"Innerball"]) {
            self.Innerball = subNode;
            UIImage *image = kGetARImage(self.quanJingImageArray[num]);
            subNode.geometry.firstMaterial.diffuse.contents = image;
            subNode.geometry.firstMaterial.transparency = 0;
        }
        if ([subNode.name isEqualToString:@"Outerball"]) {
            self.Outerball = subNode;
            UIImage *image = kGetARImage(self.quanJingImageArray[num]);
            subNode.geometry.firstMaterial.diffuse.contents = image;
            subNode.geometry.firstMaterial.transparency = 1;
        }
    }
}
#pragma mark 投放机场模型
- (BOOL)insertGeometry:(ARHitTestResult *)hitResult {
    self.arscnView.debugOptions =  SCNDebugOptionNone;
    
    //    SCNScene *portalScence = [SCNScene sceneNamed:@"Model.scnassets/airport_dae.scn"];
    
    //    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"airport_dae" withExtension:@"DAE"];
    //    SCNScene *portalScence = [SCNScene sceneWithURL:URL options:nil error:nil];
    
    NSString *path = [NSString stringWithFormat:@"%@/Model.scnassets/airport_dae.scn",self.filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"portalScence 有文件");
    } else {
        NSLog(@"portalScence 无文件");
    }
    NSError *error;
    SCNScene *portalScence = [SCNScene sceneWithURL:[NSURL fileURLWithPath:path] options:nil error:&error];
    NSLog(@"error %@",error);
    
    self.heziNode = [portalScence.rootNode childNodeWithName:@"airport" recursively:YES];
    if (!self.heziNode) {
        NSLog(@"机场模型不存在");
        return NO;
    }
    self.heziNode.position = SCNVector3Make(
                                            hitResult.worldTransform.columns[3].x,
                                            hitResult.worldTransform.columns[3].y,
                                            hitResult.worldTransform.columns[3].z-0.2
                                            );
    self.airprtScale = kDefaultScale;
    [self.heziNode setScale:SCNVector3Make(self.airprtScale, self.airprtScale, self.airprtScale)];
    for (SCNNode *subNode in [self.heziNode childNodes]) {
        if ([subNode.name isEqualToString:@"pm_e_location"]) {
            subNode.hidden = YES;
        }
        if ([subNode.name isEqualToString:@"pm_c_location"]) {
            subNode.hidden = YES;
        }
        if ([subNode.name isEqualToString:@"pm_e_terminal"]) {
            subNode.hidden = YES;
        }
        if ([subNode.name isEqualToString:@"pm_c_terminal"]) {
            subNode.hidden = YES;
        }
        if ([subNode.name isEqualToString:@"pm_e_runways"]) {
            subNode.hidden = YES;
        }
    }
    [self.arscnView.scene.rootNode addChildNode:self.heziNode];
    //    NSLog(@"123123 %f %f %f",self.heziNode.eulerAngles.x,self.heziNode.eulerAngles.y,self.heziNode.eulerAngles.z);
    //    NSLog(@"1231  %f %f",self.arscnView.pointOfView.rotation.y,self.arscnView.pointOfView.rotation.w);
    self.heziNode.rotation = SCNVector4Make(0, self.arscnView.pointOfView.rotation.y, 0,self.arscnView.pointOfView.rotation.w);
    //    NSLog(@"123123 %f %f %f",self.heziNode.eulerAngles.x,self.heziNode.eulerAngles.y,self.heziNode.eulerAngles.z);
    
    return YES;
}

#pragma mark - ARSCNViewDelegate
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) return;
    if (self.planeAnchor) {
        return;
    }
    NSLog(@"识别到到平面。。。。。。。");
    
    self.planeAnchor = (ARPlaneAnchor *)anchor;
    
    self.scnPlane = [SCNPlane planeWithWidth:self.planeAnchor.extent.x height:self.planeAnchor.extent.z];
    //调整颜色
    self.scnPlane.firstMaterial.diffuse.contents = [UIColor clearColor];
    //    self.scnPlane.firstMaterial.diffuse.contents = [UIColor greenColor];
    //调整透明度
    self.scnPlane.firstMaterial.transparency = 0.5;
    
    self.pingmianNode = [SCNNode nodeWithGeometry:self.scnPlane];
    self.pingmianNode.name = @"planeNode";
    [self.pingmianNode setPosition:SCNVector3Make(self.planeAnchor.center.x, 0, self.planeAnchor.center.z)];
    self.pingmianNode.transform = SCNMatrix4MakeRotation(- M_PI_2, 1, 0, 0);
    [node addChildNode:self.pingmianNode];
    
    //    SCNScene *portalScence = [SCNScene sceneNamed:@"arModel.scnassets/hezi.scn"];
    //    self.heziNode = [portalScence.rootNode childNodeWithName:@"box" recursively:YES];
    //    self.heziNode.position = SCNVector3Make(self.planeAnchor.transform.columns[3].x, self.planeAnchor.transform.columns[3].y, self.planeAnchor.transform.columns[3].z-2);
    //    [self.arscnView.scene.rootNode addChildNode:self.heziNode];
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    ARPlaneAnchor *plAch = (ARPlaneAnchor *)anchor;
    //    NSLog(@"didUpdateNode forAnchor %f %f",plAch.center.x,plAch.center.z);
    //    if (self.pingmianNode.a) {
    //
    //    }
    
    self.scnPlane.width = plAch.extent.x;
    self.scnPlane.height = plAch.extent.z;
    
    // plane 刚创建时中心点 center 为 0,0,0，node transform 包含了变换参数。
    // plane 更新后变换没变但 center 更新了，所以需要更新 3D 几何体的位置
    self.pingmianNode.position = SCNVector3Make(plAch.center.x, 0, plAch.center.z);
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
}
#pragma mark - ARSessionDelegate
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    self.currentFrame = frame;
    if (self.heziNode) {
        SCNMatrix4 mat = SCNMatrix4FromMat4(frame.camera.transform);
        if ([self checkIsNeedShowQuanJing:self.heziNode.simdWorldPosition x:mat.m41 y:mat.m42 z:mat.m43])
        {
#pragma mark - 展示全景球
            if (!self.quanjingNode){
                //                SCNScene *portalScence = [SCNScene sceneNamed:@"ARModel.scnassets/quanjqiu.scn"];
                SCNScene *portalScence = [SCNScene sceneNamed:@"ARModel.scnassets/quanjqiu.scn"];
                self.quanjingNode = [portalScence.rootNode childNodeWithName:@"group1" recursively:YES];
                self.quanjingNode.position =SCNVector3Make(frame.camera.transform.columns[3].x,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
                self.quanJingNum = 5;
                [self showPanormicBallWith:self.quanJingNum];
                [self hiddenPanormicBallAllLabel];
                [self showPanormicBallLabelWith:self.quanJingNum];
                //                [self.quanjingNode setScale:SCNVector3Make(0.01, 0.01, 0.01)];
                [self.arscnView.scene.rootNode addChildNode:self.quanjingNode];
                ARPanoramaballTips *ball = [[ARPanoramaballTips alloc] initWithFrame:self.view.bounds];
                [ball showScrollTips];
                [self.view addSubview:ball];
            }
            [self showQuanJingUI];
        }
    }
    if (self.quanjingNode && self.quanjingNode.hidden == NO) {
        self.quanjingNode.position =SCNVector3Make(frame.camera.transform.columns[3].x,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
    }
    [self checkQunJingiAnimation];
    [self checkAndWriteVideo];
    [self getPointWithNode];
}
- (void)showQuanJingUI {
    [self.audioPlayer pause];
    self.pingmianNode.hidden = YES;
    self.heziNode.hidden = YES;
    self.quanjingNode.hidden = NO;
    self.shareButton.hidden = YES;
    self.aboutButton.hidden = YES;
    self.bottomView.hidden = YES;
    self.maskUpView.hidden = YES;
    self.maskDownView.hidden = YES;
    self.locationView.hidden = YES;
    self.terminalView.hidden = YES;
    self.runwaysView.hidden = YES;
    self.bottomPromptView.hidden = YES;
    [self.labelSelectView hiddenView];
}
- (void)hiddenQuanJingUI {
    [self.audioPlayer play];
    self.heziNode.hidden = NO;
    self.pingmianNode.hidden = NO;
    self.quanjingNode.hidden = YES;
    self.shareButton.hidden = NO;
    self.aboutButton.hidden = NO;
    self.bottomView.hidden = NO;
    self.maskUpView.hidden = NO;
    self.maskDownView.hidden = NO;
    if (self.labelSelectView.hidden == YES) {
        self.locationView.hidden = NO;
        self.terminalView.hidden = NO;
        self.runwaysView.hidden = NO;
    }
}
#pragma mark - 计算是否进入全景球
- (BOOL)checkIsNeedShowQuanJing:(simd_float3 )position x:(double )x y:(double )y z:(double )z {
    float distance = sqrt(pow((position.x - x), 2) + pow((position.z - z), 2));
    //    NSLog(@"checkIsNeedShowQuanJing %f",distance);
    if (distance < kDefaultRange) {
        return YES;
    }
    return NO;
}
//- (double)getLengthTwoWith:(double )x y:(double )y z:(double )z x2:(double )x2  y2:(double )y2 z2:(double )z2 {
//    double distanceX = x - x2;
//    double distanceY = y - y2;
//    double distanceZ = z - z2;
//    return sqrt((distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ));
//}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors {
    
}
- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors {
    
}
- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors {
    
}

#pragma mark - 计算标签实时坐标点
- (void)getPointWithNode {
    if (!self.heziNode || self.heziNode.hidden == YES) {
        return;
    }
    NSLog(@"getPointWithNode %f %f %f",self.heziNode.worldPosition.x,self.heziNode.worldPosition.y,self.heziNode.worldPosition.z);
    float angle = -self.heziNode.eulerAngles.y;
    
    SCNVector3 locationPosition = SCNVector3Make(-471.482, 61.323, 225.541);
    locationPosition = SCNVector3Make(locationPosition.x*cos(angle)-locationPosition.z*sin(angle), locationPosition.y, locationPosition.x*sin(angle)+locationPosition.z*cos(angle));
    SCNVector3 location = SCNVector3Make(self.heziNode.worldPosition.x+locationPosition.x*self.airprtScale, self.heziNode.worldPosition.y+locationPosition.y*self.airprtScale, self.heziNode.worldPosition.z+locationPosition.z*self.airprtScale);
    SCNVector3 locationPoint = [self.arscnView projectPoint:location];
    self.locationView.center = CGPointMake(locationPoint.x, locationPoint.y);
    
    
    SCNVector3 terminalPosition = SCNVector3Make(11.243, 60.702, 223.169);
    terminalPosition = SCNVector3Make(terminalPosition.x*cos(angle)-terminalPosition.z*sin(angle), terminalPosition.y, terminalPosition.x*sin(angle)+terminalPosition.z*cos(angle));
    SCNVector3 terminal = SCNVector3Make(self.heziNode.worldPosition.x+terminalPosition.x*self.airprtScale, self.heziNode.worldPosition.y+terminalPosition.y*self.airprtScale, self.heziNode.worldPosition.z+terminalPosition.z*self.airprtScale);
    SCNVector3 terminalPoint = [self.arscnView projectPoint:terminal];
    self.terminalView.center = CGPointMake(terminalPoint.x, terminalPoint.y);
    
    SCNVector3 runwaysPosition = SCNVector3Make(486.811, 65.75, 247.131);
    runwaysPosition = SCNVector3Make(runwaysPosition.x*cos(angle)-runwaysPosition.z*sin(angle), runwaysPosition.y, runwaysPosition.x*sin(angle)+runwaysPosition.z*cos(angle));
    SCNVector3 runways = SCNVector3Make(self.heziNode.worldPosition.x+runwaysPosition.x*self.airprtScale, self.heziNode.worldPosition.y+runwaysPosition.y*self.airprtScale, self.heziNode.worldPosition.z+runwaysPosition.z*self.airprtScale);
    SCNVector3 runwaysPoint = [self.arscnView projectPoint:runways];
    self.runwaysView.center = CGPointMake(runwaysPoint.x, runwaysPoint.y);
    //    NSLog(@"projectedOrigin %f %f %f",runways.x,runways.y,runways.z);
}


#pragma mark - 拍照
- (void)takePhoto {
    UIImage *image = [self.renderer snapshotAtTime:1 withSize:CGSizeMake(self.outputSize.width, self.outputSize.height) antialiasingMode:SCNAntialiasingModeMultisampling4X];
    ARWatermarkView *waterView = [[ARWatermarkView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:waterView];
    __weak typeof(self) weakSelf = self;
    waterView.watermarkBlock = ^(NSString *type, UIImage * _Nullable image, NSString * _Nullable path) {
        if ([type isEqualToString:@"back"]) {
            [weakSelf.audioPlayer play];
        } else {
            NSString *type = @"video";
            if (image) {
                type = @"image";
            }
            if (weakSelf.shareBlock) {
                weakSelf.shareBlock(type,image, path);
            }
        }
    };
    [waterView showWithImage:image];
}
#pragma mark - 视频录制
- (void)startRecording {
    [self setupWriter];
    [self.writer startWriting];
    [self.writer startSessionAtSourceTime:kCMTimeZero];
    self.status = WZRecordStatusRecording;
    [self hiddenOtherView];
}
- (void)hiddenOtherView {
    self.backButton.hidden = YES;
    self.aboutButton.hidden = YES;
    self.shareButton.hidden = YES;
    [_audioPlayer pause];
}
- (void)finishRecording {
    self.status = WZRecordStatusFinish;
    [self showOtherView];
}
- (void)showOtherView {
    self.backButton.hidden = NO;
    self.aboutButton.hidden = NO;
    self.shareButton.hidden = NO;
    [_audioPlayer play];
}
- (void)setupWriter {
    //    NSTimeInterval a= [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    //    NSString *time = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSString *time = @"";
    self.videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"video%@.mp4",time]];
    self.audioPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"recorder%@.caf",time]];
    self.outputPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"output%@.mp4",time]];
    
    //如果有就先清除
    [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.audioPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.outputPath error:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
        NSLog(@"videoPath有文件");
    } else {
        NSLog(@"videoPath无文件");
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.audioPath]) {
        NSLog(@"audioPath有文件");
    } else {
        NSLog(@"audioPath无文件");
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.outputPath]) {
        NSLog(@"outputPath有文件");
    } else {
        NSLog(@"outputPath无文件");
    }
    // 创建AVAssetWriter
    self.writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:self.videoPath] fileType:AVFileTypeQuickTimeMovie error:nil];
    // 创建AVAssetWriterInput
    self.videoInput = [[AVAssetWriterInput alloc]
                       initWithMediaType:AVMediaTypeVideo outputSettings:
                       @{AVVideoCodecKey:AVVideoCodecTypeH264,
                         AVVideoWidthKey: @(self.outputSize.width),
                         AVVideoHeightKey: @(self.outputSize.height)}];
    self.videoInput.expectsMediaDataInRealTime = YES;
    [self.writer addInput:self.videoInput];
    // 创建AVAssetWriterInputPixelBufferAdaptor
    self.pixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.videoInput sourcePixelBufferAttributes:
                               @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA),
                                 (id)kCVPixelBufferWidthKey:@(self.outputSize.width),
                                 (id)kCVPixelBufferHeightKey:@(self.outputSize.height)}];
}
- (void)checkAndWriteVideo {
    if (self.status == WZRecordStatusRecording) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(self.videoQueue, ^{
            @autoreleasepool {
                if (weakSelf.status != WZRecordStatusRecording) {
                    return;
                }
                // 渲染一秒钟60次，视频帧只需要一秒钟30次
                // 这里帧率60是写死的，更好的实践是获取当前渲染帧率再后做计算
                if (weakSelf.count % 2 == 0) {
                    // 获取当前渲染帧数据
                    CVPixelBufferRef pixelBuffer = [weakSelf capturePixelBuffer];
                    if (pixelBuffer) {
                        @try {
                            // 添加到录制源
                            [weakSelf.pixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:CMTimeMake(self.count/2*1000, 30*1000)];
                        }@catch (NSException *exception) {
                            NSLog(@"录制视频失败 %@",exception.reason);
                        }@finally {
                            CFRelease(pixelBuffer);
                            if (weakSelf.isFirstWriter == YES) {
                                weakSelf.isFirstWriter = NO;
                                [weakSelf recorderAudio];
                            }
                        }
                    }
                }
                weakSelf.count++;
            }
        });
    }else if (self.status == WZRecordStatusFinish) {
        // 完成录制
        self.status = WZRecordStatusIdle;
        [self.writer endSessionAtSourceTime:CMTimeMake(self.count/2, 30)];
        self.count = 0;
        [self.videoInput markAsFinished];
        [self.audioRecorder stop];
        self.isFirstWriter = YES;
        __weak typeof(self) weakSelf = self;
        [self.writer finishWritingWithCompletionHandler:^{
            CVPixelBufferPoolRelease(weakSelf.pixelBufferAdaptor.pixelBufferPool);
            weakSelf.writer = nil;
            weakSelf.videoInput = nil;
            weakSelf.pixelBufferAdaptor = nil;
            weakSelf.audioRecorder = nil;
            //合并
            [weakSelf merge];
        }];
    }
}
- (CVPixelBufferRef)capturePixelBuffer {
    UIImage *image = [self.renderer snapshotAtTime:1 withSize:CGSizeMake(self.outputSize.width, self.outputSize.height) antialiasingMode:SCNAntialiasingModeMultisampling4X];
    //    if (image) {
    //        NSLog(@"capturePixelBuffer yes");
    //    } else {
    //        NSLog(@"capturePixelBuffer NO");
    //    }
    CVPixelBufferRef pixelBuffer = NULL;
    CVPixelBufferPoolCreatePixelBuffer(NULL, [self.pixelBufferAdaptor pixelBufferPool], &pixelBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data  = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGContextRef context = CGBitmapContextCreate(data, self.outputSize.width, self.outputSize.height, 8, CVPixelBufferGetBytesPerRow(pixelBuffer), CGColorSpaceCreateDeviceRGB(),  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, self.outputSize.width, self.outputSize.height), image.CGImage);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    CGContextRelease(context);
    return pixelBuffer;
}
#pragma mark - 音频录制
//录制音频
- (void)recorderAudio {
    // 音频
    dispatch_async(self.audioQueue, ^{
        
        self.recordingSession = [AVAudioSession sharedInstance];
        
        [self.recordingSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
        
        [self.recordingSession setActive:YES error:NULL];
        
        if (![self.audioRecorder isRecording]) {
            [self.audioRecorder record];
        }
    });
}
/* 初始化录音器 */
- (AVAudioRecorder *)audioRecorder {
    if (_audioRecorder == nil) {
        
        //创建URL
        NSString *filePath = self.audioPath;
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        
        //设置录音格式
        [settings setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置录音采样率，8000是电话采样率，对于一般录音已经够了
        [settings setObject:@(8000) forKey:AVSampleRateKey];
        //设置通道,这里采用单声道
        [settings setObject:@(1) forKey:AVNumberOfChannelsKey];
        //每个采样点位数,分为8、16、24、32
        [settings setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        //是否使用浮点数采样
        [settings setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        
        //创建录音器
        NSError *error = nil;
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                     settings:settings
                                                        error:&error];
        if (error) {
            NSLog(@"初始化录音器失败");
            NSLog(@"error == %@",error);
        }
        
        _audioRecorder.delegate = self;//设置代理
        [_audioRecorder prepareToRecord];//为录音准备缓冲区
        
    }
    return _audioRecorder;
}
#pragma mark 音频 代理方法

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"音频错误");
    NSLog(@"error == %@",error);
    
}
#pragma mark - 音频 视频 合成
- (void)merge {
    
    AVMutableComposition * mixComposition = [[AVMutableComposition alloc]init];
    AVMutableCompositionTrack * mutableCompositionVideoTrack = nil;
    AVMutableCompositionTrack * mutableCompositionAudioTrack = nil;
    AVMutableVideoCompositionInstruction * totalVideoCompositionInstruction = [[AVMutableVideoCompositionInstruction alloc]init];
    
    AVURLAsset * aVideoAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.videoPath]];
    AVURLAsset * aAudioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.audioPath]];
    
    mutableCompositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    mutableCompositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    dispatch_semaphore_t videoTrackSynLoadSemaphore;
    videoTrackSynLoadSemaphore = dispatch_semaphore_create(0);
    dispatch_time_t maxVideoLoadTrackTimeConsume = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    
    [aVideoAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        dispatch_semaphore_signal(videoTrackSynLoadSemaphore);
    }];
    dispatch_semaphore_wait(videoTrackSynLoadSemaphore, maxVideoLoadTrackTimeConsume);
    
    [aAudioAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        dispatch_semaphore_signal(videoTrackSynLoadSemaphore);
    }];
    dispatch_semaphore_wait(videoTrackSynLoadSemaphore, maxVideoLoadTrackTimeConsume);
    
    NSArray<AVAssetTrack *> * videoTrackers = [aVideoAsset tracksWithMediaType:AVMediaTypeVideo];
    if (0 >= videoTrackers.count) {
        NSLog(@"VideoTracker获取失败----");
        return;
    }
    NSArray<AVAssetTrack *> * audioTrackers = [aAudioAsset tracksWithMediaType:AVMediaTypeAudio];
    if (0 >= audioTrackers.count) {
        NSLog(@"AudioTracker获取失败");
        return;
    }
    
    AVAssetTrack * aVideoAssetTrack = videoTrackers[0];
    AVAssetTrack * aAudioAssetTrack = audioTrackers[0];
    
    
    [mutableCompositionVideoTrack insertTimeRange:(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration)) ofTrack:aVideoAssetTrack atTime:kCMTimeZero error:nil];
    [mutableCompositionAudioTrack insertTimeRange:(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration)) ofTrack:aAudioAssetTrack atTime:kCMTimeZero error:nil];
    
    
    totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,aVideoAssetTrack.timeRange.duration);
    
    AVMutableVideoComposition * mutableVideoComposition = [[AVMutableVideoComposition alloc]init];
    
    mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    mutableVideoComposition.renderSize = self.outputSize;
    
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    assetExport.outputFileType = AVFileTypeAppleM4V;
    
    [[NSFileManager defaultManager] removeItemAtPath:self.outputPath error:nil];
    assetExport.outputURL = [NSURL fileURLWithPath:self.outputPath];
    //    savePathUrl;
    //    [NSURL URLWithString:self.outputPath];
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    __weak typeof(self) weakSelf = self;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        if (assetExport.error) {
            NSLog(@"合成视频和音频失败 %@",assetExport.error);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"合成视频和音频成功");
            ARWatermarkView *waterView = [[ARWatermarkView alloc] initWithFrame:weakSelf.view.bounds];
            [weakSelf.view addSubview:waterView];
            waterView.watermarkBlock = ^(NSString *type, UIImage * _Nullable image, NSString * _Nullable path) {
                if ([type isEqualToString:@"back"]) {
                    [weakSelf.audioPlayer play];
                } else {
                    NSString *type = @"video";
                    if (image) {
                        type = @"image";
                    }
                    if (weakSelf.shareBlock) {
                        weakSelf.shareBlock(type,image, path);
                    }
                }
            };
            [waterView showWithVideo:weakSelf.outputPath];
        });
        //        UISaveVideoAtPathToSavedPhotosAlbum(weakSelf.outputPath, nil, nil, nil);
        
    }];
}
#pragma mark - 开始文件判断与下载

- (void)checkIsNeedLoadFile {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        NSLog(@"有文件");
        [self.firstLoadView showLoadOverAnimation];
    } else {
        NSLog(@"无文件");
        [self startLoadFile];
    }
}
- (void)startLoadFile {
    __weak typeof(self) weakSelf = self;
    NSString *customPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"temp"];
    NSString *path = @"https://sightppp.oss-cn-shanghai.aliyuncs.com/cngold/android/TJ.zip";
    //    NSString *path = @"https://newstest.cgtn.com/training_video/TJ.zip";
    [[GSDownloadManager sharedInstance] startDownloadWithURL:[NSURL URLWithString:path] customPath:customPath firstResponse:^(NSURLResponse * _Nonnull response) {
        NSLog(@"response %@",response);
    } progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
        NSLog(@"%lf",progress);
        [weakSelf showLoadProgress:progress];
    } error:^(NSError * _Nonnull error) {
        NSLog(@"error %@",error);
        if (error) {
            [weakSelf.errorView showErrorView];
        }
    } complete:^(BOOL downloadFinished, NSString * _Nonnull pathToFile) {
        NSLog(@"error %@",pathToFile);
        [SSZipArchive unzipFileAtPath:pathToFile toDestination:self.filePath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
            if (succeeded) {
                [weakSelf loadOver];
            } else {
                [weakSelf.errorView showErrorView];
            }
        }];
    }];
}

- (void)dealloc {
    NSLog(@"==========ARkitViewController delloc=========");
}


@end
