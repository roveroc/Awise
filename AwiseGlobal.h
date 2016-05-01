//
//  AwiseGlobal.h
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePingHelper.h"
#import "ScanLAN.h"
#import "RoverARP.h"
#import <MBProgressHUD.h>
#import "AwiseUserDefault.h"
#import "TCPCommunication.h"

#define AwiseDataBase            @"AwiseDeivce.sqlite"              //数据库
#define AwiseSingleTouchTimer    @"SingleTouchTimer.plist"          //单色触摸面板定时器数据存储文件

#define HudDismissTime           1.5                                //提示框消失的时间

//******************* ******************* *******************
//判断iPhone4/iPhone4S
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone5/iPhone5S
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6Plus
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1472), [[UIScreen mainScreen] currentMode].size) : NO)
//******************* ******************* *******************

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDHT [[UIScreen mainScreen] bounds].size.width

@protocol PingDelegate <NSObject>

- (void)ipIsOnline:(BOOL)result;         //目标IP是否在线
- (void)scanNetworkFinish;               //扫码局域网完成

@end



@interface AwiseGlobal : NSObject <SimplePingDelegate,PingDelegate,ScanLANDelegate>{
    NSMutableArray              *singleTouchTimerArray;
    id<PingDelegate>            delegate;
    ScanLAN                     *scan;
    RoverARP                    *arp;
    MBProgressHUD               *hud;
    TCPCommunication            *tcpSocket;
}



@property (nonatomic, retain) NSMutableArray            *singleTouchTimerArray;         //单色触摸面板定时器数据
@property (nonatomic, retain) id<PingDelegate>          delegate;                       //delegate
@property (nonatomic, retain) ScanLAN                   *scan;                          //扫描局域网IP对象
@property (nonatomic, retain) RoverARP                  *arp;                           //获取手机ARP表对象
@property (nonatomic, retain) MBProgressHUD             *hud;                           //提示用户等待View
@property (nonatomic, retain) TCPCommunication          *tcpSocket;                     //tcpSocket


+ (AwiseGlobal *)sharedInstance;

- (NSString *)getFilePath:(NSString *)fileName;                        //获取文件路径 （将【沙盒的.app】复制到【沙盒的document】）
- (NSString *)convertWeekDayToString:(NSString *)str;                  //将0/1代表星期的字符串转化成周一、周二等字符串
- (void)pingIPisOnline:(NSString *)ip;                                 //判断一个IP是否能Ping通
- (void)scanNetwork;                                                   //遍历局域网I
- (NSMutableDictionary *)getARPTable;                                  //获取ARP表
- (void)showWaitingView;                                               //展示提示用户等待
- (void)showWaitingViewWithMsg:(NSString *)msg;                        //展示提示用户等待，带文字提示

@end
