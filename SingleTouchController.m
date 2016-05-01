//
//  SingleTouchController.m
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "SingleTouchController.h"

@interface SingleTouchController ()

@end

@implementation SingleTouchController
@synthesize tbSlider;
@synthesize switchButton;
@synthesize tempView;
@synthesize switchState;
@synthesize timerTable;
@synthesize sceneView;

- (void)viewDidLoad {
    [super viewDidLoad];

    if([AwiseGlobal sharedInstance].tcpSocket == nil ||
       [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType != SingleTouchDevice){
        [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
        [AwiseGlobal sharedInstance].tcpSocket.delegate = nil;
    }
    [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = SingleTouchDevice;      //受控设备为触摸面板
    [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:@"192.168.3.26" port:333];
    
    
    //初始化定时器数据
    NSString *filePath = [[AwiseGlobal sharedInstance] getFilePath:AwiseSingleTouchTimer];
    [AwiseGlobal sharedInstance].singleTouchTimerArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    //如果无数据则初始化默认数据
    if([AwiseGlobal sharedInstance].singleTouchTimerArray == nil){
        [AwiseGlobal sharedInstance].singleTouchTimerArray = [[NSMutableArray alloc] init];
        NSString *time      = @"10:00";
        NSString *percent   = @"100";
        NSString *week      = @"1&1&1&1&1&1&1&1";
        NSString *_switch   = @"0";
        NSMutableArray *oneTimer = [[NSMutableArray alloc] initWithObjects:time,percent,week,_switch, nil];
        [[AwiseGlobal sharedInstance].singleTouchTimerArray addObject:oneTimer];
        [[AwiseGlobal sharedInstance].singleTouchTimerArray addObject:oneTimer];
        [[AwiseGlobal sharedInstance].singleTouchTimerArray addObject:oneTimer];
        [[AwiseGlobal sharedInstance].singleTouchTimerArray addObject:oneTimer];
        [[AwiseGlobal sharedInstance].singleTouchTimerArray addObject:oneTimer];
        [[AwiseGlobal sharedInstance].singleTouchTimerArray writeToFile:filePath atomically:YES];
    }
    [self syncSingleTouchTime];
}


#pragma mark ------------------------------------------------ 连接设备成功
- (void)TCPSocketConnectSuccess{
    NSLog(@"连接设备成功，读取设备状态，两秒后，发送同步时间指令");
    [self performSelector:@selector(syncTime) withObject:nil afterDelay:2.0];
    //读取状态
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x03;
    bt[3]   = 0x01;
    bt[18]  = 0x0d;       //结束符
    bt[19]  = 0x0a;
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}

- (void)syncTime{
    [self syncSingleTouchTime];
}


- (void)viewWillAppear:(BOOL)animated{
    if(self.controlSegment.selectedSegmentIndex == 2){
        self.defaultBtn1.hidden = YES;
        self.defaultBtn2.hidden = YES;
        self.defaultBtn3.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    if(tempView != nil)
        return;
    tempView = [[UIView alloc] initWithFrame:self.view.bounds];
    tempView.center = CGPointMake(self.view.center.x, self.view.center.y);
    tempView.transform = CGAffineTransformMakeRotation(M_PI_4*3);
    
    tbSlider = [[TBCircularSlider alloc]initWithFrame:CGRectMake(0, 0, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    [tbSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    tbSlider.center = self.view.center;
    tbSlider.angle = 250;
    [tempView addSubview:tbSlider];

    switchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    switchButton.layer.cornerRadius = switchButton.frame.size.height/2;
    switchButton.layer.masksToBounds = YES;
    [switchButton setContentMode:UIViewContentModeScaleAspectFill];
    [switchButton setClipsToBounds:YES];
    switchButton.center = self.view.center;
    [switchButton setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_open@3x.png"] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchButton];
    
    NSArray *nibView01 = [[NSBundle mainBundle] loadNibNamed:@"SingleTouchTimerView" owner:nil options:nil];
    timerTable = [nibView01 firstObject];
    timerTable.frame = CGRectMake(SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
    
    NSArray *nibView02 = [[NSBundle mainBundle] loadNibNamed:@"SingleTouchScene" owner:nil options:nil];
    sceneView = [nibView02 firstObject];
    sceneView.frame = CGRectMake(SCREEN_WIDHT*2, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
    
    [self.view addSubview:tempView];
    [self.view addSubview:timerTable];
    [self.view addSubview:sceneView];
    
    switchState = YES;
    centerPoint = self.view.center;
    defaultCenter1 = self.defaultBtn1.center;
    defaultCenter2 = self.defaultBtn2.center;
    defaultCenter3 = self.defaultBtn3.center;
    [self.view bringSubviewToFront:self.controlSegment];
    [self.view bringSubviewToFront:switchButton];
    [self.view bringSubviewToFront:self.defaultBtn1];
    [self.view bringSubviewToFront:self.defaultBtn2];
    [self.view bringSubviewToFront:self.defaultBtn3];
}

#pragma mark ------------------------------------------------ 修改完场景值后，重新装载场景界面,并发送设置场景指令
- (void)needUpdateSceneView:(int)index value:(int)v{
    [self.sceneView setNeedsDisplay];
    self.defaultBtn1.hidden = YES;
    self.defaultBtn2.hidden = YES;
    self.defaultBtn3.hidden = YES;
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x06;
    bt[3]   = 0x01;
    bt[10]  = 0x02;
    bt[11]  = index;
    bt[12]  = v;
    bt[18]  = 0x0d;
    bt[19]  = 0x0a;
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}


#pragma mark ------------------------------------------------ 保存修改定时器，触发该代理
- (void)singleTouchTimerSaved{
    [timerTable.timerTable reloadData];
}

#pragma mark ------------------------------------------------ 开关
- (void)switchFunction:(id)sender{
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x02;
    bt[3]   = 0x01;
    bt[10]  = 0x01;
    
    bt[18]  = 0x0d;
    bt[19]  = 0x0a;
    if(switchState == NO){              //开
        [switchButton setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_open@3x.png"] forState:UIControlStateNormal];
        switchState = YES;
        bt[11] = 0x01;
    }
    else{                               //关
        [switchButton setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_close@3x.png"] forState:UIControlStateNormal];
        switchState = NO;
        bt[11] = 0x00;
    }
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}

#pragma mark ------------------------------------------------ 圆环代理,值发生改变触发
- (void)sliderValueChange:(TBCircularSlider *)slider{
    if(slider.angle < 90)
        return;
    int value = (100/270.)*(360-slider.angle);
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x03;
    bt[3]   = 0x01;
    bt[10]  = 0x01;       //数据长度
    bt[11]  = value;      //数据值
    bt[18]  = 0x0d;       //结束符
    bt[19]  = 0x0a;
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}

#pragma mark ------------------------------------------------ 点击切换界面
- (IBAction)SwitchControlMode:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0){
        self.defaultBtn1.hidden = NO;
        self.defaultBtn2.hidden = NO;
        self.defaultBtn3.hidden = NO;
        [UIView beginAnimations:nil context:nil];   //开始动画
        [UIView setAnimationDuration:0.3];          //动画时长
        timerTable.frame = CGRectMake(SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        sceneView.frame = CGRectMake(SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        tempView.center = centerPoint;
        switchButton.center = centerPoint;
        self.defaultBtn1.center = defaultCenter1;
        self.defaultBtn2.center = defaultCenter2;
        self.defaultBtn3.center = defaultCenter3;
        [UIView commitAnimations];
        
    }
    else if (seg.selectedSegmentIndex == 1){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        timerTable.frame = CGRectMake(SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        sceneView.frame = CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        tempView.center = CGPointMake(-500, tempView.center.y);
        switchButton.center = CGPointMake(-500, switchButton.center.y);
        self.defaultBtn1.center = CGPointMake(-500, self.defaultBtn1.center.y);
        self.defaultBtn2.center = CGPointMake(-500, self.defaultBtn2.center.y);
        self.defaultBtn3.center = CGPointMake(-500, self.defaultBtn3.center.y);
        [UIView commitAnimations];
    }
    else if (seg.selectedSegmentIndex == 2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        timerTable.frame = CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        sceneView.frame = CGRectMake(-SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        tempView.center = CGPointMake(-500, tempView.center.y);
        switchButton.center = CGPointMake(-500, switchButton.center.y);
        self.defaultBtn1.center = CGPointMake(-500, self.defaultBtn1.center.y);
        self.defaultBtn2.center = CGPointMake(-500, self.defaultBtn2.center.y);
        self.defaultBtn3.center = CGPointMake(-500, self.defaultBtn3.center.y);
        [UIView commitAnimations];
    }
}

#pragma mark ------------------------------------------------ 默认值
- (IBAction)defauleValueClicked:(id)sender {
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x03;
    bt[3]   = 0x01;
    bt[10]  = 0x01;       //数据长度
    bt[18]  = 0x0d;       //结束符
    bt[19]  = 0x0a;
    [tbSlider setNeedsDisplay];
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:{
            bt[11]  = 0;        //数据值
            tbSlider.angle = 0;
        }
            break;
        case 2:{
            bt[11]  = 50;       //数据值
            tbSlider.angle = 225;
        }
            break;
        case 3:{
            bt[11]  = 100;      //数据值
            tbSlider.angle = 90;
        }
            break;
        default:
            break;
    }
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}


- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}


- (void)syncSingleTouchTime{
    NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY"];
    int yearstr = [[dateFormatter1 stringFromDate:[NSDate date]] intValue];
    Byte bb[2] = {0,0};
    int i = 0;
    while (yearstr>15) {
        bb[i] = yearstr%16;
        yearstr = yearstr/16;
        i++;
    }
    
    
    bb[0] = 0x07;
    bb[1] = 0xe0;
    
    
    [self hexStringFromString:@"20160501155260"];
    
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
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x03;
    bt[3]   = 0x01;
    bt[10]  = 0x06;       //数据长度
    bt[11]  = bb[0];
    bt[12]  = bb[0];
    bt[13]  = 0x05;
    bt[14]  = 0x01;
    bt[15]  = hhbb;
    bt[16]  = mmbb;
    bt[17]  = ssbb;
    
    bt[18]  = 0x0d;       //结束符
    bt[19]  = 0x0a;
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}

- (void)viewWillDisappear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
