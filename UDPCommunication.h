//
//  UDPCommunication.h
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"


#define SENDPORT    5000                   //发送数据端口
#define BroadCast   @"255.255.255.255"     //广播地址
#define WAITTIME    2.0
#define DISMISS_TIME 1.5
#define WIFISSID    @"Awise-"

@interface UDPCommunication : NSObject

- (Byte)getChecksum:(Byte *)byte;               //计算要发送数据的bv 校验和

- (void)sendDataToDevice:(NSString *)desIP      //发送指令到
                   order:(NSData *)order
                     tag:(int)tag;

@end
