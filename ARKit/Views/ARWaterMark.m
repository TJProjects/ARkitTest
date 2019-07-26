//
//  ARWaterMark.m
//  CGTN
//
//  Created by YangTengJiao on 2019/5/28.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARWaterMark.h"

@implementation ARWaterMark
// 给图片添加文字水印：
+ (UIImage *)markWaterImageWithImage:(UIImage *)image name:(NSString *)name from:(NSString *)from hour:(NSString *)hour year:(NSString *)year{
    UIImage *bottomImage = kGetARImage(@"机票水印");
    float scale = (image.size.width/375.0);
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
//    NSLog(@"%@",image);
//    NSLog(@"%@",bottomImage);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //底部蓝色背景
    [bottomImage drawInRect:CGRectMake(0, image.size.height - image.size.width*(180.0/375.0), image.size.width, image.size.width*(180.0/375.0))];
    //添加水印文字
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attribute0=@{
                              NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:18*scale],
                              //                              [UIFont systemFontOfSize:18*scale weight:3.0],
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSParagraphStyleAttributeName:paragraph
                              };
    [name drawWithRect:CGRectMake(25*scale,image.size.height-75*scale-7*scale-24*scale,95*scale,24*scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute0 context:nil];
    
    NSDictionary *attribute1=@{
                              NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:18*scale],
//                              [UIFont systemFontOfSize:18*scale weight:3.0],
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSParagraphStyleAttributeName:paragraph
                              };
    [from drawWithRect:CGRectMake(120*scale,image.size.height-75*scale-7*scale-24*scale,82*scale,24*scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute1 context:nil];
    
    NSDictionary *attribute2=@{
                               NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:12*scale],
                               NSForegroundColorAttributeName:[UIColor blackColor],
                               NSParagraphStyleAttributeName:paragraph
                               };
    [hour drawWithRect:CGRectMake(25*scale,image.size.height-45*scale-20*scale,95*scale,20*scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute2 context:nil];
    
    NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
    paragraph2.alignment = NSTextAlignmentRight;
    NSDictionary *attribute3=@{
                               NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:12*scale],
                               NSForegroundColorAttributeName:[UIColor whiteColor],
                               NSParagraphStyleAttributeName:paragraph2
                               };
    [year drawWithRect:CGRectMake(120*scale,image.size.height-45*scale-20*scale,150*scale,20*scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute3 context:nil];
    
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}
+ (void)markWaterImageWithVideo:(NSString *)path name:(NSString *)name from:(NSString *)from hour:(NSString *)hour year:(NSString *)year completionHandler:(void (^)(NSURL* outPutURL, int code))handler {
    NSError* trackError = nil;
    //1 创建AVAsset实例
    AVURLAsset*videoAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //3 视频通道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject]
                         atTime:kCMTimeZero error:&trackError];
    NSLog(@"trackError %@",trackError);
    //2 音频通道
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject]
                         atTime:kCMTimeZero error:&trackError];
    NSLog(@"trackError %@",trackError);
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];

    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    //AVMutableVideoComposition：管理所有视频轨道，水印添加就在这上面
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize naturalSize = videoAssetTrack.naturalSize;
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    
//    设置水印及其对应视频的位置
    float scale = (naturalSize.width/375.0);
//    NSLog(@"naturalSize %f %f %f",naturalSize.width,naturalSize.height,scale);
    //图片
    CALayer*picLayer = [CALayer layer];
    picLayer.contents = (id)kGetARImage(@"机票水印").CGImage;
    picLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.width*(180.0/375.0));
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:picLayer];
    overlayLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
    [overlayLayer setMasksToBounds:YES];
    
    CATextLayer *nameLayer = [[CATextLayer alloc] init];
    [nameLayer setFont:(__bridge CFTypeRef)[UIFont fontWithName:@"Montserrat-Bold" size:18*scale].fontName];
    [nameLayer setFontSize:18*scale];
    [nameLayer setString:name];
    [nameLayer setAlignmentMode:kCAAlignmentCenter];
    [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    [nameLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [nameLayer setFrame:CGRectMake(25*scale,75*scale+7*scale,95*scale,24*scale)];
    
    CATextLayer *formLayer = [[CATextLayer alloc] init];
    [formLayer setFont:(__bridge CFTypeRef)[UIFont fontWithName:@"Montserrat-Bold" size:18*scale].fontName];
    [formLayer setFontSize:18*scale];
    [formLayer setString:from];
    [formLayer setAlignmentMode:kCAAlignmentCenter];
    [formLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    [formLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [formLayer setFrame:CGRectMake(120*scale,75*scale+7*scale,82*scale,24*scale)];
    
    CATextLayer *hourLayer = [[CATextLayer alloc] init];
    [hourLayer setFont:(__bridge CFTypeRef)[UIFont fontWithName:@"Montserrat-Bold" size:12*scale].fontName];
    [hourLayer setFontSize:12*scale];
    [hourLayer setString:hour];
    [hourLayer setAlignmentMode:kCAAlignmentCenter];
    [hourLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    [hourLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [hourLayer setFrame:CGRectMake(25*scale,45*scale+0*scale,95*scale,20*scale)];
    
    CATextLayer *yearLayer = [[CATextLayer alloc] init];
    [yearLayer setFont:(__bridge CFTypeRef)[UIFont fontWithName:@"Montserrat-Bold" size:12*scale].fontName];
    [yearLayer setFontSize:12*scale];
    [yearLayer setString:year];
    [yearLayer setAlignmentMode:kCAAlignmentRight];
    [yearLayer setForegroundColor:[[UIColor whiteColor] CGColor]];
    [yearLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [yearLayer setFrame:CGRectMake(120*scale,45*scale+0*scale,150*scale,20*scale)];
    
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
    videoLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:picLayer];
    [parentLayer addSublayer:nameLayer];
    [parentLayer addSublayer:formLayer];
    [parentLayer addSublayer:hourLayer];
    [parentLayer addSublayer:yearLayer];
    
    mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    //    // 4 - 输出路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
//                             [NSString stringWithFormat:@"FinalVideo-%d.mp4",arc4random() % 1000]];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])  {
//        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
//    }
//    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    // 4 - 输出路径
    NSURL *videoUrl = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"suiyin.mp4"]];
    [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"suiyin.mp4"] error:nil];

    exporter.outputURL = videoUrl;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = NO;
    exporter.videoComposition = mainCompositionInst;
    NSLog(@"水印添加 开始");
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( exporter.status == AVAssetExportSessionStatusCompleted ){
                NSLog(@"水印添加 完成");
                handler(videoUrl,(int)exporter.error.code);
//                UISaveVideoAtPathToSavedPhotosAlbum([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"suiyin.mp4"], nil, nil, nil);
            }else if( exporter.status == AVAssetExportSessionStatusFailed )
            {
                handler(videoUrl,(int)exporter.error.code);
                NSLog(@"水印添加 失败 %ld %@",exporter.error.code,exporter.error);
            }
            
        });
    }];
}

@end
