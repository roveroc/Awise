//
//  CustomModeController.h
//  AwiseController
//
//  Created by rover on 16/6/11.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"
#import "lineView.h"
#import "CustomModeCell.h"
#import "TCPCommunication.h"
#import <UIImageView+Letters.h>
#import "TC420_EditTimerController.h"
#import "LightFish11_EditTimerController.h"

@interface CustomModeController : UIViewController<UITableViewDelegate,UITableViewDataSource,TC420EditTimerDelegate,LightFish11EditTimerDelegate>{
    NSMutableArray      *timerData;
    
}
@property (nonatomic, retain) NSMutableArray        *timerData;         //7个定时器的数据

@property (weak, nonatomic) IBOutlet UITableView *modeTableView;




@end
