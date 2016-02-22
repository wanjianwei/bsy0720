//
//  ZCAudioTool.m
//  06-音频播放器
//
//  Created by 塔利班 on 14/12/5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "ZCAudioTool.h"
#import "NSString+Extension.h"
#import <UIKit/UIKit.h>

@interface ZCAudioTool () <AVAudioPlayerDelegate>
/** 保存音效soundID的字典 */
@property (nonatomic, strong) NSMutableDictionary *soundIds;
/** 保存文件目录下的soundId字典 */
@property (nonatomic, strong) NSMutableDictionary *directorySoundIds;
/** 保存音频播放器的字典 */
@property (nonatomic, strong) NSMutableDictionary *musics;
/** 保存文件目录下音频文件播放器的字典 */
@property (nonatomic, strong) NSMutableDictionary *directoryMusics;
@end

@implementation ZCAudioTool

/** 单例实现代码 */
SingletonImplementation(ZCAudioTool)

/** 注册内存警告通知 */
- (instancetype)init
{
    if (self = [super init]) {
        /**注册内存警告通知**/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

/** 接受到内存警告 */
- (void)receiveMemoryWarning
{
    // 清空所有的音效
    NSArray *soundIdsArr = [_soundIds allValues];
    for (NSNumber *soundId in soundIdsArr) {
        SystemSoundID soundID = [soundId unsignedIntValue];
        AudioServicesDisposeSystemSoundID(soundID);
    }
    [_soundIds removeAllObjects];
    
    // 清空文件中的音效
    NSArray *directorySoundIdsArr = [_directorySoundIds allValues];
    for (NSMutableDictionary *dict in directorySoundIdsArr) {
        for (NSNumber *soundId in [dict allValues]) {
            SystemSoundID soundID = [soundId unsignedIntValue];
            AudioServicesDisposeSystemSoundID(soundID);
        }
    }
    [_directorySoundIds removeAllObjects];
    
    
    // 清空所有音频播放器
    [_musics removeAllObjects];
    // 清空文件中的播放器
    [_directoryMusics removeAllObjects];
}

#pragma mark - 音效部分
/** 保存音效soundID的字典 */
- (NSMutableDictionary *)soundIds
{
    if (_soundIds == nil) {
        _soundIds = [NSMutableDictionary dictionary];
#if !__has_feature(objc_arc)
        [_soundIds retain];
#endif
    }
    return _soundIds;
}

/** 保存文件目录下的soundId字典 */
- (NSMutableDictionary *)directorySoundIds
{
    if (_directorySoundIds == nil) {
        _directorySoundIds = [NSMutableDictionary dictionary];
#if !__has_feature(objc_arc)
        [_directorySoundIds retain];
#endif
    }
    return _directorySoundIds;
}

/**
 *  播放声音片段
 */
- (void)playSoundWithSoundName:(NSString *)soundName
{
    /**播放声音片段**/
    SystemSoundID soundId = [self.soundIds[soundName] unsignedIntValue];
    if (soundId) {
        AudioServicesPlaySystemSound(soundId);
    }else{
        [self loadSoundWithSoundName:soundName];
    }
}

- (SystemSoundID)loadSoundWithSoundName:(NSString *)soundName
{
    /**创建声音片段**/
    SystemSoundID soundId = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundId);
    AudioServicesPlaySystemSound(soundId);
    self.soundIds[soundName] = @(soundId);
    return soundId;
}

/**
 *  播放目录文件下的声音片段
 */
- (void)playSoundWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory
{
    /**播放目录文件下的声音片段**/
    NSMutableDictionary *dict = self.directorySoundIds[subdirectory];
    if (dict) {
        SystemSoundID soundId = [dict[directory] unsignedIntValue];
        if (soundId) {
            AudioServicesPlaySystemSound(soundId);
        }else{
            [self loadSoundWithDirectory:directory subdirectory:subdirectory];
        }
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        self.directorySoundIds[subdirectory] = dict;
        [self loadSoundWithDirectory:directory subdirectory:subdirectory];
    }
}

- (SystemSoundID)loadSoundWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory
{
    /**加载某个目录下的声音片段**/
    SystemSoundID soundId = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:directory withExtension:nil subdirectory:subdirectory];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundId);
    NSMutableDictionary *dict = self.directorySoundIds[subdirectory];
    dict[directory] = @(soundId);
//    NSLog(@"%@", dict);
    AudioServicesPlaySystemSound(soundId);
    return soundId;
}

#pragma mark - 音频部分

- (NSMutableDictionary *)musics
{
    if (_musics == nil) {
        _musics = [NSMutableDictionary dictionary];
#if !__has_feature(objc_arc)
        [_musics retain];
#endif
    }
    return _musics;
}

/** 播放音频 */
- (void)playAudioWithAudioName:(NSString *)audioName
{
    // 文件名不能为空
    if (!audioName) return;
    
    // 取出对应的音频播放器
    AVAudioPlayer *player = self.musics[audioName];
    
    // 如果播放器不存在，创建播放器
    if (!player) {
        // 音频文件url
        NSURL *url = [[NSBundle mainBundle] URLForResource:audioName withExtension:nil];
        
        // 如果音频文件不存在，结束方法
        if (!url) return;
        
        // 创建对应音频文件的播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        
        // 无法缓冲，退出方法
        if (![player prepareToPlay]) return;
        
        // 将播放器放入播放器字典
        self.musics[audioName] = player;
    }
    
    // 正在播放，结束方法
    if (player.isPlaying) return;
    
    // 不是正在播放，播放器开始播放
    [player play];
}

/** 暂停音频 */
- (void)pauseWithAudioName:(NSString *)audioName
{
    // 没有传入音频文件名
    if (!audioName) return;
    
    // 取出对应音频文件的播放器
    AVAudioPlayer *player = self.musics[audioName];
    
    // 播放器不存在，结束方法
    if (!player) return;
    
    // 如果正在播放，暂停播放器
    if (player.isPlaying) {
        [player pause];
    }
}

/** 停止音频 */
- (void)stopWithAudioName:(NSString *)audioName
{
    // 没有传入音频文件名
    if (!audioName) return;
    
    // 取出对应的音频文件播放器
    AVAudioPlayer *player = self.musics[audioName];
    
    // 播放器不存在，结束方法
    if (!player) return;
    
    // 停止这个播放器
    [player stop];
    
    // 将播放器移除字典
    [self.musics removeObjectForKey:audioName];
}

- (NSMutableDictionary *)directoryMusics
{
    if (_directoryMusics == nil) {
        _directoryMusics = [NSMutableDictionary dictionary];
#if !__has_feature(objc_arc)
        [_directoryMusics retain];
#endif
    }
    return _directoryMusics;
}

/** 播放某目录下的音频文件 */
- (void)playAudioWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory
{
    // 文件夹不存在，结束方法
    if (!subdirectory) return;
    
    // 文件不存在，结束方法
    if (!directory) return;
    
    // 取出对应的播放器
    AVAudioPlayer *player = self.directoryMusics[subdirectory][directory];
    
    // 播放器不存在，创建播放器
    if (!player) {
        // 创建url
        NSURL *url = [[NSBundle mainBundle] URLForResource:directory withExtension:nil subdirectory:subdirectory];
        
        // 文件不存在，结束方法
        if (!url) return;
        
        // 创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        
        // 无法缓冲，结束方法
        if (![player prepareToPlay]) return;
        
        // 可以缓冲，保存播放器进字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[directory] = player;
        self.directoryMusics[subdirectory] = dict;
    }
    
    // 如果正在播放，结束方法
    if ([player isPlaying]) return;
    
    // 如果没有正在播放，开始播放
    [player play];
}

/** 暂停某目录下的音频文件 */
- (void)pauseAudioWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory
{
    // 文件夹不存在，结束方法
    if (!subdirectory) return;
    
    // 文件不存在，结束方法
    if (!directory) return;
    
    // 取出对应的播放器
    AVAudioPlayer *player = self.directoryMusics[subdirectory][directory];
    
    // 播放器不存在，结束方法
    if (!player) return;
    
    // 正在播放状态，暂停
    if ([player isPlaying]) {
        [player pause];
    }
}

/** 停止某目录下的音频文件 */
- (void)stopAudioWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory
{
    // 文件夹不存在，结束方法
    if (!subdirectory) return;
    
    // 文件不存在，结束方法
    if (!directory) return;
    
    // 取出对应的播放器
    AVAudioPlayer *player = self.directoryMusics[subdirectory][directory];
    
    // 播放器不存在，结束方法
    if (!player) return;
    
    // 停止播放器
    [player stop];
    
    // 从字典中移除播放器
    [self.directoryMusics[subdirectory] removeObjectForKey:directory];
}

- (id)initSystemShake
{
    self = [super init];
    if (self) {
        _sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&_sound);
            
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                _sound = 0;
            }
        }
    }
    return self;
}

- (void)play
{
    AudioServicesPlaySystemSound(self.sound);
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com