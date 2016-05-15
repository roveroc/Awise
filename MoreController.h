//
//  MoreController.h
//  AwiseController
//
//  Created by rover on 16/4/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDeviceController.h"

@interface MoreController : UIViewController<UITableViewDataSource,UITableViewDelegate,TCPSocketDelegate>{
    NSArray                 *tableViewItems;
    
}
@property (nonatomic, retain) NSArray              *tableViewItems;


@property (weak, nonatomic) IBOutlet UITableView *moreTable;



@end
