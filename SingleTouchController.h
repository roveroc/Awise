//
//  SingleTouchController.h
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBCircularSlider.h"
#import "TCPCommunication.h"
#import "SingleTouchTimerView.h"
#import "SingleTouchScene.h"
#import "AwiseGlobal.h"
#import "EditSingleTouchSceneController.h"

@interface SingleTouchController : UIViewController<saveSingleTouchTimerDelegate,
                                                    EditSceneDelegate,
                                                    TCPSocketDelegate,
                                                    PingDelegate>{
    TBCircularSlider        *tbSlider;
    UIButton                *switchButton;
    UIView                  *tempView;
    BOOL                    switchState;
    SingleTouchTimerView    *timerTable;
    SingleTouchScene        *sceneView;
    CGPoint                 centerPoint;
    NSMutableArray          *deviceInfo;
    NSString                *deviceIP;
}
@property (nonatomic, retain) TBCircularSlider      *tbSlider;            //调光圆环
@property (nonatomic, retain) UIButton              *switchButton;        //开关按钮
@property (nonatomic, retain) UIView                *tempView;            //调光圆环背景
@property (assign)            BOOL                  switchState;          //开关状态
@property (nonatomic, retain) SingleTouchTimerView  *timerTable;          //定时器Table
@property (nonatomic, retain) SingleTouchScene      *sceneView;           //场景View
@property (nonatomic, retain) NSMutableArray        *deviceInfo;          //当前设备的所有信息
@property (nonatomic, retain) NSString              *deviceIP;            //当前设备的IP地址

@property (weak, nonatomic) IBOutlet UISegmentedControl *controlSegment;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn1;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn2;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn3;

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;




- (IBAction)SwitchControlMode:(id)sender;
- (IBAction)defauleValueClicked:(id)sender;



@end
