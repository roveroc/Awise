//
//  SingleTouchController.h
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBCircularSlider.h"

@interface SingleTouchController : UIViewController{
    TBCircularSlider *tbSlider;
    UIButton         *switchButton;
    UIView           *tempView;
    BOOL             switchState;
}
@property (nonatomic, retain) TBCircularSlider *tbSlider;            //调光圆环
@property (nonatomic, retain) UIButton         *switchButton;        //开关按钮
@property (nonatomic, retain) UIView           *tempView;            //调光圆环背景
@property (assign)            BOOL             switchState;          //开关状态

@end
