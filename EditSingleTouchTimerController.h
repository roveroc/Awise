//
//  EditSingleTouchTimerController.h
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"

@protocol saveSingleTouchTimerDelegate <NSObject>

- (void)singleTouchTimerSaved;      //保存成功后调用

@end

@interface EditSingleTouchTimerController : UIViewController<saveSingleTouchTimerDelegate>{
    int                        timerIndex;
    NSMutableArray             *timerStatusArray;
    NSMutableArray             *weekArray;
    NSString                   *date;
    NSString                   *percent;
    BOOL                       _switch;
    id<saveSingleTouchTimerDelegate>    delegate;
}
@property (assign) int                              timerIndex;               //记录编辑哪一个定时器
@property (nonatomic, retain) NSMutableArray        *timerStatusArray;        //当前定时器的所有属性
@property (nonatomic, retain) NSMutableArray        *weekArray;               //星期
@property (nonatomic, retain) NSString              *date;                    //时间
@property (nonatomic, retain) NSString              *percent;                 //亮度百分比
@property (assign) BOOL                             _switch;                  //开关状态
@property (nonatomic, retain) id<saveSingleTouchTimerDelegate>  delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *monday;
@property (weak, nonatomic) IBOutlet UIButton *tuesday;
@property (weak, nonatomic) IBOutlet UIButton *wednesday;
@property (weak, nonatomic) IBOutlet UIButton *thursday;
@property (weak, nonatomic) IBOutlet UIButton *friday;
@property (weak, nonatomic) IBOutlet UIButton *saturday;
@property (weak, nonatomic) IBOutlet UIButton *sunday;
@property (weak, nonatomic) IBOutlet UIButton *allday;

@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (IBAction)valueSliderChange:(id)sender;
- (IBAction)datePickerChange:(id)sender;
- (IBAction)weekDayClicked:(id)sender;



@end
