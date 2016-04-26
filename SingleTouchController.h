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

@interface SingleTouchController : UIViewController{
    TBCircularSlider        *tbSlider;
    UIButton                *switchButton;
    UIView                  *tempView;
    BOOL                    switchState;
    TCPCommunication        *tcpSocket;
    SingleTouchTimerView    *timerTable;
    SingleTouchScene        *sceneView;
    CGPoint                 centerPoint;
    CGPoint                 defaultCenter1;
    CGPoint                 defaultCenter2;
    CGPoint                 defaultCenter3;
}
@property (nonatomic, retain) TBCircularSlider      *tbSlider;            //调光圆环
@property (nonatomic, retain) UIButton              *switchButton;        //开关按钮
@property (nonatomic, retain) UIView                *tempView;            //调光圆环背景
@property (assign)            BOOL                  switchState;          //开关状态
@property (nonatomic, retain) TCPCommunication      *tcpSocket;           //TCPSocket套接字
@property (nonatomic, retain) SingleTouchTimerView  *timerTable;          //定时器Table
@property (nonatomic, retain) SingleTouchScene      *sceneView;           //场景View


@property (weak, nonatomic) IBOutlet UISegmentedControl *controlSegment;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn1;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn2;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn3;


- (IBAction)SwitchControlMode:(id)sender;
- (IBAction)defauleValueClicked:(id)sender;



@end
