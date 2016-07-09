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
#import "EditTimerController.h"
#import "ManualController.h"
#import "LightingModeController.h"
#import "DeviceMannagerController.h"
#import "MannagerController.h"

@interface LightFishController : UIViewController<TCPSocketDelegate,PingDelegate,TimerStartDelegate,LightingStartDelegate>{
    int                     pipe1Value;
    int                     pipe2Value;
    int                     pipe3Value;
    NSMutableArray          *dataArray;
    NSTimer                 *sendTimer;
    NSMutableArray          *deviceInfo;
    RoverSqlite             *sql;
    NSTimer                 *sliderTimer;
    BOOL                    sliderFlag;
    
//用来控制扫码次数，在局域网内第一次没有发现设备，则在进行一次扫码
    int                     scannCount;
}
@property (assign)            int                   pipe1Value;           //三个通道值
@property (assign)            int                   pipe2Value;
@property (assign)            int                   pipe3Value;
@property (nonatomic, retain) NSMutableArray        *dataArray;           //用来充当数据发送队列
@property (nonatomic, retain) NSTimer               *sendTimer;           //定时器轮询队列是否有数据需要发送
@property (nonatomic, retain) NSMutableArray        *deviceInfo;          //当前设备的所有信息
@property (nonatomic, retain) RoverSqlite           *sql;                 //操作数据库的对象
@property (nonatomic, retain) NSTimer               *sliderTimer;         //滑动条取值定时器
@property (assign)            BOOL                  sliderFlag;           //滑动条取值标识
@property (assign)            int                   scannCount;



- (IBAction)switchBtnClicked:(id)sender;


//new Interface
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *timer1Button;
@property (weak, nonatomic) IBOutlet UIButton *timer2Button;
@property (weak, nonatomic) IBOutlet UIButton *timer3Button;
@property (weak, nonatomic) IBOutlet UIButton *lightingButton;
@property (weak, nonatomic) IBOutlet UIButton *cloudyButton;
@property (weak, nonatomic) IBOutlet UIButton *customButton;

@property (weak, nonatomic) IBOutlet UISwitch *timer1Switch;
@property (weak, nonatomic) IBOutlet UISwitch *timer2Switch;
@property (weak, nonatomic) IBOutlet UISwitch *timer3Switch;
@property (weak, nonatomic) IBOutlet UISwitch *timer4Switch;
@property (weak, nonatomic) IBOutlet UISwitch *timer5Switch;
@property (weak, nonatomic) IBOutlet UISwitch *timer6Switch;

@property (weak, nonatomic) IBOutlet UISlider *pipe1Slider;
@property (weak, nonatomic) IBOutlet UISlider *pipe2Slider;
@property (weak, nonatomic) IBOutlet UISlider *pipe3Slider;

@property (weak, nonatomic) IBOutlet UILabel *pipe1Label;
@property (weak, nonatomic) IBOutlet UILabel *pipe2Label;
@property (weak, nonatomic) IBOutlet UILabel *pipe3Label;

- (IBAction)switchButtonClicked:(id)sender;
- (IBAction)switchOperate:(id)sender;
- (IBAction)pipeSliderValueChange:(id)sender;

- (IBAction)modeButtonClicked:(id)sender;





@end
