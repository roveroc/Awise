//
//  MainController.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "LightFishController.h"


@interface LightFishController ()

@end

@implementation LightFishController
@synthesize pipe1Value;
@synthesize pipe2Value;
@synthesize pipe3Value;
@synthesize dataArray;
@synthesize sendTimer;
@synthesize deviceInfo;
@synthesize sql;
@synthesize sliderTimer,sliderFlag;
@synthesize scannCount;


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

//更新界面的开关状态：定时器
- (void)timerStart{
    if([AwiseGlobal sharedInstance].mode == Timer1_Model){
        [self closeSwitch:@[@2,@3,@4,@5]];
        [self.timer1Switch setOn:YES animated:NO];
    }else if([AwiseGlobal sharedInstance].mode == Timer2_Model){
        [self closeSwitch:@[@1,@3,@4,@5]];
        [self.timer2Switch setOn:YES animated:NO];
    }else if([AwiseGlobal sharedInstance].mode == Timer3_Model){
        [self closeSwitch:@[@2,@1,@4,@5]];
        [self.timer3Switch setOn:YES animated:NO];
    }
}

//更新界面的开关状态： 多云和闪电
- (void)lightingStart{
    if([AwiseGlobal sharedInstance].mode == Lighting_Model){
        [self closeSwitch:@[@2,@3,@1,@5]];
        [self.timer4Switch setOn:YES animated:NO];
    }else if([AwiseGlobal sharedInstance].mode == Cloudy_Model){
        [self closeSwitch:@[@1,@3,@4,@2]];
        [self.timer5Switch setOn:YES animated:NO];
    }
}

#pragma mark ------------------------------------------------ 重新启动定时器,并断开连接
- (void)viewWillAppear:(BOOL)animated{
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    if(self.dataArray == nil){
        self.dataArray = [[NSMutableArray alloc] init];
    }
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerSendData) userInfo:nil repeats:YES];
    [self.sendTimer fire];
    
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeSliderFlag) userInfo:nil repeats:YES];
    [self.sliderTimer fire];
}

#pragma mark ------------------------------------------------ 改变取值的变量值
- (void)changeSliderFlag{
    self.sliderFlag = YES;
}

#pragma mark ------------------------------------------------ 界面消失是销毁定时器
- (void)viewWillDisappear:(BOOL)animated{
    [self.sendTimer invalidate];
    self.sendTimer = nil;
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [AwiseGlobal sharedInstance].breakMode = Manual_Broken;
        [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
    }
}

#pragma mark ------------------------------------------------ 读取设备状态
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

//当总开关在打开和关闭时，设置Slider的不同颜色
- (void)IsSwitchShutDwon:(BOOL)flag{
    if(flag == NO){
        self.pipe1Slider.minimumTrackTintColor = [UIColor colorWithRed:0x90/255.
                                                                 green:0xee/255.
                                                                  blue:0x90/255.
                                                                 alpha:1.0];
        self.pipe1Slider.maximumTrackTintColor = [UIColor colorWithRed:0xd1/255.
                                                                 green:0xee/255.
                                                                  blue:0xee/255.
                                                                 alpha:1.0];
        self.pipe2Slider.minimumTrackTintColor = [UIColor colorWithRed:0x90/255.
                                                                 green:0xee/255.
                                                                  blue:0x90/255.
                                                                 alpha:1.0];
        self.pipe2Slider.maximumTrackTintColor = [UIColor colorWithRed:0xd1/255.
                                                                 green:0xee/255.
                                                                  blue:0xee/255.
                                                                 alpha:1.0];
        self.pipe3Slider.minimumTrackTintColor = [UIColor colorWithRed:0x90/255.
                                                                 green:0xee/255.
                                                                  blue:0x90/255.
                                                                 alpha:1.0];
        self.pipe3Slider.maximumTrackTintColor = [UIColor colorWithRed:0xd1/255.
                                                                 green:0xee/255.
                                                                  blue:0xee/255.
                                                                 alpha:1.0];
        self.pipe1Label.textColor = [UIColor blackColor];
        self.pipe2Label.textColor = [UIColor blackColor];
        self.pipe3Label.textColor = [UIColor blackColor];
    }else{
        self.pipe1Slider.minimumTrackTintColor = [UIColor grayColor];
        self.pipe1Slider.maximumTrackTintColor = [UIColor grayColor];
        self.pipe2Slider.minimumTrackTintColor = [UIColor grayColor];
        self.pipe2Slider.maximumTrackTintColor = [UIColor grayColor];
        self.pipe3Slider.minimumTrackTintColor = [UIColor grayColor];
        self.pipe3Slider.maximumTrackTintColor = [UIColor grayColor];
        self.pipe1Label.textColor = [UIColor grayColor];
        self.pipe2Label.textColor = [UIColor grayColor];
        self.pipe3Label.textColor = [UIColor grayColor];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = [self.deviceInfo objectAtIndex:0];   //顶部标题名
    
    //刷新读取设备时间
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:[[AwiseGlobal sharedInstance] DPLocalizedString:@"updateStatus"]
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(refreshStatus)];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    self.timer1Button.layer.cornerRadius = 5;
    self.timer1Button.layer.masksToBounds = true;
    self.timer2Button.layer.cornerRadius = 5;
    self.timer2Button.layer.masksToBounds = true;
    self.timer3Button.layer.cornerRadius = 5;
    self.timer3Button.layer.masksToBounds = true;
    self.cloudyButton.layer.cornerRadius = 5;
    self.cloudyButton.layer.masksToBounds = true;
    self.lightingButton.layer.cornerRadius = 5;
    self.lightingButton.layer.masksToBounds = true;
    
//连接设备部分
    [AwiseGlobal sharedInstance].delegate = self;
    [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    [AwiseGlobal sharedInstance].tcpSocket.devicePort = [deviceInfo objectAtIndex:3];
    if([AwiseGlobal sharedInstance].cMode == AP){
//AP模式下，先检查设备的WIFI连接是否对应
        NSString *macStr = [[[[AwiseGlobal sharedInstance].wifiSSID componentsSeparatedByString:@"-"] lastObject] lowercaseStringWithLocale:[NSLocale currentLocale]];
        if([[deviceInfo objectAtIndex:1] rangeOfString:macStr].location != NSNotFound){
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = [self.deviceInfo objectAtIndex:2];
            [[AwiseGlobal sharedInstance].tcpSocket
             connectToDevice:[deviceInfo objectAtIndex:2]
             port:[deviceInfo objectAtIndex:3]];
        }else{
            [[AwiseGlobal sharedInstance] showRemindMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"connectDeviceFirst"]
                                               withTime:2.0];
        }
    }
    else if([AwiseGlobal sharedInstance].cMode == STA){
        if(self.deviceInfo.count > 0){
            [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"connecting"]];
//如果是STA模式，首先尝试建立连接看设备在线或IP发生变化
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = [self.deviceInfo objectAtIndex:4];
            [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:[self.deviceInfo objectAtIndex:4] port:[self.deviceInfo objectAtIndex:3]];
//连接设备超时
            [self performSelector:@selector(connectDeviceTimeout) withObject:nil afterDelay:2.0];
        }
    }else{
        [[AwiseGlobal sharedInstance] showRemindMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"noWifi"] withTime:1.2];
    }
}

#pragma mark ------------------------------------------------ 连接设备超时 -- 超时
- (void)connectDeviceTimeout{
    [[AwiseGlobal sharedInstance] disMissHUD];
    [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"connectTimeout"]];
    scannCount = 0;
    [[AwiseGlobal sharedInstance] scanNetwork];
}

#pragma mark ---------------- Ping IP 地址的回调 <暂时没有用到，用的是上一个 connectDeviceTimeout>
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
            [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice;
            [AwiseGlobal sharedInstance].tcpSocket.devicePort = [deviceInfo objectAtIndex:3];
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = [self.deviceInfo objectAtIndex:2];
            [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:[AwiseGlobal sharedInstance].tcpSocket.deviceIP
                                                               port:[AwiseGlobal sharedInstance].tcpSocket.devicePort];
        }
        else{
            [[AwiseGlobal sharedInstance] showRemindMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"offLine"] withTime:1.2];
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
            [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice;
            [AwiseGlobal sharedInstance].tcpSocket.devicePort = [deviceInfo objectAtIndex:3];
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = [self.deviceInfo objectAtIndex:4];
            [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:[AwiseGlobal sharedInstance].tcpSocket.deviceIP
                                                               port:[AwiseGlobal sharedInstance].tcpSocket.devicePort];
        }
        else{       //Ping不通，说明设备IP发生了变化，需重新扫描局域网，匹配设备IP
            [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"searchDevice"]];
            [[AwiseGlobal sharedInstance] scanNetwork];
        }
    }
}

#pragma mark ------------------------------------------------ 扫描局域网完成
- (void)scanNetworkFinish{
    if(scannCount == 2){
        [[AwiseGlobal sharedInstance] disMissHUD];
    }
    NSLog(@" ------- 扫描到的ARP表 ------- ");
    NSMutableArray *arpArray = [[AwiseGlobal sharedInstance] getARPTable];
    NSLog(@"设备IP发生了变化了，需重新获取IP，扫描到的ARP表 -------%@ ",arpArray);
    NSString *temp = [self.deviceInfo objectAtIndex:1];
    if([arpArray containsObject:temp]){
        int index = (int)[arpArray indexOfObject:temp];
        NSString *newIp = [arpArray objectAtIndex:index+1];
        NSLog(@"更新设备IP成功 ----------%@ ",newIp);
        //更新数据库
        self.sql = [[RoverSqlite alloc] init];
        if([self.sql modifyDeviceIP:[self.deviceInfo objectAtIndex:1] newIP:newIp]){
            [AwiseGlobal sharedInstance].deviceArray = [self.sql getAllDeviceInfomation];   //获取所有已添加设备信息
            NSLog(@"更新设备IP成功 ----------%@ ",newIp);
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = newIp;
            if([AwiseGlobal sharedInstance].tcpSocket == nil ||
               [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType != LightFishDevice){
                [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
                [AwiseGlobal sharedInstance].tcpSocket.delegate = nil;
            }
            [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
            [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
            [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice;
            [AwiseGlobal sharedInstance].tcpSocket.devicePort = [deviceInfo objectAtIndex:3];
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = newIp;
            [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:newIp
                                                               port:[AwiseGlobal sharedInstance].tcpSocket.devicePort];
        }
    }else{
        NSLog(@"在局域网内没有发现设备 --> 确保设备正常工作");
        if(scannCount == 2){
            NSString *msg = [NSString stringWithFormat:@"在%@局域网内没有找到设备，请确保设备正常工作",[AwiseGlobal sharedInstance].wifiSSID];
            [[AwiseGlobal sharedInstance] showRemindMsg:msg withTime:0.8];
            [self performSelector:@selector(backToHome) withObject:nil afterDelay:0.8];
        }else{
            scannCount++;
            [[AwiseGlobal sharedInstance] scanNetwork];
        }
    }
}

#pragma mark ---------------------------------------------- 连接设备 -> 失败
- (void)TCPSocketConnectFailed{
    if([AwiseGlobal sharedInstance].breakMode == Other_Broken){
        [[AwiseGlobal sharedInstance] showRemindMsg:@"连接设备失败" withTime:0.6];
        [self performSelector:@selector(backToHome) withObject:nil afterDelay:0.6];
    }
}

//各种情况，没有连接上设备则返回
- (void)backToHome{
    [AwiseGlobal sharedInstance].breakMode = Other_Broken;
    [[AwiseGlobal sharedInstance] disMissHUD];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------------------------------------------- 连接设备 -> 成功
- (void)TCPSocketConnectSuccess{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectDeviceTimeout) object:nil];
    [[AwiseGlobal sharedInstance] disMissHUD];
    [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"updateStatusMsg"]];
    //每次软件启动时，自动同步时间至设备
    [self performSelector:@selector(syncDeviceTime) withObject:nil afterDelay:0.2];
    //获取设备状态值
    [self performSelector:@selector(getDeviceStatus) withObject:nil afterDelay:0.8];
}



#pragma mark --------------------------------------------- 获取最新的设备状态值
- (void)refreshStatus{
    [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"updateStatusMsg"]];
    [self getDeviceStatus];
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

#pragma mark ---------------------------------------------------- 数据返回超时
- (void)dataBackTimeOut{
    [[AwiseGlobal sharedInstance] disMissHUD];
}

#pragma mark ---------------------------------------------------- 处理水族灯设备返回的数据
- (void)dataBackFormDevice:(Byte *)byte{
    [[AwiseGlobal sharedInstance] disMissHUD];
    if (byte[2] == 0x04 && byte[3] == 0x01 && byte[5] == 0x01){          //开指令：成功
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"turnOnLight@3x.png"] forState:UIControlStateNormal];
        [AwiseGlobal sharedInstance].isClosed = NO;
        [self IsSwitchShutDwon:NO];
    }
    else if(byte[2] == 0x04 && byte[3] == 0x01 && byte[5] == 0x00){      //关指令：成功
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"turnOffLight@3x.png"] forState:UIControlStateNormal];
        [AwiseGlobal sharedInstance].isClosed = YES;
        [self IsSwitchShutDwon:YES];
    }
    else if(byte[2] == 0x06 && byte[3] == 0x01){
        if([AwiseGlobal sharedInstance].cMode == AP){
            Byte macbb[12];
            for(int i=51;i<63;i++){
                macbb[i-51] = byte[i];
            }
            NSString *hexStr=@"";
            for(int i=0;i<12;i++){
                NSString *newHexStr = [NSString stringWithFormat:@"%x",macbb[i]&0xff]; ///16进制数
                if([newHexStr length]==1)
                    hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
                else
                    hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
            }
            NSLog(@"返回数据设备的MAC == %@",hexStr);
            NSString *ssid = [[[[AwiseGlobal sharedInstance].wifiSSID componentsSeparatedByString:@"-"] lastObject] lowercaseStringWithLocale:[NSLocale currentLocale]];
            if([hexStr rangeOfString:ssid].location != NSNotFound){
                
            }
            else{
                [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"连接失败(mac不对应)" time:1.2];
                return;
            }
        }

        [self closeSwitch:@[@1,@2,@3,@4,@5,@6]];
        [AwiseGlobal sharedInstance].switchStatus = byte[5];
        [AwiseGlobal sharedInstance].hourStatus   = byte[6];
        [AwiseGlobal sharedInstance].minuteStatus = byte[7];
        [AwiseGlobal sharedInstance].modelStatus  = byte[8];
        switch (byte[8]) {
            case 0x01:{
                [AwiseGlobal sharedInstance].mode = Manual_Model;
                [self closeSwitch:@[@1,@2,@3,@4,@5,@6]];
            }
                break;
            case 0x02:{
                [AwiseGlobal sharedInstance].mode = Lighting_Model;
                [self closeSwitch:@[@1,@2,@3,@5,@6]];
                UISwitch *temp = (UISwitch *)[self.view viewWithTag:4];
                [temp setOn:YES animated:YES];
                [AwiseUserDefault sharedInstance].oldData = [self buildLightData:1 onOff:0x01];
            }
                break;
            case 0x03:{
                [AwiseGlobal sharedInstance].mode = Cloudy_Model;
                [self closeSwitch:@[@1,@2,@3,@4,@6]];
                UISwitch *temp = (UISwitch *)[self.view viewWithTag:5];
                [temp setOn:YES animated:YES];
                [AwiseUserDefault sharedInstance].oldData = [self buildLightData:2 onOff:0x01];
            }
                break;
            case 0x04:{
                [AwiseGlobal sharedInstance].mode = Timer1_Model;
                [self closeSwitch:@[@2,@3,@4,@5,@6]];
                UISwitch *temp = (UISwitch *)[self.view viewWithTag:1];
                [temp setOn:YES animated:YES];
                [AwiseUserDefault sharedInstance].oldData = [self buildTimerData:1];
            }
                break;
            case 0x05:{
                [AwiseGlobal sharedInstance].mode = Timer2_Model;
                [self closeSwitch:@[@1,@3,@4,@5,@6]];
                UISwitch *temp = (UISwitch *)[self.view viewWithTag:2];
                [temp setOn:YES animated:YES];
                [AwiseUserDefault sharedInstance].oldData = [self buildTimerData:2];
            }
                break;
            case 0x06:{
                [AwiseGlobal sharedInstance].mode = Timer3_Model;
                [self closeSwitch:@[@1,@2,@4,@5,@6]];
                UISwitch *temp = (UISwitch *)[self.view viewWithTag:3];
                [temp setOn:YES animated:YES];
                [AwiseUserDefault sharedInstance].oldData = [self buildTimerData:3];
            }
                break;
            default:
                break;
        }
        if(byte[9] == 0x01){        //说明路由器加入失败
            [[AwiseGlobal sharedInstance] showRemindMsg:@"设置路由模式失败，请确保输入的账号密码正确" withTime:1.1];
        }
        self.pipe1Value = byte[10];     //返回的三个通道值
        self.pipe2Value = byte[11];
        self.pipe3Value = byte[12];
        self.pipe1Slider.value = self.pipe1Value;
        self.pipe2Slider.value = self.pipe2Value;
        self.pipe3Slider.value = self.pipe3Value;
        self.pipe1Label.text = [NSString stringWithFormat:@"%d%%",self.pipe1Value];
        self.pipe2Label.text = [NSString stringWithFormat:@"%d%%",self.pipe2Value];
        self.pipe3Label.text = [NSString stringWithFormat:@"%d%%",self.pipe3Value];
        if([AwiseGlobal sharedInstance].mode == Manual_Model){
            Byte b3[64];
            for(int k=0;k<64;k++){
                b3[k] = 0x00;
            }
            b3[0] = 0x55;
            b3[1] = 0xAA;
            b3[2] = 0x05;
            b3[3] = 0x02;
            b3[4] = 0x00;
            
            b3[5] = (int)self.pipe1Value;        //由于硬件  将一通道和三通道调换
            b3[6] = (int)self.pipe2Value;
            b3[7] = (int)self.pipe3Value;
            
            b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
            NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
            [AwiseUserDefault sharedInstance].oldData = data;
        }
        [self getDeviceStatusFinished];
    }
}

#pragma mark ---------------------------------------------------- 设备状态读取完毕
- (void)getDeviceStatusFinished{
    if([AwiseGlobal sharedInstance].switchStatus == 0x00){
        [AwiseGlobal sharedInstance].isClosed = YES;
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"turnOffLight@3x.png"] forState:UIControlStateNormal];
        [self IsSwitchShutDwon:YES];
    }
    else{
        [AwiseGlobal sharedInstance].isClosed = NO;
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"turnOnLight@3x.png"] forState:UIControlStateNormal];
        [self IsSwitchShutDwon:NO];
    }
//得到设备返回的时间、暂时没用到
//    NSString *hStr;
//    if([AwiseGlobal sharedInstance].hourStatus < 10){
//        hStr = [NSString stringWithFormat:@"0%d",[AwiseGlobal sharedInstance].hourStatus];
//    }else{
//        hStr = [NSString stringWithFormat:@"%d",[AwiseGlobal sharedInstance].hourStatus];
//    }
//    NSString *mStr;
//    if([AwiseGlobal sharedInstance].minuteStatus < 10){
//        mStr = [NSString stringWithFormat:@"0%d",[AwiseGlobal sharedInstance].minuteStatus];
//    }else{
//        mStr = [NSString stringWithFormat:@"%d",[AwiseGlobal sharedInstance].minuteStatus];
//    }
//    NSString *timeStr = [NSString stringWithFormat:@"%@:%@",hStr,mStr];
}

#pragma mark ---------------------------------------------------- 开灯关灯
- (IBAction)switchButtonClicked:(id)sender {
    BOOL b = [[AwiseGlobal sharedInstance].tcpSocket.socket isConnected];
    NSLog(@"b = %d",b);
    
    [[AwiseGlobal sharedInstance] showWaitingView];
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x04;
    b3[3] = 0x01;
    if([AwiseGlobal sharedInstance].isClosed == NO)
        b3[5] = 0x00;   //关
    else
        b3[5] = 0x01;   //开
    
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
    
    NSData *adata = [[NSData alloc] initWithBytes:b3 length:64];
    [AwiseUserDefault sharedInstance].oldData = adata;
}

#pragma mark ---------------------------------------------------- 打开或关闭某种模式
- (IBAction)switchOperate:(id)sender {
    UISwitch *s = (UISwitch *)sender;
    switch (s.tag) {
        case 1:             //定时器1
        {
            if([s isOn]){
//                [self operateTimer:0x01 onoff:0x01];
                [[AwiseGlobal sharedInstance] showWaitingView];
                [self openTimer:1];
            }else{
//                [self operateTimer:0x01 onoff:0x00];
                [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"" time:0.5];
                [self closeTimer];
            }
            [self closeSwitch:@[@2,@3,@4,@5]];
            [AwiseGlobal sharedInstance].mode = Timer1_Model;
        }
            break;
        case 2:             //定时器2
        {
            if([s isOn]){
//                [self operateTimer:0x02 onoff:0x01];
                [[AwiseGlobal sharedInstance] showWaitingView];
                [self openTimer:2];
            }else{
//                [self operateTimer:0x02 onoff:0x00];
                [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"" time:0.5];
                [self closeTimer];
            }
            [self closeSwitch:@[@1,@3,@4,@5]];
            [AwiseGlobal sharedInstance].mode = Timer2_Model;
        }
            break;
        case 3:             //定时器3
        {
            if([s isOn]){
//                [self operateTimer:0x03 onoff:0x01];
                [[AwiseGlobal sharedInstance] showWaitingView];
                [self openTimer:3];
            }else{
//                [self operateTimer:0x03 onoff:0x00];
                [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"" time:0.5];
                [self closeTimer];
            }
            [self closeSwitch:@[@2,@1,@4,@5]];
            [AwiseGlobal sharedInstance].mode = Timer3_Model;
        }
            break;
        case 4:             //闪电
        {
            if([s isOn]){
                [self lightingClouldMode:1 onOff:0x01];
            }else{
                [self lightingClouldMode:1 onOff:0x00];
            }
            [self closeSwitch:@[@2,@3,@1,@5]];
            [AwiseGlobal sharedInstance].mode = Lighting_Model;
        }
            break;
        case 5:             //多云
        {
            if([s isOn]){
                [self lightingClouldMode:2 onOff:0x01];
            }else{
                [self lightingClouldMode:2 onOff:0x00];
            }
            [self closeSwitch:@[@2,@3,@4,@1]];
            [AwiseGlobal sharedInstance].mode = Cloudy_Model;
        }
            break;
        default:
            break;
    }
}

#pragma mark --------------------------- 当关闭某一个定时器是，发送手动调光指令  <最新添加>
- (void)closeTimer{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x05;
    b3[3] = 0x02;
    b3[4] = 0x00;
    
    b3[5] = 0x00;        //由于硬件  将一通道和三通道调换
    b3[6] = 0x00;
    b3[7] = 0x00;
    
    b3[8] = 0x01;        //这个字节，提供给王龙测试
    
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
    
    self.pipe1Slider.value = 0;
    self.pipe2Slider.value = 0;
    self.pipe3Slider.value = 0;
    self.pipe1Label.text = @"0";
    self.pipe2Label.text = @"0";
    self.pipe3Label.text = @"0";
    
    NSData *adata = [[NSData alloc] initWithBytes:b3 length:64];
    [AwiseUserDefault sharedInstance].oldData = adata;
}

#pragma mark +++++++++++++++++++++++++++++ 组装定时器数据
- (NSData *)buildTimerData:(int)timerNum{
    NSString *fileName;
    if(timerNum == 1){
        fileName = @"timerData1.plist";
    }else if(timerNum == 2){
        fileName = @"timerData2.plist";
    }else if(timerNum == 3){
        fileName = @"timerData3.plist";
    }
    NSString *path = [[AwiseGlobal sharedInstance] getFilePath:fileName];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    Byte b3[64];
    if(arr.count > 0){
        for(int k=0;k<64;k++){
            b3[k] = 0x00;
        }
        b3[0] = 0x55;
        b3[1] = 0xAA;
        b3[2] = 0x01;
        b3[3] = timerNum;
        b3[4] = 0x00;
        int index = 5;
        for(int i = 0;i<arr.count;i++){
            NSMutableArray *temp = [arr objectAtIndex:i];
            
            b3[index++] = i+1;
            
            for(int j=0;j<temp.count;j++){
                if(j == 0){
                    NSArray *time = [[temp objectAtIndex:0] componentsSeparatedByString:@":"];
                    b3[index++] = [[time objectAtIndex:0] intValue];
                    b3[index++] = [[time objectAtIndex:1] intValue];
                }
                else{
                    b3[index++] = [[temp objectAtIndex:j] intValue];
                }
            }
        }
        b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    }
    NSData *adata = [[NSData alloc] initWithBytes:b3 length:64];
    [AwiseUserDefault sharedInstance].oldData = adata;
    return adata;
}

#pragma mark +++++++++++++++++++++++++++++ 组装多云闪电数据
- (NSData *)buildLightData:(int)flag onOff:(Byte)vaule{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x05;
    b3[4] = 0x00;
    if(flag == 1){
        b3[3] = 0x00;         //闪电
        NSArray *sArr = [[AwiseUserDefault sharedInstance].light_sTime componentsSeparatedByString:@":"];  //开始时间
        int shhstr = [sArr[0] intValue];
        Byte shhbb = shhstr;
        b3[5] = shhbb;
        int smmstr = [sArr[1] intValue];
        Byte smmbb = smmstr;
        b3[6] = smmbb;
        
        NSArray *eArr = [[AwiseUserDefault sharedInstance].light_eTime componentsSeparatedByString:@":"];  //结束时间
        int ehhstr = [eArr[0] intValue];
        Byte ehhbb = ehhstr;
        b3[7] = ehhbb;
        int emmstr = [eArr[1] intValue];
        Byte emmbb = emmstr;
        b3[8] = emmbb;
        
        int pValue = [[AwiseUserDefault sharedInstance].light_precent intValue];   //百分比
        Byte pbb = pValue;
        b3[9] = pbb;
        
        Byte runbb = 0x00;            //立即运行，看效果(设为关闭)
        b3[10] = runbb;
        
        Byte openbb = vaule;           //打开(关闭)
        b3[11] = openbb;
    }else if(flag == 2){
        b3[3] = 0x01;           //多云
        NSArray *sArr = [[AwiseUserDefault sharedInstance].cloudy_sTime componentsSeparatedByString:@":"];  //开始时间
        int shhstr = [sArr[0] intValue];
        Byte shhbb = shhstr;
        b3[5] = shhbb;
        int smmstr = [sArr[1] intValue];
        Byte smmbb = smmstr;
        b3[6] = smmbb;
        
        NSArray *eArr = [[AwiseUserDefault sharedInstance].cloudy_eTime componentsSeparatedByString:@":"];  //结束时间
        int ehhstr = [eArr[0] intValue];
        Byte ehhbb = ehhstr;
        b3[7] = ehhbb;
        int emmstr = [eArr[1] intValue];
        Byte emmbb = emmstr;
        b3[8] = emmbb;
        
        int pValue = [[AwiseUserDefault sharedInstance].cloudy_precent intValue];   //百分比
        Byte pbb = pValue;
        b3[9] = pbb;
        
        Byte runbb = 0x00;             //立即运行，看效果(设为关闭)
        b3[10] = runbb;
        
        Byte openbb = vaule;           //打开(关闭)
        b3[11] = openbb;
    }
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    NSData *adata = [[NSData alloc] initWithBytes:b3 length:64];
    [AwiseUserDefault sharedInstance].oldData = adata;
    return adata;
}

#pragma mark --------------------------- 打开某一个定时器时，发送数据   <最新添加>
- (void)openTimer:(int)timerNum{
    NSString *fileName;
    if(timerNum == 1){
        fileName = @"timerData1.plist";
    }else if(timerNum == 2){
        fileName = @"timerData2.plist";
    }else if(timerNum == 3){
        fileName = @"timerData3.plist";
    }
    NSString *path = [[AwiseGlobal sharedInstance] getFilePath:fileName];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if(arr.count > 0){
        NSData *data = [self buildTimerData:timerNum];
        Byte *b3 = (Byte *)[data bytes];
        [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
    }else{
        [[AwiseGlobal sharedInstance] disMissHUD];
        [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"请先编辑" time:0.5];
    }
}

#pragma mark - 关闭某些开关
- (void)closeSwitch:(NSArray *)tagArr{
    for(int i=0;i<tagArr.count;i++){
        UISwitch *temp = (UISwitch *)[self.view viewWithTag:[tagArr[i] intValue]];
        [temp setOn:NO animated:YES];
    }
}

#pragma mark ------------------------------------------ 操作定时器1、2、3
- (void)operateTimer:(Byte)tnumber onoff:(Byte)vaule{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x08;
    b3[3] = tnumber;
    b3[5] = vaule;
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
    NSData *adata = [[NSData alloc] initWithBytes:b3 length:64];
    [AwiseUserDefault sharedInstance].oldData = adata;
}



#pragma mark ------------------------------------------ 操作定多云闪电
- (void)lightingClouldMode:(int)flag onOff:(Byte)vaule{
    NSData *data = [self buildLightData:flag onOff:vaule];
    Byte *b3 = (Byte *)[data bytes];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
    NSData *adata = [[NSData alloc] initWithBytes:b3 length:64];
    [AwiseUserDefault sharedInstance].oldData = adata;
}

#pragma mark ---------------------------------------------------- 三通道亮度值改变
- (IBAction)pipeSliderValueChange:(id)sender {
    if(self.sliderFlag == NO)
        return;
    self.sliderFlag = YES;
    [self closeSwitch:@[@1,@2,@3,@4,@5,@6]];
    UISlider *slider = (UISlider *)sender;
    switch (slider.tag) {
        case 7:{
            int value = (int)slider.value;
            self.pipe1Value = value;
            self.pipe1Label.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
        case 8:{
            int value = (int)slider.value;
            self.pipe2Value = value;
            self.pipe2Label.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
        case 9:{
            int value = (int)slider.value;
            self.pipe3Value = value;
            self.pipe3Label.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
            
        default:
            break;
    }
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x05;
    b3[3] = 0x02;
    b3[4] = 0x00;
    
    b3[5] = (int)self.pipe1Value;        //由于硬件  将一通道和三通道调换
    b3[6] = (int)self.pipe2Value;
    b3[7] = (int)self.pipe3Value;
    
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
    [self.dataArray addObject:data];
}

#pragma mark ---------------------------------------------------- 定时器轮询数组是否有需要发送的数据
- (void)timerSendData{
    if(self.dataArray.count > 0){
        NSData *data = [self.dataArray objectAtIndex:0];
        [AwiseUserDefault sharedInstance].oldData = data;
        Byte *by = (Byte *)[data bytes];
        [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:by length:64];
        [self.dataArray removeObjectAtIndex:0];
    }
}

#pragma mark ---------------------------------------------------- 查看编辑某种模式
- (IBAction)modeButtonClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 11:{                       //定时器一
            EditTimerController *editCon = [[EditTimerController alloc] init];
            editCon.delegate = self;
            editCon.navTitle = @"Edit Timer1";
            editCon.fileName = @"timerData1.plist";
            [AwiseGlobal sharedInstance].timerNumber = 1;
            [self.navigationController pushViewController:editCon animated:YES];
        }
            break;
        case 12:{                         //定时器二
            EditTimerController *editCon = [[EditTimerController alloc] init];
            editCon.delegate = self;
            editCon.navTitle = @"Edit Timer2";
            editCon.fileName = @"timerData2.plist";
            [AwiseGlobal sharedInstance].timerNumber = 2;
            [self.navigationController pushViewController:editCon animated:YES];
        }
            break;
        case 13:{                         //定时器三
            EditTimerController *editCon = [[EditTimerController alloc] init];
            editCon.delegate = self;
            editCon.navTitle = @"Edit Timer3";
            editCon.fileName = @"timerData3.plist";
            [AwiseGlobal sharedInstance].timerNumber = 3;
            [self.navigationController pushViewController:editCon animated:YES];
        }
            break;
        case 14:{                         //闪电
            LightingModeController *light = [[LightingModeController alloc] init];
            light.modeFlag = 1;
            light.delegate = self;
            [self.navigationController pushViewController:light animated:YES];
        }
            break;
        case 15:{                         //多云
            LightingModeController *light = [[LightingModeController alloc] init];
            light.modeFlag = 2;
            light.delegate = self;
            [self.navigationController pushViewController:light animated:YES];
        }
            break;
        case 16:{                         //自定义模式
            
        }
            break;
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
