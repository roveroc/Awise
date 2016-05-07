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

- (id)init{
    self = [super init];
    if (self != nil) {
        // 省略其他细节
    }
    return self;
}

#pragma mark ---------------------------------------------------- 连接设备
- (void)connectToDevice:(NSString *)host port:(int)port{
    
    if([socket isConnected]){
//        [socket disconnect];
        NSLog(@"设备已连接 ");
        return;
    }
    socket = [[AsyncSocket alloc] initWithDelegate:self]; //设置回调的delegate
    //TODO 这里需要在退出局域网模式下断开
    [socket disconnect];    //断开tcp连接
    @try {
        [socket connectToHost:host onPort:port error:nil];
        [socket readDataWithTimeout:-1 tag:1];
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
    [socket readDataWithTimeout:-1 tag:1];
    [socket writeData:da withTimeout:-1 tag:1];
}


#pragma mark ---------------------------------------------------- 发送数据完成功后，设备返回数据调用该函数
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"===================== 设备返回的数据 =====================  :%@", data);
    switch (controlDeviceType) {
        case SingleTouchDevice:                 //单色触摸面板
        {
//            NSLog(@"该数据从单色触摸面板返回");
            Byte *by = (Byte *)[data bytes];
            [self parseSingleTouchDeviceData:by];
        }
            break;
        {
            
        }
        default:
            break;
    }

}

#pragma mark ---------------------------------------------------- 处理单色触摸面板返回的数据
- (void)parseSingleTouchDeviceData:(Byte *)byte{            //第五个字节判断成败
    switch (byte[2]) {
        case 0x01:              //读取状态返回值
        {
            
        }
            break;
        case 0x02:              //开关状态返回值
        {
            
        }
            break;
        case 0x03:              //亮度控制返回值
        {
            
        }
            break;
        case 0x04:              //同步时间返回值
        {
            
        }
            break;
        case 0x05:              //设置定时器返回值
        {
            
        }
            break;
        case 0x06:              //设置场景返回值
        {
            
        }
            break;
        case 0x07:              //开关场景返回值
        {
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark ---------------------------------------------------- 发送数据完成功后调用该函数
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
//    NSLog(@"didWriteDataWithTag tag:%ld",tag);
}


#pragma mark ---------------------------------------------------- 设备断开连接调用函数
-(void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"设备IP = %@ 的设备断开连接",sock);
    
}

@end
