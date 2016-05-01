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

#pragma mark -------------------------------------------------------- 将0/1代表星期的字符串转化成周一、周二等字符串
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

#pragma mark -------------------------------------------------------- 弹出HUD，提示用户等待
- (void)showWaitingView{
    self.hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:HudDismissTime];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.hud];
}

#pragma mark -------------------------------------------------------- 弹出HUD，提示用户等待,带文字提示
- (void)showWaitingViewWithMsg:(NSString *)msg{
    self.hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    self.hud.dimBackground = YES;
    self.hud.labelText = msg;
    [self.hud hide:YES afterDelay:HudDismissTime];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.hud];
}

#pragma mark -------------------------------------------------------- 判断一个IP是否能Ping通

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

#pragma mark -------------------------------------------------------- 遍历局域网完成
- (void)scanLANDidFinishScanning{
    NSLog(@"扫描局域网完毕");
    [delegate scanNetworkFinish];
}

#pragma mark -------------------------------------------------------- 获取手机ARP表
- (NSMutableDictionary *)getARPTable{
    if(self.arp == nil){
        self.arp = [[RoverARP alloc] init];
    }
    NSMutableDictionary *arpDic = [self.arp arpTable];
    return arpDic;
}

@end
