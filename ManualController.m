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
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
//    [[AwiseGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"Manual";
    [[AwiseGlobal sharedInstance] hideTabBar:self];
    
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
    
    
//    [self setMinimumTrackImage:@"slider_blue.png" withCapInsets:UIEdgeInsetsMake(0, 16, 0, 16) forState:UIControlStateNormal];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:WAITTIME];
    [AwiseGlobal sharedInstance].isSuccess = NO;
    [self getDeviceStatus];
    [self performSelector:@selector(getDeviceStatusFinished) withObject:nil afterDelay:1.0];
}


- (void)getDeviceStatusFinished{
    if([AwiseGlobal sharedInstance].isSuccess == YES){
        self.slider1.value = [AwiseGlobal sharedInstance].pipeValue3;
        self.slider2.value = [AwiseGlobal sharedInstance].pipeValue1;
        self.slider3.value = [AwiseGlobal sharedInstance].pipeValue2;
        
        self.label1.text = [NSString stringWithFormat:@"%d%%",[AwiseGlobal sharedInstance].pipeValue3];
        self.label2.text = [NSString stringWithFormat:@"%d%%",[AwiseGlobal sharedInstance].pipeValue1];
        self.label3.text = [NSString stringWithFormat:@"%d%%",[AwiseGlobal sharedInstance].pipeValue2];
    }
    else{
        NSLog(@"读取通道值失败");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Get device status failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Get device status failed";
        [self.hud hide:YES afterDelay:DISMISS_TIME];
    }
    if([AwiseGlobal sharedInstance].isClosed == YES){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Device Has been shut down";
        [self.hud hide:YES afterDelay:DISMISS_TIME];
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
//        [[AwiseGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
        [self.dataArray removeObjectAtIndex:0];
    }
}


#pragma mark - 组织将要发送的数据
- (void)buildDataStruct{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x05;
    b3[4] = 0x00;
    if(self.modeFlag == 1){
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
        
        Byte runbb = 0x01;            //立即运行，看效果
        b3[10] = runbb;
        
        Byte openbb = 0x00;           //打开(关闭)
        b3[11] = openbb;
        [AwiseGlobal sharedInstance].mode = Lighting_Model;
    }else if(self.modeFlag == 2){
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
        
        Byte runbb = 0x01;            //立即运行，看效果
        b3[10] = runbb;
        
        Byte openbb = 0x00;           //打开(关闭)
        b3[11] = openbb;
        [AwiseGlobal sharedInstance].mode = Cloudy_Model;
    }
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
//    [[AwiseGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
}



@end
