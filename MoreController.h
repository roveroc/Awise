//
//  MoreController.h
//  AwiseController
//
//  Created by rover on 16/4/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray                 *tableViewItems;
    
}
@property (nonatomic, retain) NSArray              *tableViewItems;


@property (weak, nonatomic) IBOutlet UITableView *moreTable;



@end
