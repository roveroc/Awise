//
//  AwiseGlobal.m
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "AwiseGlobal.h"

@implementation AwiseGlobal
@synthesize singleTouchTimerArray;

+ (AwiseGlobal *)sharedInstance{
    static AwiseGlobal *gInstance = NULL;
    @synchronized(self){
        if (!gInstance){
            gInstance = [self new];
        }
    }
    return(gInstance);
}


#pragma mark -------------------------------------------------------- 获取文件路径 （将【沙盒的.app】复制到【沙盒的document】）
- (NSString *)getFilePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *docPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString *dataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:docPath]){
        if([fileManager fileExistsAtPath:dataPath]){
            NSError *error;
            //拷贝文件到沙盒的document下
            if([fileManager copyItemAtPath:dataPath toPath:docPath error:&error]) {
                NSLog(@"copy success");
            } else{
                NSLog(@"%@",error);
                return nil;
            }
        }
    }
    return docPath;
}

#pragma mark -------------------------------------------------------- 将星期转化成字符串
- (NSString *)convertWeekDayToString:(NSString *)str{
    NSMutableArray *arr = (NSMutableArray *)[str componentsSeparatedByString:@"&"];
    NSString *weekStr = @"";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"周一" forKey:@"1"];
    [dict setObject:@"周二" forKey:@"2"];
    [dict setObject:@"周三" forKey:@"3"];
    [dict setObject:@"周四" forKey:@"4"];
    [dict setObject:@"周五" forKey:@"5"];
    [dict setObject:@"周六" forKey:@"6"];
    [dict setObject:@"周日" forKey:@"7"];
    [dict setObject:@"每天" forKey:@"8"];
    for(int i=0;i<arr.count;i++){
        int value = [[arr objectAtIndex:i] intValue];
        if(value == 1){
            NSString *key = [NSString stringWithFormat:@"%d",i+1];
            weekStr = [weekStr stringByAppendingString:[dict objectForKey:key]];
        }
        if(value== 1 && i==arr.count-1)
            weekStr = @"每天";
    }
    return weekStr;
}

#pragma mark - 将中文星期转化成数字数组
- (NSMutableArray *)convertWeekDayToArray:(NSArray *)arr{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"一" forKey:@"1"];
    [dict setObject:@"二" forKey:@"2"];
    [dict setObject:@"三" forKey:@"3"];
    [dict setObject:@"四" forKey:@"4"];
    [dict setObject:@"五" forKey:@"5"];
    [dict setObject:@"六" forKey:@"6"];
    [dict setObject:@"日" forKey:@"7"];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSArray *values=[dict allValues];
    for(int i = 0;i<arr.count;i++){
        for(int j = 0;j<values.count;j++){
            if([[arr objectAtIndex:i] isEqualToString:[values objectAtIndex:j]]){
                [tempArr addObject:[dict allKeys][j]];
            }
        }
    }
    return tempArr;
}


@end
