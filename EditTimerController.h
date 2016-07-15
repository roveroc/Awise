//
//  EditTimerController.h
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"
#import "lineView.h"

@protocol TimerStartDelegate <NSObject>

- (void)timerStart;

@end

@interface EditTimerController : UIViewController<UITableViewDelegate,UITableViewDataSource,TCPSocketDelegate,TimerStartDelegate>{
    NSString        *navTitle;
    NSString        *fileName;
    UITableView     *timerTable;
    NSMutableArray  *oldArray;
    int             tableRow;
    lineView        *lineview;
    
    NSMutableArray  *dataArr;
    MBProgressHUD   *hud;
    
    id<TimerStartDelegate> delegate;    //如果在此见面开启定时器，返回时需刷新界面
}
@property (nonatomic, retain) NSString          *navTitle;
@property (nonatomic, retain) UITableView       *timerTable;
@property (nonatomic, retain) NSString          *fileName;
@property (nonatomic, retain) NSMutableArray    *oldArray;
@property (assign)            int               tableRow;
@property (nonatomic, retain) lineView          *lineview;
@property (nonatomic, retain) NSMutableArray    *dataArr;
@property (nonatomic, retain) MBProgressHUD     *hud;
@property (nonatomic, retain) id<TimerStartDelegate>    delegate;


- (IBAction)addRow:(id)sender;
- (IBAction)subRow:(id)sender;


@end
