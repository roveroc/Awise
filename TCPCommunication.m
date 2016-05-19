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
    if([socket isConnected]){
//        [socket disconnect];
        NSLog(@"设备已连接 ");
        return;
    }
    socket = [[AsyncSocket alloc] initWithDelegate:self]; //设置回调的delegate
    //TODO 这里需要在退出局域网模式下断开
    [socket disconnect];    //断开tcp连接
    @try {
        [socket connectToHost:host onPort:[port intValue] error:nil];
        [socket readDataWithTimeout:0.5 tag:1];
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
    [delegate TCPSocketConnectSuccess];
}


#pragma mark ---------------------------------------------------- 发送数据给设备
- (void)sendMeesageToDevice:(Byte [])data length:(int)length{
    NSData *da = [[NSData alloc] initWithBytes:data length:length];
    NSLog(@"============ 发送的数据 = :%@",da);
    [socket readDataWithTimeout:0.5 tag:1];
    [socket writeData:da withTimeout:0.5 tag:1];
    self.responeFlag = NO;
    [self performSelector:@selector(isDeviceRespone) withObject:nil afterDelay:0.5];
}

#pragma mark ---------------------------------------------------- 如果设备在指定时间内没有回复数据，则算没有成功
- (void)isDeviceRespone{
    if(self.responeFlag == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"操作可能失败了";
        [hud hide:YES afterDelay:1.5];
        [[[UIApplication sharedApplication] keyWindow] addSubview:hud];
    }
}

#pragma mark ---------------------------------------------------- 发送数据完成功后，设备返回数据调用该函数
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    self.responeFlag = YES;
    NSLog(@"===================== 设备返回的数据 =====================  :%@", data);
    switch (controlDeviceType) {
        case SingleTouchDevice:                 //单色触摸面板
        {
//            NSLog(@"该数据从单色触摸面板返回");
            Byte *by = (Byte *)[data bytes];
            if([self.delegate respondsToSelector:@selector(dataBackFormDevice:)]){
                 [self.delegate dataBackFormDevice:by];
            }
        }
            break;
        {
            
        }
        default:
            break;
    }
}

#pragma mark ---------------------------------------------------- 发送数据完成功后调用该函数
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
//    NSLog(@"didWriteDataWithTag tag:%ld",tag);
}


#pragma mark ---------------------------------------------------- 设备断开连接调用函数，断开后重连
-(void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"设备IP = %@ 的设备断开连接，并且尝试重连",sock);
    if(self.reConnectCount < 5 ){
        [socket connectToHost:deviceIP onPort:[devicePort intValue] error:nil];
        self.reConnectCount ++;
    }
}

@end
