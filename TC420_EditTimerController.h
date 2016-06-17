//
//  TC420_EditTimerController.h
//  AwiseController
//
//  Created by rover on 16/6/13.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lineView.h"

@interface TC420_EditTimerController : UIViewController<UIGestureRecognizerDelegate>{
    NSMutableArray          *timerInfoArray;
    UIScrollView            *sliderScroll;
    
    UILabel                 *label1;
    UILabel                 *label2;
    UILabel                 *label3;
    UILabel                 *label4;
    UILabel                 *label5;
    
    UISlider                *slider1;
    UISlider                *slider2;
    UISlider                *slider3;
    UISlider                *slider4;
    UISlider                *slider5;
    
    UILabel                 *value_label1;
    UILabel                 *value_label2;
    UILabel                 *value_label3;
    UILabel                 *value_label4;
    UILabel                 *value_label5;
    
    lineView                *lView;
    
    int                     currentIndex;
    int                     totalIndex;
}
@property (nonatomic, retain) NSMutableArray        *timerInfoArray;      //定时器数据
@property (nonatomic, retain) UIScrollView          *sliderScroll;        //放Slider

@property (nonatomic, retain) UILabel               *label1;
@property (nonatomic, retain) UILabel               *label2;
@property (nonatomic, retain) UILabel               *label3;
@property (nonatomic, retain) UILabel               *label4;
@property (nonatomic, retain) UILabel               *label5;

@property (nonatomic, retain) UISlider              *slider1;
@property (nonatomic, retain) UISlider              *slider2;
@property (nonatomic, retain) UISlider              *slider3;
@property (nonatomic, retain) UISlider              *slider4;
@property (nonatomic, retain) UISlider              *slider5;

@property (nonatomic, retain) UILabel               *value_label1;
@property (nonatomic, retain) UILabel               *value_label2;
@property (nonatomic, retain) UILabel               *value_label3;
@property (nonatomic, retain) UILabel               *value_label4;
@property (nonatomic, retain) UILabel               *value_label5;

@property (nonatomic, retain) lineView              *lView;

@property (assign)            int                   currentIndex;          //当前帧索引     （峰值=48）
@property (assign)            int                   totalIndex;            //当前添加的总帧数（峰值=48）


@property (weak, nonatomic) IBOutlet UIImageView *timeLineImgview;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *effectMsgLabel;
@property (weak, nonatomic) IBOutlet UIButton *effect1Btn;
@property (weak, nonatomic) IBOutlet UILabel *effect1Label;
@property (weak, nonatomic) IBOutlet UIButton *effcct2Btn;
@property (weak, nonatomic) IBOutlet UILabel *effect2Label;

- (IBAction)preBtnClicked:(id)sender;
- (IBAction)nextBtnClicked:(id)sender;
- (IBAction)effect1BtnClicked:(id)sender;
- (IBAction)effected2BtnClicked:(id)sender;



@end
