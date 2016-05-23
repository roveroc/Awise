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
#import "GBPing.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#define BLE_SERVICE_NAME         @"AwiseLight"
#define UUIDSTR_ISSC_PROPRIETARY_SERVICE    @"FFF0"
#define AwiseDataBase            @"AwiseDeivce.sqlite"              //数据库
#define AwiseSingleTouchTimer    @"SingleTouchTimer.plist"          //单色触摸面板定时器数据存储文件

#define HudDismissTime           0.5                                //提示框消失的时间

//******************* ******************* *******************
//判断iPhone4/iPhone4S
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone5/iPhone5S
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6Plus
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//******************* ******************* *******************

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDHT [[UIScreen mainScreen] bounds].size.width

/*******水族等部分********/
#define SENDPORT    5000                   //发送数据端口
#define BroadCast   @"255.255.255.255"     //广播地址
#define WAITTIME    2.0
#define DISMISS_TIME 1.5
#define WIFISSID    @"Awise"

typedef enum{
    Manual_Model = 0,
    Lighting_Model,
    Cloudy_Model,
    Timer1_Model,
    Timer2_Model,
    Timer3_Model
}DeviceMode;
/*******水族等部分********/


typedef enum {                          //设备控制方式  <AP：点对点模式> <STA：路由模式>
    AP =0,
    STA,
    Other                               //Other 表示无网络连接
}ControlMode;

@protocol PingDelegate <NSObject>

- (void)ipIsOnline:(BOOL)result;         //目标IP是否在线
- (void)scanNetworkFinish;               //扫码局域网完成

@end



@interface AwiseGlobal : NSObject <SimplePingDelegate,PingDelegate,ScanLANDelegate,TCPSocketDelegate,GBPingDelegate>{
    NSMutableArray              *singleTouchTimerArray;
    id<PingDelegate>            delegate;
    ScanLAN                     *scan;
    RoverARP                    *arp;
    MBProgressHUD               *hud;
    TCPCommunication            *tcpSocket;
    NSMutableArray              *deviceArray;
    ControlMode                 cMode;
    GBPing                      *gbPing;
    
/*******水族等部分********/
    NSString       *wifiSSID;
    NSMutableArray *lineArray;
    BOOL           freshFlag;                   //当保存返回后，需要刷新界面
    int            timerNumer;                  //记录第几个定时器
    
    //设备状态值
    BOOL           isSuccess;                   //判断读取状态是否成功
    
    BOOL           switchStatus;
    int            hourStatus;
    int            minuteStatus;
    int            modelStatus;                 //0x01 手动  0x02 闪电 0x03 多云 0x04 定时器1  0x05 定时器2 0x06 定时器3
    
    int            pipeValue1;                  //三个通道值
    int            pipeValue2;
    int            pipeValue3;
    
    BOOL           enterBackgroundFlag;         //进入后台标示
    
    BOOL           isClosed;                    //设备是否关闭
    DeviceMode     mode;                        //设备运行模式
    
    NSMutableArray *deviceSSIDArray;
    NSMutableArray *deviceMACArray;
    
    NSString       *currentControllDevice;      //当前正在受控的设备
    NSString       *IphoneIP;
/*******水族等部分********/
}


@property (nonatomic, retain) NSMutableArray            *singleTouchTimerArray;         //单色触摸面板定时器数据
@property (nonatomic, retain) id<PingDelegate>          delegate;                       //delegate
@property (nonatomic, retain) ScanLAN                   *scan;                          //扫描局域网IP对象
@property (nonatomic, retain) RoverARP                  *arp;                           //获取手机ARP表对象
@property (nonatomic, retain) MBProgressHUD             *hud;                           //提示用户等待View
@property (nonatomic, retain) TCPCommunication          *tcpSocket;                     //tcpSocket
@property (nonatomic, retain) NSMutableArray            *deviceArray;                   //所有已添加的设备
@property (assign)            ControlMode               cMode;                          //用来区分当前的控制模式
@property (nonatomic, retain) GBPing                    *gbPing;


/*******水族等部分********/
@property (nonatomic, retain) NSString       *wifiSSID;
@property (nonatomic, retain) NSMutableArray *lineArray;
@property (assign)            BOOL           freshFlag;
@property (assign)            int            timerNumber;

@property (assign)            BOOL           isSuccess;
@property (assign)            BOOL           switchStatus;
@property (assign)            int            hourStatus;
@property (assign)            int            minuteStatus;
@property (assign)            int            modelStatus;

@property (assign)            int            pipeValue1;
@property (assign)            int            pipeValue2;
@property (assign)            int            pipeValue3;

@property (assign)            BOOL           enterBackgroundFlag;
@property (assign)            BOOL           isClosed;
@property (assign)            DeviceMode     mode;
@property (nonatomic, retain) NSString       *currentControllDevice;
@property (nonatomic, retain) NSString       *IphoneIP;


@property (nonatomic, retain) NSMutableArray *deviceSSIDArray;
@property (nonatomic, retain) NSMutableArray *deviceMACArray;
/*******水族等部分********/


+ (AwiseGlobal *)sharedInstance;

- (NSString *)getFilePath:(NSString *)fileName;                        //获取文件路径 （将【沙盒的.app】复制到【沙盒的document】)

- (NSString *)convertWeekDayToString:(NSString *)str;                  //将0/1代表星期的字符串转化成周一、周二等字符串

- (void)pingIPisOnline:(NSString *)ip;                                 //判断一个IP是否能Ping通

- (void)scanNetwork;                                                   //遍历局域网

- (NSMutableDictionary *)getARPTable;                                  //获取ARP表

- (void)showWaitingView:(float)time;                                   //展示提示用户等待

- (void)showWaitingViewWithMsg:(NSString *)msg withTime:(float)time;   //展示提示用户等待，带文字提示,如果参数time为0，则使用默认时间

- (void)showRemindMsg:(NSString *)msg withTime:(float)time;            //纯文字提示

- (void)hideTabBar:(UIViewController *)con;                            //隐藏界面下方的tabbar

/*******水族等部分********/
- (NSString *)currentWifiSSID;          //获取连接WIFI的账号
- (NSString *)getCurrentWifiSSID;       //获取连接WIFI的账号
- (NSString *)getiPhoneIP;              //获取手机设备的IP地址
- (Byte)getChecksum:(Byte *)byte;       //计算要发送数据的bv 校验和
/*******水族等部分********/


@end
