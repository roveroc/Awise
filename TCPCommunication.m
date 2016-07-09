//
//  TCPCommunication.m
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "TCPCommunication.h"

@implementation TCPCommunication
@synthesize socket;
@synthesize delegate;
@synthesize controlDeviceType;
@synthesize deviceIP;
@synthesize devicePort;
@synthesize responeFlag;
@synthesize reConnectCount;

- (id)init{
    self = [super init];
    if (self != nil) {
        // 省略其他细节
    }
    return self;
}

#pragma mark ---------------------------------------------------- 连接设备
- (void)connectToDevice:(NSString *)host port:(NSString *)port{
    self.reConnectCount = 0;
    self.socket = [[AsyncSocket alloc] initWithDelegate:self]; //设置回调的delegate
    @try {
        [self.socket connectToHost:host onPort:[port intValue] error:nil];
        [self.socket readDataWithTimeout:-1 tag:0];
    }
    @catch (NSException *exception) { //异常处理
        NSLog(@"连接设备异常 %@,%@", [exception name], [exception description]);
    }
}

#pragma mark ---------------------------------------------------- 断开连接
- (void)breakConnect:(AsyncSocket *)soc{
    [soc disconnect];
    soc = nil;
}

#pragma mark ---------------------------------------------------- 连接设备成功后的回调
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"连接设备成功 ip =  %@ 端口 = %d", host, port);
    [sock readDataWithTimeout:-1 tag:0];
    [delegate TCPSocketConnectSuccess];
}


#pragma mark ---------------------------------------------------- 发送数据给设备
- (void)sendMeesageToDevice:(Byte [])data length:(int)length{
    NSData *da = [[NSData alloc] initWithBytes:data length:length];
    NSLog(@"============ 发送的数据 = :%@",da);
    [socket readDataWithTimeout:-1 tag:0];
    [socket writeData:da withTimeout:-1 tag:0];
    self.responeFlag = NO;
    if((data[2] == 0x05 && data[3] == 0x02) || (data[2] == 0x05 && data[12] == 0x01)){
        //词条指令为水族灯调光指令，不需要判断数据返回
        //多云闪电是调速度
    }else{
        [self performSelector:@selector(isDeviceRespone) withObject:nil afterDelay:4.0];
    }
}

#pragma mark ---------------------------------------------------- 如果设备在指定时间内没有回复数据，则算没有成功
- (void)isDeviceRespone{
    if(self.responeFlag == NO){
        if([self.delegate respondsToSelector:@selector(dataBackTimeOut)]){
            [self.delegate dataBackTimeOut];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"操作可能失败了";
        hud.detailsLabelText = @"操作可能失败了";
        [hud hide:YES afterDelay:0.8];
        [[[UIApplication sharedApplication] keyWindow] addSubview:hud];
    }
}

#pragma mark ---------------------------------------------------- 发送数据完成功后，设备返回数据调用该函数
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    self.responeFlag = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(isDeviceRespone) object:nil];
    [sock readDataWithTimeout:-1 tag:0];
    switch (controlDeviceType) {
        case SingleTouchDevice:                 //单色触摸面板
        {
            NSLog(@"===================== 单色触摸面板返回的数据 =====================  :%@", data);
            Byte *by = (Byte *)[data bytes];
            if([self.delegate respondsToSelector:@selector(dataBackFormDevice:)]){
                 [self.delegate dataBackFormDevice:by];
            }
        }
            break;
        case LightFishDevice:
        {
            NSLog(@"===================== 水族灯返回的数据 =====================  :%@", data);
            Byte *by = (Byte *)[data bytes];
            if([self.delegate respondsToSelector:@selector(dataBackFormDevice:)]){
                [self.delegate dataBackFormDevice:by];
            }
        }
        default:
            break;
    }
}

#pragma mark ---------------------------------------------------- 发送数据完成功后调用该函数
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"didWriteDataWithTag tag:%ld",tag);
    [self.delegate TCPSocketConnectFailed];
}


#pragma mark ---------------------------------------------------- 设备断开连接调用函数，断开后重连
-(void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"设备IP = %@ 的设备断开连接，并且尝试重连",sock);
//    if(self.reConnectCount < 5 ){
//        [socket connectToHost:deviceIP onPort:[devicePort intValue] error:nil];
//        self.reConnectCount ++;
//    }
}

-(void)onSocket:(AsyncSocket *) sock willDisconnectWithError:(NSError *)err{
    NSLog(@"设备IP = %@   错误 = %@",sock,[err localizedDescription]);
}

@end
