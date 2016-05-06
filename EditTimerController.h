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

@interface EditTimerController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSString        *navTitle;
    NSString        *fileName;
    UITableView     *timerTable;
    NSMutableArray  *oldArray;
    int             tableRow;
    lineView        *lineview;
    
    NSMutableArray  *dataArr;
    MBProgressHUD   *hud;
}
@property (nonatomic, retain) NSString          *navTitle;
@property (nonatomic, retain) UITableView       *timerTable;
@property (nonatomic, retain) NSString          *fileName;
@property (nonatomic, retain) NSMutableArray    *oldArray;
@property (assign)            int               tableRow;
@property (nonatomic, retain) lineView          *lineview;
@property (nonatomic, retain) NSMutableArray    *dataArr;
@property (nonatomic, retain) MBProgressHUD     *hud;


- (IBAction)addRow:(id)sender;
- (IBAction)subRow:(id)sender;


@end
