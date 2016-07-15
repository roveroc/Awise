//
//  SettingController.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "SettingController.h"
//#import "UIWindow+YUBottomPoper.h"

@interface SettingController ()

@end

@implementation SettingController
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title= @"System";
    self.navigationItem.title = @"System";
    self.tabBarItem.image = [UIImage imageNamed:@"more.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)returnDefault:(id)sender {

}

- (void)confirmSuccess{
    if([AwiseGlobal sharedInstance].isSuccess == NO){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        [self.view addSubview:self.hud];
//        self.hud.labelText = @"Failed";
        self.hud.detailsLabelText = @"Failed";
        [self.hud hide:YES afterDelay:DISMISS_TIME];
    }
}


@end
