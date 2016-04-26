//
//  EditSingleTouchTimerController.h
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"

@interface EditSingleTouchTimerController : UIViewController{
    int                        timerIndex;
    NSMutableArray             *weekStatusArray;
}
@property (assign) int                              timerIndex;              //记录编辑哪一个定时器
@property (nonatomic, retain) NSMutableArray        *weekStatusArray;        //记录星期的点击状态

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
