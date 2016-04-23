//
//  TCPCommunication.h
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncSocket.h>

@interface TCPCommunication : NSObject<AsyncSocketDelegate>{
    AsyncSocket *socket;
}
@property (nonatomic, retain) AsyncSocket *socket;

//连接设备
- (void)connectToDevice:(NSString *)host port:(int)port;

//发送数据给设备
- (void)sendMeesageToDevice:(Byte[])data length:(int)length;

@end
