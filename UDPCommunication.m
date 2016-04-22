//
//  UDPCommunication.m
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "UDPCommunication.h"

@implementation UDPCommunication


+ (UDPCommunication *)sharedInstance{
    static UDPCommunication *gInstance = NULL;
    @synchronized(self){
        if (!gInstance){
            gInstance = [self new];
        }
    }
    return(gInstance);
}


#pragma mark - 计算校验和
-(Byte)getChecksum:(Byte *)byte{
    Byte bb = 0x00;
    for(int i = 0;i<64;i++)
        bb+=byte[i];
    return bb;
}


#pragma mark - 发送数据
-(void)sendDataToDevice:(NSString *)desIP order:(NSData *)order tag:(int)tag{

}

#pragma mark - 抓获从socket返回的数据
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    NSLog(@"从设备%@返回的数据为%@",host,data);
    
    return YES;
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotReceiveDataWithTag----%@",error);
}


-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"onUdpSocketDidClose----");
}


@end
