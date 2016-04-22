//
//  RoverSqlite.h
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AwiseGlobal.h"
#import <sqlite3.h>

@interface RoverSqlite : NSObject{
    sqlite3 *database;
}

//数据库路径
- (NSString *)dataBasePth;

//创建或者打开数据库
- (BOOL)openDataBase;

//查询所有的设备信息
- (NSMutableArray *)getAllDeviceInfomation;

//插入一条设备信息
- (BOOL)insertDeivceInfo:(NSMutableArray *)info;

//修改设备IP地址
- (BOOL)modifyDeviceIP:(NSString *)mac newIP:(NSString *)newip;

//修改设备别名
- (BOOL)modifyDeviceName:(NSString *)mac newName:(NSString *)newName;

@end
