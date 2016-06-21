//
//  LightingModeController.m
//  FishDemo
//
//  Created by Rover on 14/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "LightingModeController.h"

@interface LightingModeController ()

@end

@implementation LightingModeController
@synthesize modeFlag;
@synthesize percent,sTime,eTime,sswitch;
@synthesize editFlag;
@synthesize runingValue;
@synthesize hud;
@synthesize speedFlag,speedTimer;

#pragma mark ------------------------------------------------ 界面消失是销毁定时器
- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if(self.modeFlag == 1){         //保存闪电模式
            [AwiseUserDefault sharedInstance].light_precent = [NSString stringWithFormat:@"%d",self.percent];
            [AwiseUserDefault sharedInstance].light_sTime = self.sTime;
            [AwiseUserDefault sharedInstance].light_eTime = self.eTime;
            [AwiseUserDefault sharedInstance].light_switch = [NSString stringWithFormat:@"%d",self.sswitch];
        }else if(self.modeFlag == 2){   //保存多云模式
            [AwiseUserDefault sharedInstance].cloudy_precent = [NSString stringWithFormat:@"%d",self.percent];
            [AwiseUserDefault sharedInstance].cloudy_sTime = self.sTime;
            [AwiseUserDefault sharedInstance].cloudy_eTime = self.eTime;
            [AwiseUserDefault sharedInstance].cloudy_switch = [NSString stringWithFormat:@"%d",self.sswitch];
        }
        self.runingValue = 0;
        [self buildDataStruct:NO];
    }
    [self.speedTimer invalidate];
    self.speedTimer = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.previewBtn.layer.cornerRadius = 5;
    self.previewBtn.layer.masksToBounds = true;
    self.downloadBtn.layer.cornerRadius = 5;
    self.downloadBtn.layer.masksToBounds = true;
    
    self.slider.minimumTrackTintColor = [UIColor colorWithRed:0x90/255.
                                                             green:0xee/255.
                                                              blue:0x90/255.
                                                             alpha:1.0];
    self.slider.maximumTrackTintColor = [UIColor colorWithRed:0xd1/255.
                                                             green:0xee/255.
                                                              blue:0xee/255.
                                                             alpha:1.0];
    
    [self.startBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:191./255 blue:95.255 alpha:1.0] forState:UIControlStateNormal];
    [self.endBtn   setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    [[AwiseGlobal sharedInstance] hideTabBar:self];
    self.editFlag = YES; //YES:编辑开始时间   NO:编辑结束时间
    
    [self.endBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    
    [self.switch1 setOn:NO animated:NO];
    self.runingValue = 0;
    
    self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeSpeedFlag) userInfo:nil repeats:YES];
    [self.speedTimer fire];
    
    if(self.modeFlag == 1){  //闪电
        self.navigationItem.title = @"Lighting";
        self.weakLabel.text = @"weak";
        self.strongLabel.text = @"strong";
        
        self.slider.value =  (int)([[AwiseUserDefault sharedInstance].light_precent intValue]);
        self.valueLabel.text = [NSString stringWithFormat:@"%d%%",(int)self.slider.value];
        [self.startBtn setTitle:[NSString stringWithFormat:@"Edit start point>%@",[AwiseUserDefault sharedInstance].light_sTime] forState:UIControlStateNormal];
        [self.endBtn   setTitle:[NSString stringWithFormat:@"Edit end point>%@",[AwiseUserDefault sharedInstance].light_eTime] forState:UIControlStateNormal];
        self.sTime = [AwiseUserDefault sharedInstance].light_sTime;
        self.eTime = [AwiseUserDefault sharedInstance].light_eTime;
        int v = [[AwiseUserDefault sharedInstance].light_switch intValue];
        if(v == 0){
            [self.switch2 setOn:NO animated:NO];
        }else{
            [self.switch2 setOn:YES animated:NO];
        }
        self.sswitch = v;
        int tv = [[[AwiseUserDefault sharedInstance].light_sTime componentsSeparatedByString:@":"][0] intValue]*60*60 +
                 [[[AwiseUserDefault sharedInstance].light_sTime componentsSeparatedByString:@":"][1] intValue]*60;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.datePicker setCountDownDuration:tv];
        });
    }else if(self.modeFlag == 2){  //多云
        self.navigationItem.title = @"Cloudy";
        self.weakLabel.text = @"slow";
        self.strongLabel.text = @"fast";
        
        self.slider.value =  (int)([[AwiseUserDefault sharedInstance].cloudy_precent intValue]);
        self.valueLabel.text = [NSString stringWithFormat:@"%d%%",(int)self.slider.value];
        [self.startBtn setTitle:[NSString stringWithFormat:@"Edit start point>%@",[AwiseUserDefault sharedInstance].cloudy_sTime] forState:UIControlStateNormal];
        [self.endBtn   setTitle:[NSString stringWithFormat:@"Edit end point>%@",[AwiseUserDefault sharedInstance].cloudy_eTime] forState:UIControlStateNormal];
        self.sTime = [AwiseUserDefault sharedInstance].cloudy_sTime;
        self.eTime = [AwiseUserDefault sharedInstance].cloudy_eTime;
        int v = [[AwiseUserDefault sharedInstance].cloudy_switch intValue];
        if(v == 0){
            [self.switch2 setOn:NO animated:NO];
        }else{
            [self.switch2 setOn:YES animated:NO];
        }
        self.sswitch = v;
        int tv = [[[AwiseUserDefault sharedInstance].cloudy_sTime componentsSeparatedByString:@":"][0] intValue]*60*60 +
                 [[[AwiseUserDefault sharedInstance].cloudy_sTime componentsSeparatedByString:@":"][1] intValue]*60;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.datePicker setCountDownDuration:tv];
        });
    }
    self.percent = (int)self.slider.value;
}

- (void)SaveDataAndBack{
    [self SaveData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 保存数据 (暂时没用到)
- (void)SaveData{
    if(self.modeFlag == 1){         //保存闪电模式
        [AwiseUserDefault sharedInstance].light_precent = [NSString stringWithFormat:@"%d",self.percent];
        [AwiseUserDefault sharedInstance].light_sTime = self.sTime;
        [AwiseUserDefault sharedInstance].light_eTime = self.eTime;
        [AwiseUserDefault sharedInstance].light_switch = [NSString stringWithFormat:@"%d",self.sswitch];
    }else if(self.modeFlag == 2){   //保存多云模式
        [AwiseUserDefault sharedInstance].cloudy_precent = [NSString stringWithFormat:@"%d",self.percent];
        [AwiseUserDefault sharedInstance].cloudy_sTime = self.sTime;
        [AwiseUserDefault sharedInstance].cloudy_eTime = self.eTime;
        [AwiseUserDefault sharedInstance].cloudy_switch = [NSString stringWithFormat:@"%d",self.sswitch];
    }
    [self buildDataStruct:NO];
}


#pragma mark ---------------------------------- 改变时间
- (void)dateChange:(UIDatePicker *)sender{
    NSString *time = [[self dateToString:sender.date] componentsSeparatedByString:@" "][1];
    if(self.editFlag == YES){
        int sValue = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        int eValue = [[self.eTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.eTime componentsSeparatedByString:@":"][1] intValue]*60;
        if(sValue > eValue){
            int vv = [[self.sTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.sTime componentsSeparatedByString:@":"][1] intValue]*60;
            [self.datePicker setCountDownDuration:vv];
        }
        else{
            [self.startBtn setTitle:[NSString stringWithFormat:@"点击编辑开始点>%@",time] forState:UIControlStateNormal];
            self.sTime = time;
        }
    }
    else{
        int sValue = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        int eValue = [[self.sTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.sTime componentsSeparatedByString:@":"][1] intValue]*60;
        if(sValue < eValue){
            int vv = [[self.eTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.eTime componentsSeparatedByString:@":"][1] intValue]*60;
            [self.datePicker setCountDownDuration:vv];
        }
        else{
            [self.endBtn setTitle:[NSString stringWithFormat:@"点击编辑开始点>%@",time] forState:UIControlStateNormal];
            self.eTime = time;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 将NSDate转化成字符串
- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

#pragma mark - 讲String转换为NSDate
- (NSDate *)stringToDate:(NSString *)string{
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate *date =[dateFormat1 dateFromString:string];
    return date;
}

#pragma mark ------------------------------------------ 预览当前效果
- (IBAction)previewBtnClicked:(id)sender {
    self.runingValue = 1;
    [[AwiseGlobal sharedInstance] showWaitingView];
    [self buildDataStruct:NO];
}


#pragma mark - 下载设置数据
- (IBAction)downloadBtnClicked:(id)sender {
    self.sswitch = 0;
    [[AwiseGlobal sharedInstance] showWaitingView];
    [self buildDataStruct:NO];
}

- (IBAction)startBtnClicked:(id)sender {
    [self.startBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:191./255 blue:95.255 alpha:1.0] forState:UIControlStateNormal];
    [self.endBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.editFlag = YES;
    int tv = [[self.sTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.sTime componentsSeparatedByString:@":"][1] intValue]*60;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.datePicker setCountDownDuration:tv];
    });
}

- (IBAction)endBtnClicked:(id)sender {
    [self.startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.endBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:191./255 blue:95.255 alpha:1.0] forState:UIControlStateNormal];
    self.editFlag = NO;
    int tv = [[self.eTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.eTime componentsSeparatedByString:@":"][1] intValue]*60;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.datePicker setCountDownDuration:tv];
    });
}

#pragma makr ------------------------------------- 控制滑条取值间隔时间
- (void)changeSpeedFlag{
    self.speedFlag = YES;
}

- (IBAction)sliderValueChange:(id)sender {
    if(self.speedFlag == NO)
        return;
    self.speedFlag = NO;
    UISlider *slider = (UISlider *)sender;
    self.valueLabel.text = [NSString stringWithFormat:@"%d%%",(int)slider.value];
    self.percent = (int)slider.value;
    [self buildDataStruct:YES];
}

//no use
- (IBAction)switch1StatusChange:(id)sender {
    UISwitch *swi = (UISwitch *)sender;
    if(swi.isOn == NO){
        self.runingValue = 0;
    }else{
        self.runingValue = 1;
    }
    [[AwiseGlobal sharedInstance] showWaitingView];
    [self SaveData];
    [self buildDataStruct:NO];
}

//no use
- (IBAction)switch2StatusChange:(id)sender {
    UISwitch *swi = (UISwitch *)sender;
    if(swi.isOn == NO){
        self.sswitch = 0;
    }else{
        self.sswitch = 1;
    }
    [[AwiseGlobal sharedInstance] showWaitingView];
    [self SaveData];
    [self buildDataStruct:NO];
}


#pragma mark - 组织将要发送的数据
- (void)buildDataStruct:(BOOL)sFlag{  //是否是控制滑条时产生的动作，如果是，则发送0x01,不要返回数据
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
        
        int pValue = self.percent;   //百分比
        Byte pbb = pValue;
        b3[9] = pbb;
        
        Byte runbb = self.runingValue;            //立即运行，看效果
        b3[10] = runbb;
        
        Byte openbb = self.sswitch;     //打开(关闭)
        b3[11] = openbb;
        
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
        
        int pValue = self.percent;   //百分比
        Byte pbb = pValue;
        b3[9] = pbb;
        
        Byte runbb = self.runingValue;            //立即运行，看效果
        b3[10] = runbb;
        
        Byte openbb = self.sswitch;     //打开(关闭)
        b3[11] = openbb;
    }
    if(sFlag == YES)
        b3[12] = 0x01;
    b3[13] = 0x01;      //让设备运行回到之前的模式
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
}

#pragma mark ----------------------------------- 解析从设备的返回值
- (void)dataBackFormDevice:(Byte *)byte{
    if (byte[2] == 0x05){                           //闪电、多云
        
    }else{
        [[AwiseGlobal sharedInstance] showRemindMsg:@"操作好像失败了" withTime:1.2];
    }
    [[AwiseGlobal sharedInstance] disMissHUD];
}


@end
