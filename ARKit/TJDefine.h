//
//  TJDefine.h
//  helloarscene
//
//  Created by YangTengJiao on 2018/6/8.
//  Copyright © 2018年 VisionStar Information Technology (Shanghai) Co., Ltd. All rights reserved.
//

#ifndef TJDefine_h
#define TJDefine_h

//重写NSLog,Debug模式下打印日志和当前行数
//#if DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\nNSLog:%s line:%d %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif

#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults      [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define ScreenTJSize [UIScreen mainScreen].bounds.size
#define ScreenTJHeight [UIScreen mainScreen].bounds.size.height
#define ScreenTJWidth [UIScreen mainScreen].bounds.size.width
#define WidthTJ(obj)   (!obj?0:(obj).frame.size.width)
#define HeightTJ(obj)   (!obj?0:(obj).frame.size.height)
#define XTJ(obj)   (!obj?0:(obj).frame.origin.x)
#define YTJ(obj)   (!obj?0:(obj).frame.origin.y)
#define XWidthTJ(obj) (X(obj)+W(obj))
#define YHeightTJ(obj) (Y(obj)+H(obj))
//获取图片资源
//#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
//颜色
#define RGBATJ(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGBTJ(r,g,b) RGBATJ(r,g,b,1.0f)
#define ClearColorTJ [UIColor clearColor]
//随机颜色
#define RandomColorTJ [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//强弱引用
#define WeakSelfTJ(type)  __weak typeof(type) weak##type = type;
#define StrongSelfTJ(type)  __strong typeof(type) strong##type = type;
//发送通知
#define PostNotificationTJ(name,userInfo) ({\
dispatch_async(dispatch_get_main_queue(), ^{\
[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];\
});})
//接收通知
#define GetNotificationTJ(name,action) ({\
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:name object:nil];\
})
//创建Label
#define CreatLabelTJ(frame, title, font, textColor, bgColor, textAlignment) ({\
UILabel *label = [[UILabel alloc]initWithFrame:frame];\
if (title) {\
label.text = title;\
}\
if (font) {\
label.font = font;\
}\
if (textColor) {\
label.textColor = textColor;\
}\
if (bgColor) {\
label.backgroundColor = bgColor;\
}\
if (textAlignment) {\
label.textAlignment = textAlignment;\
}\
label;\
})
//创建Button
#define CreatButtonTJ(frame,title,font,titleColor,bgColor,image,bgImage) ({\
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
button.frame = frame;\
if (title) {\
    [button setTitle:title forState:UIControlStateNormal];\
} else {\
    [button setTitle:@"" forState:UIControlStateNormal];\
}\
if (font) {\
    button.titleLabel.font = font;\
}\
if (titleColor) {\
    [button setTitleColor:titleColor forState:UIControlStateNormal];\
}\
if (bgColor) {\
    button.backgroundColor = bgColor;\
}\
if (image) {\
    [button setImage:image forState:UIControlStateNormal];\
}\
if (bgImage) {\
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];\
}\
button;\
});
//设置圆角
#define ViewRadiusTJ(View, Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]
//设置边框
#define ViewBorderTJ(View,Width,Color)\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
//角度弧度转化
#define DegreesToRadianTJ(x) (M_PI * (x) / 180.0)
#define RadianToDegreesTJ(radian) (radian*180.0)/(M_PI)
//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
//判断机型是否为iphonex
#define KIsiPhoneX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})
#define kIphoneXStatusBarHeight (KIsiPhoneX?44:20)
#define KIphoneXbottomHeight (KIsiPhoneX?34:0) // 适配iPhone x 底部提升高度
//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))
//获取根目录
#define kPathHome NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//获取字符串宽度
#define GetStingWidth(text,font) ({\
CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];\
size.width;\
})
//获取字符串高度
#define GetStingHeight(text,width,font) ({\
CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil].size;\
size.height;\
})
//获取语言环境
// zh-Hans是简体中文，zh-Hant是繁体中文  en英语
#define GetLanguage ({\
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];\
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];\
    NSString * preferredLang = [allLanguages objectAtIndex:0];\
    if ([preferredLang isEqualToString:@"zh-Hans-CN"] || [preferredLang isEqualToString:@"zh-Hans"]) {\
        return @"zh_cn";\
    } else if ([preferredLang isEqualToString:@"zh-Hant-CN"] || [preferredLang isEqualToString:@"zh-Hant"]) {\
        return @"zh_tw";\
    } else {\
        return @"en_us";\
    }\
})


#define KIsEnglishLaunge (![[NSUserDefaults standardUserDefaults] boolForKey:@"arKIsEnglishLaungeLanguage"])
#define KSetIsEnglishLaunge(bool) ({\
[[NSUserDefaults standardUserDefaults] setBool:!bool forKey:@"arKIsEnglishLaungeLanguage"];\
[[NSUserDefaults standardUserDefaults] synchronize];\
})
//static BOOL KIsEnglishLaunge = YES;

//移动端iphonex英文换中文
//英文——中文
//24——24
//18——16
//12——12
//
//移动端iphone8英文换中文
//英文——中文
//24——24
//18——16
//12——12
//字体大小
//#define BoldFontTJ(x) [UIFont boldSystemFontOfSize:x]
//#define FontTJ(x) [UIFont systemFontOfSize:x]
#define BoldFontTJ(x) ({ UIFont *font = [UIFont fontWithName:@"Montserrat-Bold" size:x];\
if (KIsEnglishLaunge == NO  && x == 18) {\
font = [UIFont fontWithName:@"Montserrat-Bold" size:16];\
}\
font;\
})

#define FontTJ(x) ({ UIFont *font = [UIFont fontWithName:@"Montserrat-Light" size:x];\
if (KIsEnglishLaunge == NO  && x == 18) {\
    font = [UIFont fontWithName:@"Montserrat-Light" size:16];\
}\
font;\
})

#define kARFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"arInfo"]
#define kGetARImage(name) ({\
NSString *path = [kARFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@.png",name]];\
UIImage *img = [UIImage imageWithContentsOfFile:path];\
if (!img) {\
path = [kARFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];\
img = [UIImage imageWithContentsOfFile:path];\
}\
if (!img) {\
    path = [kARFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@@3x.png",name]];\
    img = [UIImage imageWithContentsOfFile:path];\
}\
if (!img) {\
    path = [kARFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@@2x.png",name]];\
    img = [UIImage imageWithContentsOfFile:path];\
}\
if (!img) {\
    img = [UIImage imageNamed:name];\
}\
img;\
})

#define kFirstLoadTitle (KIsEnglishLaunge?@"Welcome to\nBeijing Daxing\nInternational Airport":@"欢迎来到\n北京大兴国际机场")
#define kFirstLoadExplain (KIsEnglishLaunge?@"China's aviation industry is set to take off with the state-of-the-art Beijing Daxing International Airport.":@"随着大兴机场的投入使用，中国的航空工业将迈上了新台阶。")
#define kTipsTitle (KIsEnglishLaunge?@"This is an immersive AR experience":@"本产品将带来AR沉浸式体验")
#define kTipsBottom (KIsEnglishLaunge?@"Tap to enter AR immersive experience":@"点击进入AR沉浸式体验")
#define kScanPlane (KIsEnglishLaunge?@"Point your device\ntowards a flat surface":@"将摄像头对准\n一个有纹理的平面")
#define kTapModel (KIsEnglishLaunge?@"Tap to place\nthe terminal building":@"点击平面放置模型")
#define kResetTapModel (KIsEnglishLaunge?@"Double tap to replace\nthe terminal building":@"点击平面放置模型")
#define kAudioPlayerFirst (KIsEnglishLaunge?@"Please use earphones":@"带上耳机")
#define kAudioPlayerButton (KIsEnglishLaunge?@"Skip intro":@"Skip intro")

#define KWatermarkPrompt (KIsEnglishLaunge?@"Get your boarding pass. Destination: Beijing!":@"点击生成你的登机牌  目的地：北京")
#define KWatermarkNameLabel (KIsEnglishLaunge?@"WHAT’S YOUR NAME ?":@"WHAT’S YOUR NAME ?")
#define KWatermarkNameText (KIsEnglishLaunge?@"NAME":@"NAME")
#define KWatermarkFromLabel (KIsEnglishLaunge?@"Where are you from?":@"Where are you from?")
#define KWatermarkNext (KIsEnglishLaunge?@"NEXT":@"NEXT")


#define KBottomPromptTop (KIsEnglishLaunge?@"Move closer to the terminal building to step inside and experience Daxing Airport":@"靠近航站楼，带你360度玩转大兴国际机场")
#define KBottomPromptleft (KIsEnglishLaunge?@"In-depth data analysis":@"机场数据")
#define KBottomPromptRight (KIsEnglishLaunge?@"Collection of personal stories":@"机场故事")
#define KBottomPromptCenter (KIsEnglishLaunge?@"Tap to take photo\nLong press to  take video":@"点击拍照\n长按录像")
#define KBottomPromptTop2 (KIsEnglishLaunge?@"Pinch to zoom in/out\nLong-press to move\nterminal building":@"捏住放大/缩小\n长按来移动航站楼")
#define kPanoramaballcenter (KIsEnglishLaunge?@"Move your phone for a 360° view":@"移动手机进入360°全景模式")
#define kPanoramaballbottom (KIsEnglishLaunge?@"Step back to exit 360° mode":@"退出360°全景模式")
#define kPanoramaballprompt (KIsEnglishLaunge?@"预设提示":@"预设提示")

#define kLocation (KIsEnglishLaunge?@"Location":@"地理方位")
#define kTerminal (KIsEnglishLaunge?@"Terminal":@"航站楼")
#define kTerminal1 (KIsEnglishLaunge?@"Terminal complex area:":@"航站楼综合体:")
#define kTerminal2 (KIsEnglishLaunge?@"1.42 million square meters":@"142万平方米")
#define kRunways (KIsEnglishLaunge?@"Runways":@"跑道")

#define kToastPan (KIsEnglishLaunge?@"选择的地点过近，请投放距离远一点":@"选择的地点过近，请投放距离远一点")
#define kToastBack (KIsEnglishLaunge?@"请距离模型有一定距离，才可以退出全景球":@"请距离模型有一定距离，才可以退出全景球")

#define kAudioPlayerCenter1 @"Beijing Daxing International Airport covers a huge expanse to the south of Beijing"//0-6
#define kAudioPlayerCenter2 @"with one of the largest terminal buildings in the world at 700,000 square meters"//6-11
#define kAudioPlayerCenter3 @"Its four runways will allow it to handle up to 72 million passengers by 2025"//11-19
#define kAudioPlayerCenter4 @"The airport is conveniently located close to Beijing city center"//19-22
#define kAudioPlayerCenter5 @"as well as the center of the Jing-Jin-Ji region"//22-25
#define kAudioPlayerCenter6 @"a metropolitan cluster consisting of Beijing, Tianjin and Hebei Province."//26-31
#define kAudioPlayerCenter7 @"More than just an airport, it will be a key travel hub,"//31-36
#define kAudioPlayerCenter8 @"connecting China's road and high-speed rail network."//37-39

#define kAudioPlayerCenterZH1 @"北京大兴国际机场位于永定河北岸"//0-3
#define kAudioPlayerCenterZH2 @"距天安门直线距离约46公里"//4-6
#define kAudioPlayerCenterZH3 @"其航站楼占地⾯积70万平方米"//7-9
#define kAudioPlayerCenterZH4 @"一期工程建设4条跑道"//10-12
#define kAudioPlayerCenterZH5 @"是目前世界吞吐量最大的单体航站楼"//13-15
#define kAudioPlayerCenterZH6 @"将实现2025年年旅客吞度量达到7200万人次的设计⽬标"//16-21
#define kAudioPlayerCenterZH7 @"同时，新机场形成了集航空，⾼铁，城际，地铁，⾼速公路多种运输方式为一体的互联互通交通网络"//22-31
#define kAudioPlayerCenterZH8 @"其中链接中⼼城区和北京⼤兴国际机场的快速轨道交通专线"//32-37
#define kAudioPlayerCenterZH9 @"半小时便可直达北京中心城区"//38-40
#define kAudioPlayerCenterZH10 @"此外，机场地处京津冀核心区域"//41-43
#define kAudioPlayerCenterZH11 @"将加速带动京津冀协同发展"//44-46
#define kAudioPlayerCenterZH12 @"有序疏解北京⾮首都功能"//47-49
#define kAudioPlayerCenterZH13 @"成为⼜一城市新地标"//50-52


#define KCheckPushButton (KIsEnglishLaunge?@"Continue without AR immersive experience.":@"点击进入H5页面")
#define KCheckCenterText1 (KIsEnglishLaunge?@"For a better experience, use an AR supported device. ":@"为了更好体验，请使用支持AR功能的设备")
#define KCheckCenterText2 (KIsEnglishLaunge?@"For a better experience, upgrade the CGTN app.":@"为了更好体验，请升级CGTN客户端")
#define KCheckCenterText3 (KIsEnglishLaunge?@"For a better experience, allow camera permission.":@"为了更好体验，请允许访问手机相机")


#endif /* TJDefine_h */
