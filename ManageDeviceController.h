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
#import "RouterView.h"

@interface ManageDeviceController : UIViewController<UITableViewDataSource,UITableViewDelegate,TCPSocketDelegate>
{
    UIButton            *tempButton;
    RouterView          *routeView;
}
@property (nonatomic, retain) UIButton          *tempButton;
@property (nonatomic, retain) RouterView        *routeView;


@property (weak, nonatomic) IBOutlet UITableView *deviceTable;



@end
