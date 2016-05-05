//
//  MainController.h
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"

@interface MainController : UIViewController{
    BOOL            onoffFlag;
    MBProgressHUD   *hud;
    MBProgressHUD   *hud1;
    
    UIButton        *switchBtn;
    
    UIButton        *btn1;
    UIButton        *btn2;
    UIButton        *btn3;
    UIButton        *btn4;
    UIButton        *btn5;
    UIButton        *btn6;
    
    UILabel         *windowLabel;
    UILabel         *timeLabel;
    
    UIImageView     *runImg;
    UIImageView     *backImg;
}
@property (assign) BOOL onoffFlag;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) MBProgressHUD *hud1;

//@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, retain) UIButton *switchBtn;

@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;
@property (nonatomic, retain) UIButton *btn3;
@property (nonatomic, retain) UIButton *btn4;
@property (nonatomic, retain) UIButton *btn5;
@property (nonatomic, retain) UIButton *btn6;

@property (nonatomic, retain) UIImageView *backImg;
@property (nonatomic, retain) UIImageView *runImg;

@property (nonatomic, retain) UILabel       *windowLabel;
@property (nonatomic, retain) UILabel       *timeLabel;

//@property (weak, nonatomic) IBOutlet UIButton *btn1;
//@property (weak, nonatomic) IBOutlet UIButton *btn2;
//@property (weak, nonatomic) IBOutlet UIButton *btn3;
//@property (weak, nonatomic) IBOutlet UIButton *btn4;
//@property (weak, nonatomic) IBOutlet UIButton *btn5;
//@property (weak, nonatomic) IBOutlet UIButton *btn6;



//- (IBAction)btn1Clciked:(id)sender;
//- (IBAction)btn2Clicked:(id)sender;
//- (IBAction)btn3Clicked:(id)sender;
//- (IBAction)btn4Clicked:(id)sender;
//- (IBAction)btn5Clicked:(id)sender;
//- (IBAction)btn6Clicked:(id)sender;

- (IBAction)switchBtnClicked:(id)sender;




@end
