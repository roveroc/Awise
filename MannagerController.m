//
//  MannagerController.m
//  FishDemo
//
//  Created by rover on 16/3/12.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "MannagerController.h"
#import "EditTimerController.h"
#import "LightingModeController.h"

@interface MannagerController ()

@end


@implementation MannagerController
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    [[AwiseGlobal sharedInstance] hideTabBar:self];
    [self closeSwitch:@[@1,@2,@3,@4,@5]];
    switch ([AwiseGlobal sharedInstance].mode) {
        case Timer1_Model:
            [self onSwitch:@[@1]];
            break;
        case Timer2_Model:
            [self onSwitch:@[@2]];
            break;
        case Timer3_Model:
            [self onSwitch:@[@3]];
            break;
        case Lighting_Model:
            [self onSwitch:@[@4]];
            break;
        case Cloudy_Model:
            [self onSwitch:@[@5]];
            break;
        default:
            break;
    }
}

#pragma mark ----------------------------------- 解析从设备的返回值
- (void)dataBackFormDevice:(Byte *)byte{
    if (byte[2] == 0x08 && byte[3] == 0x00){                           //操作定时器
        [[AwiseGlobal sharedInstance] showRemindMsg:@"操作好像失败了" withTime:1.5];
    }
    else if (byte[2] == 0x05 && byte[3] == 0x00){                      //操作多云闪电
        [[AwiseGlobal sharedInstance] showRemindMsg:@"操作好像失败了" withTime:1.5];
    }
}


- (UILabel *)customLabel:(CGRect)rect title:(NSString *)title{
    UILabel *lab = [[UILabel alloc] initWithFrame:rect];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.text = title;
    return lab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}


#pragma mark - 关闭某些开关
- (void)closeSwitch:(NSArray *)tagArr{
    for(int i=0;i<tagArr.count;i++){
        UISwitch *temp = (UISwitch *)[self.view viewWithTag:[tagArr[i] intValue]];
        [temp setOn:NO animated:YES];
    }
}

#pragma mark - 打开某些开关
- (void)onSwitch:(NSArray *)tagArr{
    for(int i=0;i<tagArr.count;i++){
        UISwitch *temp = (UISwitch *)[self.view viewWithTag:[tagArr[i] intValue]];
        [temp setOn:YES animated:YES];
    }
}

#pragma mark - 打开或关闭某种模式
- (IBAction)onoffSwitch:(id)sender {
    [[AwiseGlobal sharedInstance] showWaitingView:0];
    UISwitch *s = (UISwitch *)sender;
    switch (s.tag) {
        case 1:             //定时器1
        {
            if([s isOn]){
                [self operateTimer:0x01 onoff:0x01];
            }else{
                [self operateTimer:0x01 onoff:0x00];
            }
            [self closeSwitch:@[@2,@3,@4,@5]];
            [AwiseGlobal sharedInstance].mode = Timer1_Model;
        }
            break;
        case 2:             //定时器2
        {
            if([s isOn]){
                [self operateTimer:0x02 onoff:0x01];
            }else{
                [self operateTimer:0x02 onoff:0x00];
            }
            [self closeSwitch:@[@1,@3,@4,@5]];
            [AwiseGlobal sharedInstance].mode = Timer2_Model;
        }
            break;
        case 3:             //定时器3
        {
            if([s isOn]){
                [self operateTimer:0x03 onoff:0x01];
            }else{
                [self operateTimer:0x03 onoff:0x00];
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

#pragma mark - 组织将要发送的数据
- (void)lightingClouldMode:(int)flag onOff:(Byte)vaule{
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
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
}


- (IBAction)editBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 11){
        EditTimerController *editCon = [[EditTimerController alloc] init];
        editCon.navTitle = @"Edit Timer1";
        editCon.fileName = @"timerData1";
        [AwiseGlobal sharedInstance].timerNumber = 1;
        [self.navigationController pushViewController:editCon animated:YES];
    }
    else if(btn.tag == 12){
        EditTimerController *editCon = [[EditTimerController alloc] init];
        editCon.navTitle = @"Edit Timer2";
        editCon.fileName = @"timerData2";
        [AwiseGlobal sharedInstance].timerNumber = 2;
        [self.navigationController pushViewController:editCon animated:YES];
    }
    else if(btn.tag == 13){
        EditTimerController *editCon = [[EditTimerController alloc] init];
        editCon.navTitle = @"Edit Timer3";
        editCon.fileName = @"timerData3";
        [AwiseGlobal sharedInstance].timerNumber = 3;
        [self.navigationController pushViewController:editCon animated:YES];
    }
    else if(btn.tag == 14){
        LightingModeController *light = [[LightingModeController alloc] init];
        light.modeFlag = 1;
        [self.navigationController pushViewController:light animated:YES];
    }
    else if(btn.tag == 15){
        LightingModeController *light = [[LightingModeController alloc] init];
        light.modeFlag = 2;
        [self.navigationController pushViewController:light animated:YES];
    }
}
@end
