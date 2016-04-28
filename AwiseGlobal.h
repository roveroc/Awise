//
//  AwiseGlobal.h
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AwiseDataBase            @"AwiseDeivce.sqlite"              //数据库
#define AwiseSingleTouchTimer    @"SingleTouchTimer.plist"          //单色触摸面板定时器数据存储文件

//******************* ******************* *******************
//判断iPhone4/iPhone4S
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone5/iPhone5S
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6Plus
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1472), [[UIScreen mainScreen] currentMode].size) : NO)
//******************* ******************* *******************

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDHT [[UIScreen mainScreen] bounds].size.width

@interface AwiseGlobal : NSObject{
    NSMutableArray              *singleTouchTimerArray;
}
@property (nonatomic, retain) NSMutableArray            *singleTouchTimerArray;         //单色触摸面板定时器数据




+ (AwiseGlobal *)sharedInstance;

- (NSString *)getFilePath:(NSString *)fileName;                        //获取文件路径 （将【沙盒的.app】复制到【沙盒的document】）
- (NSString *)convertWeekDayToString:(NSString *)str;                  //将0/1代表星期的字符串转化成周一、周二等字符串
- (BOOL)pingIPisOnline:(NSString *)ip;                                 //判断一个IP是否能否


@end
