//
//  ZCAudioTool.h
//  06-音频播放器
//
//  Created by 塔利班 on 14/12/5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
// 系统音效详细列表
/**
 信息
 ReceivedMessage.caf--收到信息，仅在短信界面打开时播放。
 sms-received1.caf-------三全音
 sms-received2.caf-------管钟琴
 sms-received3.caf-------玻璃
 sms-received4.caf-------圆号
 sms-received5.caf-------铃声
 sms-received6.caf-------电子乐
 SentMessage.caf--------发送信息
 
 邮件
 mail-sent.caf----发送邮件
 new-mail.caf-----收到新邮件
 
 电话
 dtmf-0.caf----------拨号面板0按键
 dtmf-1.caf----------拨号面板1按键
 dtmf-2.caf----------拨号面板2按键
 dtmf-3.caf----------拨号面板3按键
 dtmf-4.caf----------拨号面板4按键
 dtmf-5.caf----------拨号面板5按键
 dtmf-6.caf----------拨号面板6按键
 dtmf-7.caf----------拨号面板7按键
 dtmf-8.caf----------拨号面板8按键
 dtmf-9.caf----------拨号面板9按键
 dtmf-pound.caf---拨号面板＃按键
 dtmf-star.caf------拨号面板*按键
 Voicemail.caf-----新语音邮件
 
 输入设备声音提示
 Tock.caf-----------------------点击键盘
 begin_record.caf-----------开始录音
 begin_video_record.caf--开始录像
 photoShutter.caf------------快门声
 end_record.caf--------------结束录音
 end_video_record.caf-----结束录像
 
 其他
 beep-beep.caf--充电、注销及连接电脑
 lock.caf------------锁定手机
 shake.caf---------“这个还没搞清楚”
 unlock.caf--------滑动解锁
 low_power.caf--低电量提示
 
 语音控制
 jbl_ambiguous.caf--找到多个匹配
 jbl_begin.caf------等待用户的输入
 jbl_cancel.caf-----取消
 jbl_confirm.caf----执行
 jbl_no_match.caf---没有找到匹配
 
 日历
 alarm.caf--日历提醒
 
 iPod Touch 1G
 sq_alarm.caf
 sq_beep-beep.caf 
 sq_lock.caf 
 sq_tock.caf
 */

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ZCAudioTool : NSObject
@property (nonatomic, assign) SystemSoundID sound;

SingletonInterface(ZCAudioTool)

/**  播放声音片段  */
- (void)playSoundWithSoundName:(NSString *)soundName;
/**  播放某个目录下的声音片段声音片段  */
- (void)playSoundWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory;

/** 播放音频 */
- (void)playAudioWithAudioName:(NSString *)audioName;
/** 播放某目录下的音频文件 */
- (void)playAudioWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory;

/** 暂停音频 */
- (void)pauseWithAudioName:(NSString *)audioName;
/** 暂停某目录下的音频文件 */
- (void)pauseAudioWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory;

/** 停止音频 */
- (void)stopWithAudioName:(NSString *)audioName;
/** 停止某目录下的音频文件 */
- (void)stopAudioWithDirectory:(NSString *)directory subdirectory:(NSString *)subdirectory;
/** 系统 震动 */
- (id)initSystemShake;
/** 初始化系统声音 */
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;
/** 播放系统声音 */
- (void)play;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com