//
//  ManualController.h
//  FishDemo
//
//  Created by Rover on 14/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"
#import "MBProgressHUD.h"


@interface ManualController : UIViewController<TCPSocketDelegate>{
    NSMutableArray *dataArray;
    NSTimer        *sendTimer;
    MBProgressHUD  *hud;
    int            modeFlag;
}
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSTimer        *sendTimer;
@property (nonatomic, retain) MBProgressHUD  *hud;
@property (assign)            int            modeFlag;

@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;
@property (weak, nonatomic) IBOutlet UISlider *slider3;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UIButton *lightingButton;
@property (weak, nonatomic) IBOutlet UIButton *cloudyButton;



- (IBAction)lightingButtonClicked:(id)sender;
- (IBAction)cloudyButtonCliked:(id)sender;


- (IBAction)sliderValueChange:(id)sender;




@end
