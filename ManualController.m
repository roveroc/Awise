//
//  ManualController.m
//  FishDemo
//
//  Created by Rover on 14/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "ManualController.h"

@interface ManualController ()

@end

@implementation ManualController
@synthesize dataArray;
@synthesize sendTimer;
@synthesize hud;
@synthesize modeFlag;

#pragma mark - 读取通道亮度值
- (void)getDeviceStatus{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x06;
    b3[3] = 0x02;
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
}

#pragma mark ----------------------------------- 解析从设备的返回值
- (void)dataBackFormDevice:(Byte *)byte{
    if (byte[2] == 0x06 && byte[3] == 0x02){                           //读取通道值
        self.slider1.value = byte[6];
        self.slider2.value = byte[5];
        self.slider3.value = byte[7];
        
        self.label1.text = [NSString stringWithFormat:@"%d%%",(int)self.slider3.value];
        self.label2.text = [NSString stringWithFormat:@"%d%%",(int)self.slider1.value];
        self.label3.text = [NSString stringWithFormat:@"%d%%",(int)self.slider2.value];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"Manual";
    [[AwiseGlobal sharedInstance] hideTabBar:self];
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerSendData) userInfo:nil repeats:YES];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.slider1 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider1 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    [self.slider2 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider2 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    [self.slider3 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider3 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    [[AwiseGlobal sharedInstance] showWaitingView:0];

    [self getDeviceStatus];

    if([AwiseGlobal sharedInstance].isClosed == YES){
        [[AwiseGlobal sharedInstance] showRemindMsg:@"设备总开关已关闭" withTime:1.5];
        self.slider1.enabled = NO;
        self.slider2.enabled = NO;
        self.slider3.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 闪电
- (IBAction)lightingButtonClicked:(id)sender {
    self.modeFlag = 1;
}

#pragma mark - 多云
- (IBAction)cloudyButtonCliked:(id)sender {
    self.modeFlag = 2;
}

- (IBAction)sliderValueChange:(id)sender {
    [AwiseGlobal sharedInstance].mode = Manual_Model;
    UISlider *slider = (UISlider *)sender;
    int value = (int)slider.value;
    if(slider.tag == 1)
        self.label1.text = [NSString stringWithFormat:@"%d%%",value];
    else if(slider.tag == 2)
        self.label2.text = [NSString stringWithFormat:@"%d%%",value];
    else
        self.label3.text = [NSString stringWithFormat:@"%d%%",value];
    [self buildDataToSend];
}

#pragma mark - 构造数据，准备发送
- (void)buildDataToSend{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x05;
    b3[3] = 0x02;
    b3[4] = 0x00;
    
    b3[5] = (int)self.slider3.value;        //由于硬件  将一通道和三通道调换
    b3[6] = (int)self.slider2.value;
    b3[7] = (int)self.slider1.value;
    
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
    [self.dataArray addObject:data];
}


#pragma mark - 定时器轮询数组是否有需要发送的数据
- (void)timerSendData{
    if(self.dataArray.count > 0){
        NSData *data = [self.dataArray objectAtIndex:0];
        Byte *by = (Byte *)[data bytes];
        [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:by length:64];
        [self.dataArray removeObjectAtIndex:0];
    }
}


@end
