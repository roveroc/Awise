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


- (id)init{
    self = [super init];
    if (self != nil) {
        // 省略其他细节
    }
    return self;
}

#pragma mark ---------------------------------------------------- 连接设备
- (void)connectToDevice:(NSString *)host port:(int)port{
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


#pragma mark ---------------------------------------------------- 连接设备成功后的回调
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"连接设备成功 ip =  %@ 端口 = %d", host, port);
}


#pragma mark ---------------------------------------------------- 发送数据给设备
- (void)sendMeesageToDevice:(Byte [])data length:(int)length{
    NSLog(@"发送的数据 === :%s", data);
    NSData *da = [[NSData alloc] initWithBytes:data length:length];
    [socket readDataWithTimeout:3.0 tag:1];
    [socket writeData:da withTimeout:3.0 tag:1];
}


#pragma mark ---------------------------------------------------- 发送数据完成功后调用该函数
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"didWriteDataWithTag tag:%ld",tag);
}


#pragma mark ---------------------------------------------------- 设备断开连接调用函数
-(void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"设备IP = %@ 的设备断开连接",[sock connectedHost]);
    
}

@end
