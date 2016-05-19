//
//  MainController.h
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"
#import "RoverSqlite.h"

@interface LightFishController : UIViewController<TCPSocketDelegate,PingDelegate>{
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
    NSMutableArray          *deviceInfo;
    RoverSqlite             *sql;
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
@property (nonatomic, retain) NSMutableArray        *deviceInfo;          //当前设备的所有信息
@property (nonatomic, retain) RoverSqlite           *sql;                 //操作数据库的对象


- (IBAction)switchBtnClicked:(id)sender;




@end
