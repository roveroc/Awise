//
//  TC_MainController.h
//  AwiseController
//
//  Created by rover on 16/6/10.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+Letters.h>
#import "AwiseGlobal.h"
#import "TCPCommunication.h"
#import "RoverSqlite.h"

@interface TC_MainController : UIViewController<UIGestureRecognizerDelegate,PingDelegate,TCPSocketDelegate>{
    UISlider        *slider1;
    UISlider        *slider2;
    UISlider        *slider3;
    UISlider        *slider4;
    UISlider        *slider5;
    
    UILabel         *value_label1;
    UILabel         *value_label2;
    UILabel         *value_label3;
    UILabel         *value_label4;
    UILabel         *value_label5;
    
    int             value1;
    int             value2;
    int             value3;
    int             value4;
    int             value5;
    
    UIImageView     *effectImgView;             //跳转到自定义效果按钮
    UIImageView     *lightImgView;              //闪电
    UIImageView     *cloudyImgView;             //多云
    
    NSMutableArray          *deviceInfo;
}
@property (nonatomic, retain) UISlider        *slider1;                 //五个滑条
@property (nonatomic, retain) UISlider        *slider2;
@property (nonatomic, retain) UISlider        *slider3;
@property (nonatomic, retain) UISlider        *slider4;
@property (nonatomic, retain) UISlider        *slider5;

@property (nonatomic, retain) UILabel         *value_label1;            //五个滑条对应的label
@property (nonatomic, retain) UILabel         *value_label2;
@property (nonatomic, retain) UILabel         *value_label3;
@property (nonatomic, retain) UILabel         *value_label4;
@property (nonatomic, retain) UILabel         *value_label5;

@property (assign)            int             value1;
@property (assign)            int             value2;
@property (assign)            int             value3;
@property (assign)            int             value4;
@property (assign)            int             value5;

@property (nonatomic, retain) UIImageView     *effectImgView;
@property (nonatomic, retain) UIImageView     *lightImgView;
@property (nonatomic, retain) UIImageView     *cloudyImgView;

@property (nonatomic, retain) NSMutableArray        *deviceInfo;          //当前设备的所有信息


@end
