//
//  RoverSqlite.m
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "RoverSqlite.h"

@implementation RoverSqlite


#pragma mark ------------------------------------------------ 返回数据库路径
- (NSString *)dataBasePth{
    NSArray *path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    return [document stringByAppendingPathComponent:AwiseDataBase];
}

#pragma mark ------------------------------------------------ 打开数据库，如果不存在就创建
- (BOOL)openDataBase{
    if (sqlite3_open([[self dataBasePth] UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库创建失败！");
        return NO;
    }
    [self createTable];
    return YES;
}

#pragma mark ------------------------------------------------ 创建表
#pragma mark ---- 六个字段：name,mac,AP_ip,STA_ip,model,description
- (BOOL)createTable{
    NSString *deviceTable = @"CREATE TABLE IF NOT EXISTS AwiseDevice(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, mac TEXT, AP_ip TEXT,port TEXT,STA_ip TEXT, model TEXT, description TEXT)";
    char *ERROR;
    if (sqlite3_exec(database, [deviceTable UTF8String], NULL, NULL, &ERROR)!=SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"设备表创建失败");
        return NO;
    }
    return YES;
}

#pragma mark ------------------------------------------------ 查询所有设备信息
- (NSMutableArray *)getAllDeviceInfomation{
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    NSString *quary = @"SELECT * FROM AwiseDevice";
    sqlite3_stmt *stmt;
    char **dbResult;
    char *errmsg;
    int nRow, nColumn;
    [self openDataBase];
    if(sqlite3_get_table(database, [quary UTF8String], &dbResult, &nRow, &nColumn, &errmsg)!=SQLITE_OK){
        NSLog(@"查询所有设备表出错");
        return nil;
    }
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            NSMutableArray *deviceInfo = [[NSMutableArray alloc] init];
            for(int i=1;i<nColumn;i++){
                char *colum = (char *)sqlite3_column_text(stmt, i);
                NSString *string = [[NSString alloc] initWithUTF8String:colum];
                [deviceInfo addObject:string];
            }
            [infoArray addObject:deviceInfo];
        }
        sqlite3_finalize(stmt);  
    }
    sqlite3_close(database);
    NSLog(@"数据库中最新设备记录为 == %@",infoArray);
    return infoArray;
}

#pragma mark ------------------------------------------------ 插入设备信息
- (BOOL)insertDeivceInfo:(NSMutableArray *)info{
    NSString *sql = @"INSERT INTO AwiseDevice(name,mac,AP_ip,port,STA_ip,model,description) VALUES(?,?,?,?,?,?,?);";
    sqlite3_stmt *stmt;
    [self openDataBase];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        //【插入数据】在这里我们使用绑定数据的方法，参数一：sqlite3_stmt，参数二：插入列号，参数三：插入的数据，参数四：数据长度（-1代表全部），参数五：是否需要回调
        for(int i=0;i<info.count;i++){
            sqlite3_bind_text(stmt, i+1, [[info objectAtIndex:i] UTF8String], -1, NULL);
        }
    }
    if (sqlite3_step(stmt) != SQLITE_DONE){
        NSLog(@"插入设备信息失败");
        return NO;
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return YES;
}

#pragma mark ------------------------------------------------ 删除一条设备信息
- (BOOL)deleteDeviceInfo:(NSString *)mac{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM AwiseDevice where mac = '%@'",mac];
    sqlite3_stmt *stmt;
    [self openDataBase];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
    }
    if (sqlite3_step(stmt) != SQLITE_DONE){
        NSLog(@"删除设备信息失败");
        return NO;
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return YES;
}

#pragma mark ------------------------------------------------ 修改设备IP
- (BOOL)modifyDeviceIP:(NSString *)mac newIP:(NSString *)newip{
    NSString *sql = [NSString stringWithFormat:@"update AwiseDevice set STA_ip='%@' where mac='%@';",newip,mac];
    char *ERROR;
    [self openDataBase];
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &ERROR)!=SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"更新设备IP地址失败 ---> %s",ERROR);
        return NO;
    }
    sqlite3_close(database);
    return YES;
}

#pragma mark ------------------------------------------------ 修改设备别名
- (BOOL)modifyDeviceName:(NSString *)mac newName:(NSString *)newName{
    NSString *sql = [NSString stringWithFormat:@"update AwiseDevice set name='%@' where mac='%@';",newName,mac];
    char *ERROR;
    [self openDataBase];
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &ERROR)!=SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"更新设备别名地址失败 ---> %s",ERROR);
        return NO;
    }
    sqlite3_close(database);
    return YES;
}


@end
