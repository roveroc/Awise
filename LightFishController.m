//
//  MainController.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "LightFishController.h"
#import "EditTimerController.h"
#import "ManualController.h"
#import "LightingModeController.h"
#import "DeviceMannagerController.h"
#import "MannagerController.h"

@interface LightFishController ()

@end

@implementation LightFishController
@synthesize hud;
@synthesize btn1,btn2,btn3,btn4,btn5,btn6;
@synthesize runImg;
@synthesize hud1;
@synthesize windowLabel;
@synthesize switchBtn;
@synthesize timeLabel;
@synthesize deviceInfo;
@synthesize sql;

- (void)showTabBar{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewWillAppear:(BOOL)animated{
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
//    [self showTabBar];
}


#pragma mark - 读取设备状态
- (void)getDeviceStatus{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x06;
    b3[3] = 0x01;
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Home";
    
    
    //进入设备管理页，搜索设备、添加到路由器等功能
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Device" style:UIBarButtonItemStyleDone target:self action:@selector(gotoDeviceManagerController)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    //刷新读取设备时间
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStyleDone target:self action:@selector(refreshStatus)];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    [AwiseGlobal sharedInstance].isSuccess = NO;
    [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice;
    
    self.backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT)];
    self.backImg.image = [UIImage imageNamed:@"lightFishBackImg.png"];
    [self.view addSubview:self.backImg];
    
    [self layOutView];
    
//连接设备部分
    [AwiseGlobal sharedInstance].delegate = self;
    [AwiseGlobal sharedInstance].tcpSocket.devicePort = @"30000";
    if([AwiseGlobal sharedInstance].cMode == AP){
        if(self.deviceInfo.count > 0){
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = [self.deviceInfo objectAtIndex:2];
            [[AwiseGlobal sharedInstance] pingIPisOnline:[AwiseGlobal sharedInstance].tcpSocket.deviceIP];
        }
    }
    else if([AwiseGlobal sharedInstance].cMode == STA){
        if(self.deviceInfo.count > 0){
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = [self.deviceInfo objectAtIndex:3];
            [[AwiseGlobal sharedInstance] pingIPisOnline:[AwiseGlobal sharedInstance].tcpSocket.deviceIP];
        }
    }else{
        [[AwiseGlobal sharedInstance] showRemindMsg:@"设备无连接" withTime:2.0];
    }

}

#pragma mark ------------------------------------------------ Ping IP 地址的回调
- (void)ipIsOnline:(BOOL)result{
    if([AwiseGlobal sharedInstance].cMode == AP){
        if(result == YES){
            if([AwiseGlobal sharedInstance].tcpSocket == nil ||
               [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType != LightFishDevice){
                [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
                [AwiseGlobal sharedInstance].tcpSocket.delegate = nil;
            }
            [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
            [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
            [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice;      //受控设备为水族灯
            [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:[AwiseGlobal sharedInstance].tcpSocket.deviceIP
                                                               port:[AwiseGlobal sharedInstance].tcpSocket.devicePort];
        }
        else{
            [[AwiseGlobal sharedInstance] showRemindMsg:@"设备似乎不在线" withTime:2.0];
        }
    }
    else{
        if(result == YES){                 //Ping得通，直接连接
            if([AwiseGlobal sharedInstance].tcpSocket == nil ||
               [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType != LightFishDevice){
                [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
                [AwiseGlobal sharedInstance].tcpSocket.delegate = nil;
            }
            [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
            [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
            [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice;      //受控设备为水族灯
            [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:[AwiseGlobal sharedInstance].tcpSocket.deviceIP
                                                               port:[AwiseGlobal sharedInstance].tcpSocket.devicePort];
        }
        else{                              //Ping不通，说明设备IP发生了变化，需重新扫描局域网，匹配设备IP
            [[AwiseGlobal sharedInstance] scanNetwork];
        }
    }
}

#pragma mark ------------------------------------------------ 扫描局域网完成
- (void)scanNetworkFinish{
    NSLog(@" ------- 扫描到的ARP表 ------- ");
    NSMutableDictionary *arpDic = [[AwiseGlobal sharedInstance] getARPTable];
    NSLog(@"设备IP发生了变化了，需重新获取IP，扫描到的ARP表 -------%@ ",arpDic);
    NSString *newIp = [arpDic objectForKey:[self.deviceInfo objectAtIndex:3]];
    //更新数据库
    self.sql = [[RoverSqlite alloc] init];
    if([self.sql modifyDeviceIP:[self.deviceInfo objectAtIndex:1] newIP:newIp]){
        NSLog(@"更新设备IP成功 ----------%@ ",newIp);
        [AwiseGlobal sharedInstance].tcpSocket.deviceIP = newIp;
        if([AwiseGlobal sharedInstance].tcpSocket == nil ||
           [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType != LightFishDevice){
            [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
            [AwiseGlobal sharedInstance].tcpSocket.delegate = nil;
        }
        [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
        [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
        [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice;      //受控设备为触摸面板
        [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:newIp
                                                           port:[AwiseGlobal sharedInstance].tcpSocket.devicePort];
    }
}

#pragma mark - 连接设备成功
- (void)TCPSocketConnectSuccess{
    [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:@"获取设备最新状态" withTime:WAITTIME];
    //每次软件启动时，自动同步时间至设备
    [self performSelector:@selector(syncDeviceTime) withObject:nil afterDelay:0.2];
    //获取设备状态值
    [self performSelector:@selector(getDeviceStatus) withObject:nil afterDelay:1.0];
}

- (void)addMessageLabel{
    if([AwiseGlobal sharedInstance].wifiSSID == nil ||
       ![[AwiseGlobal sharedInstance].wifiSSID rangeOfString:WIFISSID].location == NSNotFound){
        UILabel *label = (UILabel *)[[UIApplication sharedApplication].windows[0] viewWithTag:1000];
        [label removeFromSuperview];
        self.windowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        self.windowLabel.tag = 1000;
        self.windowLabel.center = CGPointMake(self.view.frame.size.width/2, 74);
        self.windowLabel.text = @"Device OffLine";
        self.windowLabel.textAlignment = NSTextAlignmentCenter;
        self.windowLabel.textColor = [UIColor redColor];
        self.windowLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [[UIApplication sharedApplication].windows[0] addSubview:self.windowLabel];
        self.windowLabel.center = CGPointMake(SCREEN_WIDHT/2, self.windowLabel.center.y);
    }
}

#pragma mark - 初始化自定义按钮
- (UIButton *)customButton:(UIButton *)btn rect:(CGRect)ret title:(NSString *)str{
    btn = [[UIButton alloc] initWithFrame:ret];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"orgbtn.png"] forState:UIControlStateNormal];
    return btn;
}

- (void)layOutView{
    
    int height;
    if(iPhone4)
        height = 30;
    else if(iPhone5)
        height = 50;
    else if(iPhone6)
        height = 80;
    else if(iPhone6)
        height = 120;
    
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
    self.timeLabel.text = @"12:00";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.center = CGPointMake(SCREEN_WIDHT/2, self.timeLabel.center.y);
    [self.view addSubview:self.timeLabel];
    
    self.switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.timeLabel.frame.origin.y + height+30, 100, 100)];
    self.switchBtn.center = CGPointMake(SCREEN_WIDHT/2, self.switchBtn.center.y);
    self.switchBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"turnOffLight@3x.png"] forState:UIControlStateNormal];
    [self.switchBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchBtn];
    
    
    //每个button算100宽度
    self.btn1 = [self customButton:self.btn1 rect:CGRectMake((SCREEN_WIDHT-200)/3, self.switchBtn.frame.origin.y +100 + height, 100, 40) title:@"Manual"];
    self.btn2 = [self customButton:self.btn2 rect:CGRectMake((SCREEN_WIDHT-200)/3*2+100, self.switchBtn.frame.origin.y +100 + height, 100, 40) title:@"Timer&Effect"];
    [self.btn1 addTarget:self action:@selector(btn1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(btn2Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn1];
    [self.view addSubview:self.btn2];
}

#pragma mark --------------------------------------------- 获取最新的设备状态值
- (void)refreshStatus{
    [[AwiseGlobal sharedInstance] showWaitingView:0];
    [self getDeviceStatus];
}


#pragma mark --------------------------------------------- 进入设备管理页面
- (void)gotoDeviceManagerController{
    DeviceMannagerController *deviceCon = [[DeviceMannagerController alloc] init];
    [self.navigationController pushViewController:deviceCon animated:YES];
}


#pragma mark --------------------------------------------- 同步时间
- (void)syncDeviceTime{
    NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY"];
    int yearstr = [[dateFormatter1 stringFromDate:[NSDate date]] intValue];
    Byte bb[3] = {0,0,0};
    int i = 0;
    while (yearstr>15) {
        bb[i] = yearstr%16;
        yearstr = yearstr/16;
        i++;
    }
    
    NSDateFormatter *dateFormatter4 =[[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"HH"];
    int hhstr = [[dateFormatter4 stringFromDate:[NSDate date]] intValue];
    Byte hhbb = hhstr;
    
    NSDateFormatter *dateFormatter5 =[[NSDateFormatter alloc] init];
    [dateFormatter5 setDateFormat:@"mm"];
    int mmstr = [[dateFormatter5 stringFromDate:[NSDate date]] intValue];
    Byte mmbb = mmstr;
    
    NSDateFormatter *dateFormatter6 =[[NSDateFormatter alloc] init];
    [dateFormatter6 setDateFormat:@"ss"];
    int ssstr = [[dateFormatter6 stringFromDate:[NSDate date]] intValue];
    Byte ssbb = ssstr;
    
    NSLog(@"发送的时间 --- > %d %d %d",hhstr,mmstr,ssstr);
    
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x02;
    b3[3] = 0x01;
    b3[4] = 0x00;
    
    b3[5] = hhbb;
    b3[6] = mmbb;
    b3[7] = ssbb;
 
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btn1Clicked{
    ManualController *manual = [[ManualController alloc] init];
    [self.navigationController pushViewController:manual animated:YES];
}

- (void)btn2Clicked{
    MannagerController *man = [[MannagerController alloc] init];
    [self.navigationController pushViewController:man animated:YES];
}

- (void)btn3Clicked:(id)sender {
    LightingModeController *light = [[LightingModeController alloc] init];
    light.modeFlag = 2;
    [self.navigationController pushViewController:light animated:YES];
}

- (void)switchBtnClicked:(id)sender {
    [[AwiseGlobal sharedInstance] showWaitingView:0];
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x04;
    b3[3] = 0x01;
    
    b3[4] = 0x00;
    
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
}

#pragma mark ---------------------------------------------------- 处理单色触摸面板返回的数据
- (void)dataBackFormDevice:(Byte *)byte{
    if (byte[2] == 0x04 && byte[3] == 0x01 && byte[5] == 0x01){          //开指令：成功
        [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"turnOnLight@3x.png"] forState:UIControlStateNormal];
    }
    else if(byte[2] == 0x04 && byte[3] == 0x01 && byte[5] == 0x00){      //关指令：成功
        [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"turnOffLight@3x.png"] forState:UIControlStateNormal];
    }
    else if(byte[2] == 0x06 && byte[3] == 0x01){
        [AwiseGlobal sharedInstance].switchStatus = byte[5];
        [AwiseGlobal sharedInstance].hourStatus   = byte[6];
        [AwiseGlobal sharedInstance].minuteStatus = byte[7];
        [AwiseGlobal sharedInstance].modelStatus  = byte[8];
        switch (byte[8]) {
            case 0x01:
                [AwiseGlobal sharedInstance].mode = Manual_Model;
                break;
            case 0x02:
                [AwiseGlobal sharedInstance].mode = Lighting_Model;
                break;
            case 0x03:
                [AwiseGlobal sharedInstance].mode = Cloudy_Model;
                break;
            case 0x04:
                [AwiseGlobal sharedInstance].mode = Timer1_Model;
                break;
            case 0x05:
                [AwiseGlobal sharedInstance].mode = Timer2_Model;
                break;
            case 0x06:
                [AwiseGlobal sharedInstance].mode = Timer3_Model;
                break;
            default:
                break;
        }
        [self getDeviceStatusFinished];
    }
}

#pragma mark ---------------------------------------------------- 一秒后默认设备状态读取完毕
- (void)getDeviceStatusFinished{
    if([AwiseGlobal sharedInstance].switchStatus == 0x00){
        [AwiseGlobal sharedInstance].isClosed = YES;
        [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"turnOffLight@3x.png"] forState:UIControlStateNormal];
    }
    else{
        [AwiseGlobal sharedInstance].isClosed = NO;
        [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"turnOnLight@3x.png"] forState:UIControlStateNormal];
    }
    NSString *hStr;
    if([AwiseGlobal sharedInstance].hourStatus < 10){
        hStr = [NSString stringWithFormat:@"0%d",[AwiseGlobal sharedInstance].hourStatus];
    }else{
        hStr = [NSString stringWithFormat:@"%d",[AwiseGlobal sharedInstance].hourStatus];
    }
    NSString *mStr;
    if([AwiseGlobal sharedInstance].minuteStatus < 10){
        mStr = [NSString stringWithFormat:@"0%d",[AwiseGlobal sharedInstance].minuteStatus];
    }else{
        mStr = [NSString stringWithFormat:@"%d",[AwiseGlobal sharedInstance].minuteStatus];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@",hStr,mStr];
    self.timeLabel.text = timeStr;
}

@end
