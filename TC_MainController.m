//
//  TC_MainController.m
//  AwiseController
//
//  Created by rover on 16/6/10.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "TC_MainController.h"
#import "AwiseGlobal.h"
#import "CustomModeController.h"
#import "LightingModeController.h"

@interface TC_MainController ()

@end

@implementation TC_MainController
@synthesize slider1;
@synthesize slider2;
@synthesize slider3;
@synthesize slider4;
@synthesize slider5;
@synthesize value_label1;
@synthesize value_label2;
@synthesize value_label3;
@synthesize value_label4;
@synthesize value_label5;
@synthesize effectImgView;
@synthesize lightImgView;
@synthesize cloudyImgView;
@synthesize deviceInfo;

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[AwiseGlobal sharedInstance] hideTabBar:self];
    
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
    [[AwiseGlobal sharedInstance] scanNetwork];
}

#pragma mark ------------------------------------------------ 扫描局域网完成
- (void)scanNetworkFinish{
    [[AwiseGlobal sharedInstance] disMissHUD];
    NSLog(@" ------- 扫描到的ARP表 ------- ");
    NSMutableArray *arpArray = [[AwiseGlobal sharedInstance] getARPTable];
    NSLog(@"设备IP发生了变化了，需重新获取IP，扫描到的ARP表 -------%@ ",arpArray);
    NSString *temp = [self.deviceInfo objectAtIndex:1];
    if([arpArray containsObject:temp]){
        int index = (int)[arpArray indexOfObject:temp];
        NSString *newIp = [arpArray objectAtIndex:index+1];
        NSLog(@"更新设备IP成功 ----------%@ ",newIp);
        //更新数据库
        RoverSqlite *sql = [[RoverSqlite alloc] init];
        if([sql modifyDeviceIP:[self.deviceInfo objectAtIndex:1] newIP:newIp]){
            [AwiseGlobal sharedInstance].deviceArray = [sql getAllDeviceInfomation];   //获取所有已添加设备信息
            NSLog(@"更新设备IP成功 ----------%@ ",newIp);
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = newIp;
            if([AwiseGlobal sharedInstance].tcpSocket == nil ||
               [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType != LightFishDevice_1_1){
                [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
                [AwiseGlobal sharedInstance].tcpSocket.delegate = nil;
            }
            [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
            [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
            [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice_1_1;
            [AwiseGlobal sharedInstance].tcpSocket.devicePort = [deviceInfo objectAtIndex:3];
            [AwiseGlobal sharedInstance].tcpSocket.deviceIP = newIp;
            [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:newIp
                                                               port:[AwiseGlobal sharedInstance].tcpSocket.devicePort];
        }
    }else{
        NSLog(@"确保设备正常工作");
    }
}

#pragma mark ---------------------------------------------- 连接设备成功
- (void)TCPSocketConnectSuccess{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectDeviceTimeout) object:nil];
    [[AwiseGlobal sharedInstance] disMissHUD];
    [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:[[AwiseGlobal sharedInstance] DPLocalizedString:@"updateStatusMsg"]];
    //每次软件启动时，自动同步时间至设备
//    [self performSelector:@selector(syncDeviceTime) withObject:nil afterDelay:0.2];
    //获取设备状态值
    [self performSelector:@selector(getDeviceStatus) withObject:nil afterDelay:0.8];
}

#pragma mark -------------------------------- 初始化Slider
- (UISlider *)customInitSlider:(UISlider *)slider tag:(int)tag{
    slider = [[UISlider alloc] init];
    slider.tag = tag;
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.minimumTrackTintColor = [UIColor colorWithRed:0x90/255.
                                                   green:0xee/255.
                                                    blue:0x90/255.
                                                   alpha:1.0];
    slider.maximumTrackTintColor = [UIColor colorWithRed:0xd1/255.
                                                   green:0xee/255.
                                                    blue:0xee/255.
                                                   alpha:1.0];
    [slider addTarget:self
               action:@selector(sliderVauleChange:)
     forControlEvents:UIControlEventValueChanged];
    return slider;
}

#pragma mark -------------------------------- 初始化UIlabel
- (UILabel *)customInitLabel:(UILabel *)label{
    label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Arial" size:15];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"100%";
    return label;
}

#pragma mark -------------------------------- 滑动条值改变函数
- (void)sliderVauleChange:(id)sender{
    UISlider *slider = (UISlider *)sender;
    int value = (int)slider.value;
    switch (slider.tag) {
        case 1:{
            self.value_label1.text = [NSString stringWithFormat:@"%d%%",value];
            value1 = value;
        }
            break;
        case 2:{
            self.value_label2.text = [NSString stringWithFormat:@"%d%%",value];
            value2 = value;
        }
            break;
        case 3:{
            self.value_label3.text = [NSString stringWithFormat:@"%d%%",value];
            value3 = value;
        }
            break;
        case 4:{
            self.value_label4.text = [NSString stringWithFormat:@"%d%%",value];
            value4 = value;
        }
            break;
        case 5:{
            self.value_label5.text = [NSString stringWithFormat:@"%d%%",value];
            value5 = value;
        }
            break;
            
        default:
            break;
    }
    Byte b1[51];
    for(int k=0;k<51;k++){
        b1[k] = 0x00;
    }
    b1[0]  = 0x55;
    b1[1]  = 0xAA;
    b1[2]  = 0x01;      //总数据包长度，暂时可不填写
    b1[39] = 0x01;      //0x00表示该数据包发往服务器，0x01局域网发送至设备
    
    b1[41] = 0x09;      //指令功能代号
    b1[42] = 0x00;      //指令长度
    b1[43] = 0x05;      //指令长度(优先填充)
    
    b1[46] = 0x01;      //(手动调光)
    
    b1[46] = value1;
    b1[47] = value2;
    b1[48] = value3;
    b1[49] = value4;
    b1[50] = value5;
    
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b1 length:51];
}

#pragma mark -------------------------------- 布局界面
- (void)viewWillLayoutSubviews{
    if(self.slider1 != nil)
        return;
    self.slider1 = [self customInitSlider:self.slider1 tag:1];
    self.slider2 = [self customInitSlider:self.slider2 tag:2];
    self.slider3 = [self customInitSlider:self.slider3 tag:3];
    self.slider4 = [self customInitSlider:self.slider4 tag:4];
    self.slider5 = [self customInitSlider:self.slider5 tag:5];
    
    self.value_label1 = [self customInitLabel:self.value_label1];
    self.value_label2 = [self customInitLabel:self.value_label2];
    self.value_label3 = [self customInitLabel:self.value_label3];
    self.value_label4 = [self customInitLabel:self.value_label4];
    self.value_label5 = [self customInitLabel:self.value_label5];
    
    self.effectImgView = [[UIImageView alloc] init];
    self.lightImgView  = [[UIImageView alloc] init];
    self.cloudyImgView = [[UIImageView alloc] init];
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(enterEffectController)];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(enterLightingController)];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(enterCloudyController)];
    gesture1.delegate = self;
    gesture2.delegate = self;
    gesture3.delegate = self;
    [self.effectImgView addGestureRecognizer:gesture1];
    [self.lightImgView  addGestureRecognizer:gesture2];
    [self.cloudyImgView addGestureRecognizer:gesture3];
    
    int gap = SCREEN_WIDHT/5;    //每一个间隔宽度
    int sliderWidth = 250;       //Slider宽度
    int slider_y    = 360;       //slider的y坐标
    int slider1_x = 0*gap + (gap/2) - sliderWidth/2;
    int slider2_x = 1*gap + (gap/2) - sliderWidth/2;
    int slider3_x = 2*gap + (gap/2) - sliderWidth/2;
    int slider4_x = 3*gap + (gap/2) - sliderWidth/2;
    int slider5_x = 4*gap + (gap/2) - sliderWidth/2;
    
    int labelWidth = 50;
    int labelHeiht = 25;
    int label_y   = 225;
    int label1_x  = 0*gap + (gap/2)-labelWidth/2;
    int label2_x  = 1*gap + (gap/2)-labelWidth/2;
    int label3_x  = 2*gap + (gap/2)-labelWidth/2;
    int label4_x  = 3*gap + (gap/2)-labelWidth/2;
    int label5_x  = 4*gap + (gap/2)-labelWidth/2;
    
    int imageViewSize = 80;     //imageview的大小
    int imageGap = SCREEN_WIDHT/3;
    int image_y  = label_y + sliderWidth + 55;
    int image1_x = 0*imageGap + (imageGap/2)-imageViewSize/2;
    int image2_x = 1*imageGap + (imageGap/2)-imageViewSize/2;
    int image3_x = 2*imageGap + (imageGap/2)-imageViewSize/2;
    
    self.slider1.frame = CGRectMake(slider1_x, slider_y, sliderWidth, 30);
    self.slider2.frame = CGRectMake(slider2_x, slider_y, sliderWidth, 30);
    self.slider3.frame = CGRectMake(slider3_x, slider_y, sliderWidth, 30);
    self.slider4.frame = CGRectMake(slider4_x, slider_y, sliderWidth, 30);
    self.slider5.frame = CGRectMake(slider5_x, slider_y, sliderWidth, 30);
    
    self.value_label1.frame = CGRectMake(label1_x, label_y, labelWidth, labelHeiht);
    self.value_label2.frame = CGRectMake(label2_x, label_y, labelWidth, labelHeiht);
    self.value_label3.frame = CGRectMake(label3_x, label_y, labelWidth, labelHeiht);
    self.value_label4.frame = CGRectMake(label4_x, label_y, labelWidth, labelHeiht);
    self.value_label5.frame = CGRectMake(label5_x, label_y, labelWidth, labelHeiht);
    
    self.lightImgView.frame = CGRectMake(image1_x, image_y, imageViewSize, imageViewSize);
    self.effectImgView.frame  = CGRectMake(image2_x, image_y, imageViewSize, imageViewSize);
    self.cloudyImgView.frame = CGRectMake(image3_x, image_y, imageViewSize, imageViewSize);
    self.lightImgView.userInteractionEnabled = YES;
    self.effectImgView.userInteractionEnabled = YES;
    self.cloudyImgView.userInteractionEnabled = YES;
    [self.lightImgView  setImageWithString:@"闪电效果" color:nil circular:YES];
    [self.effectImgView setImageWithString:@"自定义效果" color:nil circular:YES];
    [self.cloudyImgView setImageWithString:@"多云效果" color:nil circular:YES];
    
    self.slider1.transform = CGAffineTransformRotate(self.slider1.transform,270.0/180*M_PI);
    self.slider2.transform = CGAffineTransformRotate(self.slider2.transform,270.0/180*M_PI);
    self.slider3.transform = CGAffineTransformRotate(self.slider3.transform,270.0/180*M_PI);
    self.slider4.transform = CGAffineTransformRotate(self.slider4.transform,270.0/180*M_PI);
    self.slider5.transform = CGAffineTransformRotate(self.slider5.transform,270.0/180*M_PI);
    
    [self.view addSubview:self.slider1];
    [self.view addSubview:self.slider2];
    [self.view addSubview:self.slider3];
    [self.view addSubview:self.slider4];
    [self.view addSubview:self.slider5];
    
    [self.view addSubview:self.value_label1];
    [self.view addSubview:self.value_label2];
    [self.view addSubview:self.value_label3];
    [self.view addSubview:self.value_label4];
    [self.view addSubview:self.value_label5];
    
    [self.view addSubview:self.effectImgView];
    [self.view addSubview:self.lightImgView];
    [self.view addSubview:self.cloudyImgView];
}

#pragma mark --------------------------------------- 进入自定义效果
- (void)enterEffectController{
    CustomModeController *customCon = [[CustomModeController alloc] init];
    [self.navigationController pushViewController:customCon animated:YES];
}

#pragma mark --------------------------------------- 进入闪电效果
- (void)enterLightingController{
    LightingModeController *con = [[LightingModeController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark --------------------------------------- 进入多云效果
- (void)enterCloudyController{
    LightingModeController *con = [[LightingModeController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------------------------------------ 发送数据模块
/******************************************************************/
/******************************************************************/
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

#pragma mark ------------------------------------------------ 读取设备状态
- (void)getDeviceStatus{
    Byte b1[46];
    for(int k=0;k<46;k++){
        b1[k] = 0x00;
    }
    b1[0] = 0x55;
    b1[1] = 0xAA;
    b1[2] = 0x01;       //总数据包长度，暂时可不填写
    b1[39] = 0x01;      //0x00表示该数据包发往服务器，0x01局域网发送至设备
    
    b1[41] = 0x0a;      //指令功能代号 (去读状态)
    b1[42] = 0x00;      //指令长度
    b1[43] = 0x00;      //指令长度(优先填充)
    
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b1 length:46];
}

#pragma mark ---------------------------------------------------- 处理水族灯设备返回的数据
- (void)dataBackFormDevice:(Byte *)byte{
    [[AwiseGlobal sharedInstance] disMissHUD];
    switch (byte[2]) {
        case 0x01:
            
            break;
            
        default:
            break;
    }
}

@end
