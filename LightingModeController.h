//
//  LightingModeController.h
//  FishDemo
//
//  Created by Rover on 14/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"

@interface LightingModeController : UIViewController<TCPSocketDelegate>{
    int                 modeFlag;   //1:闪电模式  2:多云模式
    int                 percent;
    NSString            *sTime;
    NSString            *eTime;
    int                 sswitch;
    int                 runingValue;
    BOOL               editFlag;
    MBProgressHUD       *hud;
}
@property (assign) int modeFlag;
@property (assign) int percent;
@property (nonatomic, retain) NSString *sTime;
@property (nonatomic, retain) NSString *eTime;
@property (assign) int sswitch;
@property (assign) int runingValue;
@property (assign) BOOL editFlag;
@property (nonatomic, retain) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@property (weak, nonatomic) IBOutlet UILabel *weakLabel;
@property (weak, nonatomic) IBOutlet UILabel *strongLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UISlider *slider;


@property (weak, nonatomic) IBOutlet UILabel *runLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;

@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;


- (IBAction)startBtnClicked:(id)sender;
- (IBAction)endBtnClicked:(id)sender;

- (IBAction)sliderValueChange:(id)sender;

- (IBAction)switch1StatusChange:(id)sender;
- (IBAction)switch2StatusChange:(id)sender;




@end
