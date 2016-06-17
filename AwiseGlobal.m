//
//  AwiseGlobal.m
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "AwiseGlobal.h"

@implementation AwiseGlobal
@synthesize singleTouchTimerArray;
@synthesize delegate;
@synthesize scan;
@synthesize arp;
@synthesize hud;
@synthesize tcpSocket;
@synthesize deviceArray;
@synthesize cMode;
@synthesize gbPing;

/*******水族等部分********/
@synthesize wifiSSID;
@synthesize lineArray;
@synthesize freshFlag;
@synthesize timerNumber;
@synthesize pipeValue1,pipeValue2,pipeValue3;
@synthesize switchStatus,hourStatus,minuteStatus,modelStatus;
@synthesize isSuccess;
@synthesize enterBackgroundFlag;
@synthesize isClosed;
@synthesize deviceSSIDArray;
@synthesize deviceMACArray;
@synthesize currentControllDevice;
@synthesize IphoneIP;
@synthesize mode;
/*******水族等部分********/


+ (AwiseGlobal *)sharedInstance{
    static AwiseGlobal *gInstance = NULL;
    @synchronized(self){
        if (!gInstance){
            gInstance = [self new];
        }
    }
    return(gInstance);
}


#pragma mark -------------------------------------------------------- 获取文件路径 （将【沙盒的.app】复制到【沙盒的document】）
- (NSString *)getFilePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *docPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString *dataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:docPath]){
        if([fileManager fileExistsAtPath:dataPath]){
            NSError *error;
            //拷贝文件到沙盒的document下
            if([fileManager copyItemAtPath:dataPath toPath:docPath error:&error]) {
                NSLog(@"copy success");
            } else{
                NSLog(@"%@",error);
                return nil;
            }
        }
    }
    return docPath;
}

#pragma mark ---------------------------------------- 将0/1代表星期的字符串转化成周一、周二等字符串
- (NSString *)convertWeekDayToString:(NSString *)str{
    NSMutableArray *arr = (NSMutableArray *)[str componentsSeparatedByString:@"&"];
    NSString *weekStr = @"";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"周一" forKey:@"1"];
    [dict setObject:@"周二" forKey:@"2"];
    [dict setObject:@"周三" forKey:@"3"];
    [dict setObject:@"周四" forKey:@"4"];
    [dict setObject:@"周五" forKey:@"5"];
    [dict setObject:@"周六" forKey:@"6"];
    [dict setObject:@"周日" forKey:@"7"];
    [dict setObject:@"每天" forKey:@"8"];
    for(int i=0;i<arr.count;i++){
        int value = [[arr objectAtIndex:i] intValue];
        if(value == 1){
            NSString *key = [NSString stringWithFormat:@"%d",i+1];
            if(weekStr.length > 1)
                weekStr = [weekStr stringByAppendingString:@" "];
            weekStr = [weekStr stringByAppendingString:[dict objectForKey:key]];
        }
        if(value== 1 && i==arr.count-1)
            weekStr = @"每天";
    }
    return weekStr;
}

#pragma mark -------------------------------------------------------- 提示用户等待，带时间
- (void)showWaitingViewWithTime:(NSString *)msg time:(float)time{
    self.hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    self.hud.dimBackground = YES;
    self.hud.labelText = msg;
    if(time > HudDismissTime){
        [self.hud hide:YES afterDelay:time];
//        if(time > 5){
//            float progress = 0.0f;
//            while (progress < 1.0f) {
//                progress += 0.01f;
//                self.hud.progress = progress;
//                sleep(50000);
//            }
//        }
    }
    else
        [self.hud hide:YES afterDelay:HudDismissTime];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.hud];
}

#pragma mark -------------------------------------------------------- 纯文字提示
- (void)showRemindMsg:(NSString *)msg withTime:(float)time{
    self.hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = msg;
    if(time > HudDismissTime)
        [self.hud hide:YES afterDelay:time];
    else
        [self.hud hide:YES afterDelay:HudDismissTime];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.hud];
}

#pragma mark -------------------------------------------------------- 弹出HUD，提示用户等待
- (void)showWaitingView{
    self.hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    self.hud.dimBackground = YES;
//    if(time > HudDismissTime)
//        [self.hud hide:YES afterDelay:time];
//    else
//        [self.hud hide:YES afterDelay:HudDismissTime];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.hud];
}

#pragma mark -------------------------------------------------------- 弹出HUD，提示用户等待,带文字提示
- (void)showWaitingViewWithMsg:(NSString *)msg{
    self.hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    self.hud.dimBackground = YES;
    self.hud.labelText = msg;
//    if(time > HudDismissTime)
//        [self.hud hide:YES afterDelay:time];
//    else
//        [self.hud hide:YES afterDelay:HudDismissTime];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.hud];
}

#pragma mark -------------------------------------------------------- 隐藏HUD
- (void)disMissHUD{
    [self.hud hide:YES];
}

#pragma mark -------------------------------------------------------- 数据返回超时
- (void)dataBackTimeOut{
    [self.hud hide:YES];
}

#pragma mark -------------------------------------------------------- 判断一个IP是否能Ping通
- (void)pingIPisOnline:(NSString *)ip{
    [SimplePingHelper ping:ip target:self sel:@selector(pingResult:)];
}

#pragma mark -------------------------------------------------------- Ping指定IP返回结果
- (void)pingResult:(NSNumber*)success{
    int value = [success boolValue];
    [delegate ipIsOnline:(value)];
}

#pragma mark ----------------------------------------- 遍历局域网 <当设备Ping不通需要重新扫描局域网，获取设备的新IP>
- (void)scanNetwork{
    if(self.scan != nil){
        [self.scan stopScan];
        self.scan.delegate = nil;
        self.scan = nil;
    }
    self.scan = [[ScanLAN alloc] initWithDelegate:self];
    [self.scan startScan];
}

- (void)releasePing:(GBPing *)ping{
    [ping stop];
    ping.delegate = nil;
    ping = nil;
}

-(void)ping:(GBPing *)pinger didReceiveReplyWithSummary:(GBPingSummary *)summary{
    NSLog(@"pinger = %@",pinger.host);
}

#pragma mark -------------------------------------------------------- 遍历局域网完成
- (void)scanLANDidFinishScanning{
    NSLog(@"扫描局域网完毕");
    [delegate scanNetworkFinish];
}

#pragma mark -------------------------------------------------------- 获取手机ARP表
- (NSMutableArray *)getARPTable{
    if(self.arp == nil){
        self.arp = [[RoverARP alloc] init];
    }
    NSMutableArray *arpArray = [self.arp arpTable];
    return arpArray;
}

#pragma mark -------------------------------------------------------- 隐藏界面下方TabBar
- (void)hideTabBar:(UIViewController *)con{
    if (con.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[con.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [con.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [con.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + con.tabBarController.tabBar.frame.size.height);
    con.tabBarController.tabBar.hidden = YES;
}

#pragma mark -------------------------------------------------------- 获取当前时间
- (NSString *)getCurrentTime{
    NSDateFormatter *dateFormatter4 =[[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"HH"];
    int hhstr = [[dateFormatter4 stringFromDate:[NSDate date]] intValue];
    
    NSDateFormatter *dateFormatter5 =[[NSDateFormatter alloc] init];
    [dateFormatter5 setDateFormat:@"mm"];
    int mmstr = [[dateFormatter5 stringFromDate:[NSDate date]] intValue];

    return [NSString stringWithFormat:@"%d:%d",hhstr,mmstr];
}

#pragma mark -------------------------------------------------------- 国际化
- (NSString *)DPLocalizedString:(NSString *)translation_key {
    
    NSString * s = NSLocalizedString(translation_key, nil);
    if (![CURR_LANG isEqual:@"zh-Hans-CN"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    return s;
}

/*********************水族灯部分*************************/
- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *wifiName = nil;
    NSArray *interFaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    for (NSString *name in interFaceNames) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
        
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
        } 
    }
    return wifiName;
}

@class getSelfIPAddr;

#pragma mark - 获取手机IP
- (NSString *)getiPhoneIP{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


#pragma mark -------------------------- 获取数据存储路径
- (NSString *)getPlistPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"deviceInfo"];
    return path;
}

#pragma mark - 获取本机WIFI的SSID
-(NSString *)getCurrentWifiSSID{
    NSString *ssid = [self currentWifiSSID];
    if(ssid.length < 1){
        [deviceSSIDArray removeAllObjects];
        return @"";
    }
    if([ssid rangeOfString:WIFISSID].location != NSNotFound){
        self.currentControllDevice = @"";         //空字符串，表示当前为点对点模式
        [self.deviceSSIDArray removeAllObjects];
        [self.deviceSSIDArray addObject:ssid];
    }
    else{
        [self.deviceSSIDArray removeAllObjects];
        self.deviceSSIDArray = [[NSMutableArray alloc] initWithContentsOfFile:[self getPlistPath]];
        self.currentControllDevice = [AwiseUserDefault sharedInstance].activeMAC;
    }
    NSLog(@"当前受控的设备MAC -------> %@",self.currentControllDevice);
    return ssid;
}

#pragma mark - 计算校验和
-(Byte)getChecksum:(Byte *)byte{
    Byte bb = 0x00;
    for(int i = 0;i<64;i++)
        bb+=byte[i];
    return bb;
}

/*********************水族灯部分*************************/




@end
