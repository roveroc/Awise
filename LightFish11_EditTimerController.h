//
//  LightFish11_EditTimerController.h
//  AwiseController
//
//  Created by rover on 16/6/29.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"
#import "DVSwitch.h"
#import "lineView.h"
#import "SaveDataView.h"


@protocol LightFish11EditTimerDelegate <NSObject>

- (void)LightFish11_dataSaved;

@end

@interface LightFish11_EditTimerController : UIViewController<LightFish11EditTimerDelegate,SaveDataDelegate,LineViewDelegate>{
    UIScrollView        *backScrollView;
    UILabel             *msgLabel;
    UIButton            *effectBtn1;        //四个Btn No Use
    UIButton            *effectBtn2;
    UIButton            *effectBtn3;
    UIButton            *effectBtn4;
    UILabel             *speedLabel;
    UISlider            *speedSlider;
    UILabel             *speedValueLabel;
    DVSwitch            *effectSwitch;
    int                 selectEffect;
    
    NSMutableArray      *timerInfoArray;        //定时器的每帧的数据
    NSMutableArray      *timerWeekArray;        //定时器在哪些天运行
    NSMutableArray      *currentFrameArray;
    NSString            *fileName;
    lineView            *lView;
    
    int                 currentIndex;
    int                 totalIndex;
    
    SaveDataView        *saveView;
    UIView              *saveViewBack;
    
    id<LightFish11EditTimerDelegate>    delegate;
    
    UILabel                 *label1;    //五个通道
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
}

@property (nonatomic, retain) UIScrollView  *backScrollView;    //用于适配界面的ScrollView
@property (nonatomic, retain) UILabel       *msgLabel;          //提示信息
@property (nonatomic, retain) UIButton      *effectBtn1;        //四选一的效果
@property (nonatomic, retain) UIButton      *effectBtn2;
@property (nonatomic, retain) UIButton      *effectBtn3;
@property (nonatomic, retain) UIButton      *effectBtn4;
@property (nonatomic, retain) UILabel       *speedLabel;
@property (nonatomic, retain) UISlider      *speedSlider;
@property (nonatomic, retain) UILabel       *speedValueLabel;

@property (nonatomic, retain) NSMutableArray        *timerInfoArray;
@property (nonatomic, retain) NSMutableArray        *timerWeekArray;
@property (nonatomic, retain) NSMutableArray        *currentFrameArray;
@property (nonatomic, retain) NSString              *fileName;
@property (nonatomic, retain) lineView              *lView;
@property (assign)            int                   currentIndex;
@property (assign)            int                   totalIndex;
@property (nonatomic, retain) SaveDataView          *saveView;
@property (nonatomic, retain) UIView                *saveViewBack;

@property (nonatomic, retain) DVSwitch              *effectSwitch;
@property (assign)            int                   selectEffect;
@property (nonatomic, retain) id<LightFish11EditTimerDelegate>  delegate;

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


@property (weak, nonatomic) IBOutlet UIImageView *timelineView;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)preBtnClicked:(id)sender;
- (IBAction)nextBtnClicked:(id)sender;





@end
