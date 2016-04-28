//
//  EditSingleTouchTimerController.m
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "EditSingleTouchTimerController.h"

@interface EditSingleTouchTimerController ()

@end

@implementation EditSingleTouchTimerController
@synthesize timerIndex;
@synthesize timerStatusArray;
@synthesize weekArray;
@synthesize date;
@synthesize percent;
@synthesize _switch;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //周一到每天，1表示选中
    weekArray = [[NSMutableArray alloc] initWithArray:(NSArray *)[[timerStatusArray objectAtIndex:2] componentsSeparatedByString:@"&"]];
    for(int i=0;i<weekArray.count;i++){
        UIButton *btn = [self.view viewWithTag:i+1];
        if ([[weekArray objectAtIndex:i] intValue] == 1){
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }else if ([[weekArray objectAtIndex:i] intValue] == 0){
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    date    = [timerStatusArray objectAtIndex:0];
    percent = [timerStatusArray objectAtIndex:1];
    _switch = [[timerStatusArray objectAtIndex:3] boolValue];
    
    [self.datePicker setDate:[self stringToDate:date]];
    self.valueSlider.value = [percent intValue];
    self.valueLabel.text = [percent stringByAppendingString:@"%"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(saveTimer)];                      //保存按钮
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------------------------------------------- 保存
- (void)saveTimer{
    date    = [self dateToString:self.datePicker.date];
    percent = [NSString stringWithFormat:@"%d",(int)self.valueSlider.value];
    NSString *week = [weekArray componentsJoinedByString:@"&"];
    [timerStatusArray replaceObjectAtIndex:0 withObject:date];
    [timerStatusArray replaceObjectAtIndex:1 withObject:percent];
    [timerStatusArray replaceObjectAtIndex:2 withObject:week];
    [[AwiseGlobal sharedInstance].singleTouchTimerArray replaceObjectAtIndex:self.timerIndex withObject:timerStatusArray];
    NSString *filePath = [[AwiseGlobal sharedInstance] getFilePath:AwiseSingleTouchTimer];
    if([[AwiseGlobal sharedInstance].singleTouchTimerArray writeToFile:filePath atomically:YES]){
        [self.delegate singleTouchTimerSaved];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"保存失败");
    }
}


#pragma mark -------------------------------------------- 亮度值改变
- (IBAction)valueSliderChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int value = (int)slider.value;
    self.valueLabel.text = [NSString stringWithFormat:@"%d%%",value];
}

#pragma mark -------------------------------------------- 将NSDate转化成字符串
- (NSString *)dateToString:(NSDate *)dt{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];   //实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"HH:mm"];                            //设定时间格式
    NSString *dateString = [dateFormat stringFromDate:dt];
    return dateString;
}

#pragma mark -------------------------------------------- 讲String转换为NSDate
- (NSDate *)stringToDate:(NSString *)string{
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];  //实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"HH:mm"];                           //设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate *dt =[dateFormat1 dateFromString:string];
    return dt;
}

#pragma mark -------------------------------------------- 时间选择器值改变
- (IBAction)datePickerChange:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSLog(@"date = %@",[self dateToString:picker.date]);
}


#pragma mark -------------------------------------------- 点击选择星期
- (IBAction)weekDayClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 8){
        if([[weekArray objectAtIndex:7] intValue] == 0){
            for(int i=0;i<weekArray.count;i++){
                [weekArray replaceObjectAtIndex:i withObject:@"1"];
                UIButton *temp = (UIButton *)[self.view viewWithTag:i+1];
                [temp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }else if([[weekArray objectAtIndex:7] intValue] == 1){
            for(int i=0;i<weekArray.count;i++){
                [weekArray replaceObjectAtIndex:i withObject:@"0"];
                UIButton *temp = (UIButton *)[self.view viewWithTag:i+1];
                [temp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    else{
        [self changeArrayValue:btn.tag-1 button:btn];
        if([weekArray containsObject:@"0"]){
            UIButton *temp = (UIButton *)[self.view viewWithTag:8];
            [temp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [weekArray replaceObjectAtIndex:7 withObject:@"0"];
        }
        int temp = 0;
        for(int i=0;i<weekArray.count-1;i++){
            if([[weekArray objectAtIndex:i] intValue] == 1){
                temp++;
            }
        }
        if(temp == weekArray.count-1){
            for(int i=0;i<weekArray.count;i++){
                [weekArray replaceObjectAtIndex:i withObject:@"1"];
                UIButton *temp = (UIButton *)[self.view viewWithTag:i+1];
                [temp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark -------------------------------------------- 改变数组值和改变button的选中状态
- (void)changeArrayValue:(int)index button:(UIButton *)btn{
    if([[weekArray objectAtIndex:index] intValue] == 1){
        [weekArray replaceObjectAtIndex:index withObject:@"0"];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else if([[weekArray objectAtIndex:index] intValue] == 0){
        [weekArray replaceObjectAtIndex:index withObject:@"1"];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

@end
