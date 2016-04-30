//
//  TCPCommunication.h
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncSocket.h>

@protocol TCPSocketDelegate <NSObject>

- (void)TCPSocketConnectSuccess;

@end

@interface TCPCommunication : NSObject<AsyncSocketDelegate,TCPSocketDelegate>{
    AsyncSocket                 *socket;
    id<TCPSocketDelegate>       delegate;
}
@property (nonatomic, retain) AsyncSocket               *socket;
@property (nonatomic, retain) id<TCPSocketDelegate>     delegate;

//连接设备
- (void)connectToDevice:(NSString *)host port:(int)port;

//发送数据给设备
- (void)sendMeesageToDevice:(Byte[])data length:(int)length;

//断开连接
- (void)breakConnect:(AsyncSocket *)soc;

@end
