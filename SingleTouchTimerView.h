//
//  SingleTouchTimerView.h
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"
#import "EditSingleTouchTimerController.h"

@interface SingleTouchTimerView : UIView <UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray             *switchArray;
}
@property (nonatomic, retain) NSMutableArray            *switchArray;      //暂存Switch，用来区分点击事件

@property (weak, nonatomic) IBOutlet UITableView *timerTable;





@end
