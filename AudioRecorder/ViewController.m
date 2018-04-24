//
//  ViewController.m
//  AudioRecorder
//
//  Created by builder on 2018/4/24.
//  Copyright © 2018年 builder. All rights reserved.
//

#import "ViewController.h"
#import "AudioRecorder.h"

@interface ViewController ()<AudioRecorderDelegate>

@property (nonatomic,strong) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.progressView.progress = 0;
}

#pragma mark - path

- (NSString *)getFilePathWithFileName:(NSString *)fileName{
    NSString * filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}


#pragma mark - btn action
//开始录音
- (IBAction)startRecordBtnAction:(id)sender{
    self.progressView.progress = 0;
    [[AudioRecorder shareInstance] startRecordWithFilePath:[self getFilePathWithFileName:@"record.caf"]];
    [[AudioRecorder shareInstance] setRecorderDelegate:self];
}
//结束录音
- (IBAction)stopRecordBtnAction:(id)sender{
    self.progressView.progress = 0;
    [[AudioRecorder shareInstance] stopRecord];
}
//播放录音
- (IBAction)playRecordBtnAction:(id)sender{
    //由于录音配置那里设置了是pcm，avaudioplayer播放器是播放不了的，需要加头部变成wav才能播放，此处不使用avaudioplayer
    //直接使用系统铃声的接口播放录音，30秒内还是可以播放的,不过要第二次运行才出声音，原因未明
    
    NSURL * url = [NSURL fileURLWithPath:[self getFilePathWithFileName:@"record.caf"]];
    SystemSoundID soundID;
    /*根据声音的路径创建ID    （__bridge在两个框架之间强制转换类型，值转换内存，不修改内存管理的
     权限）在转换数据类型的时候，不希望该对象的内存管理权限发生改变，原来是MRC类型，转换了还是 MRC。*/
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    //播放音频
    AudioServicesPlayAlertSound(soundID);
    //添加震动，只有在iphone上才可以，模拟器没有效果。
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    
}

#pragma mark - AudioRecorderDelegate
//音量
- (void)audioRecorderDidVoiceChanged:(AudioRecorder *)recorder value:(double)value{
    self.progressView.progress = value;
}
//录音完成
- (void)audioRecorderDidFinished:(AudioRecorder *)recorder successfully:(BOOL)flag{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
