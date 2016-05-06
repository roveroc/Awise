//
//  SettingController.h
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"

@interface SettingController : UIViewController{
    MBProgressHUD       *hud;
}
@property (nonatomic, retain) MBProgressHUD *hud;

- (IBAction)returnDefault:(id)sender;


@end
