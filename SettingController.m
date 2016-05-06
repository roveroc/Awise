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
//    [self.view.window  showPopWithButtonTitles:@[@"Return Default?"] styles:@[YUDangerStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
//        if(index == 0){
//            [AwiseGlobal sharedInstance].isSuccess = NO;
//            [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:WAITTIME];
//            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            self.hud.dimBackground = YES;
//            [self.hud hide:YES afterDelay:WAITTIME];
//            Byte b3[64];
//            for(int k=0;k<64;k++){
//                b3[k] = 0x00;
//            }
//            b3[0] = 0x55;
//            b3[1] = 0xAA;
//            b3[2] = 0x03;
//            b3[3] = 0x01;
//            b3[4] = 0x00;
//            b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
//            NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
//            [[AwiseGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
//        }
//    }];
}

- (void)confirmSuccess{
    if([AwiseGlobal sharedInstance].isSuccess == NO){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        [self.view addSubview:self.hud];
        self.hud.labelText = @"Failed";
        [self.hud hide:YES afterDelay:DISMISS_TIME];
    }
}


@end
