//
//  SingleTouchTimerView.h
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditSingleTouchTimerController.h"

@interface SingleTouchTimerView : UIView <UITableViewDataSource,UITableViewDelegate>{

}


@property (weak, nonatomic) IBOutlet UITableView *timerTable;





@end
