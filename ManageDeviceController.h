//
//  ManageDeviceController.h
//  AwiseController
//
//  Created by rover on 16/5/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoverSqlite.h"
#import "AwiseGlobal.h"

@interface ManageDeviceController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *deviceTable;



@end
