//
//  AwiseUserDefault.h
//  AwiseController
//
//  Created by rover on 16/4/30.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwiseUserDefault : NSObject


+ (AwiseUserDefault *)sharedInstance;


@property (nonatomic, retain) NSString *singleTouchSceneValue;          //存储单色触摸设备的4个场景值，用&分割

/*********************水族灯部分*************************/
@property (nonatomic, retain) NSString *light_precent;
@property (nonatomic, retain) NSString *light_sTime;
@property (nonatomic, retain) NSString *light_eTime;
@property (nonatomic, retain) NSString *light_switch;

@property (nonatomic, retain) NSString *cloudy_precent;
@property (nonatomic, retain) NSString *cloudy_sTime;
@property (nonatomic, retain) NSString *cloudy_eTime;
@property (nonatomic, retain) NSString *cloudy_switch;

@property (nonatomic, retain) NSString *activeMAC;      //当前受控设备的MAC


@property (nonatomic, retain) NSData   *oldData;        //保存上一条指令
/*********************水族灯部分*************************/



/*********************蓝牙RGB八个自定义场景的RGB值*************************/
@property (nonatomic, retain) NSString *blueRGB_scene;
/*********************蓝牙RGB八个自定义场景的RGB值*************************/


@end
