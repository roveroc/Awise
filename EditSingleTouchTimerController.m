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
@synthesize weekStatusArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weekStatusArray = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];       //周一到每天，1表示选中
    for(int i=0;i<weekStatusArray.count;i++){
        UIButton *btn = [self.view viewWithTag:i+1];
        if ([[weekStatusArray objectAtIndex:i] intValue] == 1){
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }else if ([[weekStatusArray objectAtIndex:i] intValue] == 0){
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
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
    
}


#pragma mark -------------------------------------------- 亮度值改变
- (IBAction)valueSliderChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int value = (int)slider.value;
    self.valueLabel.text = [NSString stringWithFormat:@"%d%%",value];
}

#pragma mark - 将NSDate转化成字符串
- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"HH:mm"];                         //设定时间格式
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
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
        if([[weekStatusArray objectAtIndex:7] intValue] == 0){
            for(int i=0;i<weekStatusArray.count;i++){
                [weekStatusArray replaceObjectAtIndex:i withObject:@"1"];
                UIButton *temp = (UIButton *)[self.view viewWithTag:i+1];
                [temp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }else if([[weekStatusArray objectAtIndex:7] intValue] == 1){
            for(int i=0;i<weekStatusArray.count;i++){
                [weekStatusArray replaceObjectAtIndex:i withObject:@"0"];
                UIButton *temp = (UIButton *)[self.view viewWithTag:i+1];
                [temp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    else{
        [self changeArrayValue:btn.tag-1 button:btn];
        if([weekStatusArray containsObject:@"0"]){
            UIButton *temp = (UIButton *)[self.view viewWithTag:8];
            [temp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [weekStatusArray replaceObjectAtIndex:7 withObject:@"0"];
        }
        int temp = 0;
        for(int i=0;i<weekStatusArray.count-1;i++){
            if([[weekStatusArray objectAtIndex:i] intValue] == 1){
                temp++;
            }
        }
        if(temp == weekStatusArray.count-1){
            for(int i=0;i<weekStatusArray.count;i++){
                [weekStatusArray replaceObjectAtIndex:i withObject:@"1"];
                UIButton *temp = (UIButton *)[self.view viewWithTag:i+1];
                [temp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark -------------------------------------------- 改变数组值和改变button的选中状态
- (void)changeArrayValue:(int)index button:(UIButton *)btn{
    if([[weekStatusArray objectAtIndex:index] intValue] == 1){
        [weekStatusArray replaceObjectAtIndex:index withObject:@"0"];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else if([[weekStatusArray objectAtIndex:index] intValue] == 0){
        [weekStatusArray replaceObjectAtIndex:index withObject:@"1"];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

@end
