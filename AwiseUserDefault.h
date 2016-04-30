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


@end
