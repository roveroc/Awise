//
//  TCPCommunication.h
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
#import <AsyncSocket.h>


@protocol TCPSocketDelegate <NSObject>

@optional

- (void)TCPSocketConnectSuccess;            //设备连接成功
- (void)TCPSocketBroken;                    //设备断开连接
- (void)dataBackFormDevice:(Byte *)byte;    //发送数据到控制器
- (void)dataBackTimeOut;                    //数据返回超时

@end


//设备类型
typedef enum{
    SingleTouchDevice   = 0,
    LightFishDevice     = 1,
    LightFishDevice_1_1 = 2,
    TC420Device         = 3,
    
}DeviceType;


@interface TCPCommunication : NSObject<AsyncSocketDelegate,TCPSocketDelegate>{
    AsyncSocket                 *socket;
    id<TCPSocketDelegate>       delegate;
    DeviceType                  controlDeviceType;
    NSString                    *deviceIP;
    NSString                    *devicePort;
    BOOL                        responeFlag;
    int                         reConnectCount;
}
@property (nonatomic, strong) AsyncSocket               *socket;
@property (nonatomic, retain) id<TCPSocketDelegate>     delegate;
@property (assign)            DeviceType                controlDeviceType;
@property (nonatomic, retain) NSString                  *deviceIP;                      //当前受控的设备IP
@property (nonatomic, retain) NSString                  *devicePort;                    //当前受控的设备端口
@property (assign)            BOOL                      responeFlag;                    //记录的设备数据的返回情况
@property (assign)            int                       reConnectCount;                 //断开连接后重连的次数记录：5次后将不再重连

//连接设备
- (void)connectToDevice:(NSString *)host port:(NSString *)port;

//发送数据给设备
- (void)sendMeesageToDevice:(Byte[])data length:(int)length;

//断开连接
- (void)breakConnect:(AsyncSocket *)soc;

@end
