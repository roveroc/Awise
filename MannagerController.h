//
//  MannagerController.h
//  FishDemo
//
//  Created by rover on 16/3/12.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MannagerController : UIViewController{
    MBProgressHUD       *hud;
}
@property (nonatomic, retain) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UISwitch *switch3;
@property (weak, nonatomic) IBOutlet UISwitch *switch4;
@property (weak, nonatomic) IBOutlet UISwitch *switch5;


- (IBAction)onoffSwitch:(id)sender;

- (IBAction)editBtnClicked:(id)sender;






@end
