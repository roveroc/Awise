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
#import <UIImageView+Letters.h>

@interface CustomModeController : UIViewController<
                                                    UITableViewDelegate,
                                                    UITableViewDataSource>{
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *modeTableView;




@end
