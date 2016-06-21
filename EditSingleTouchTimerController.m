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
    
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
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
    date    = [timerStatusArray  objectAtIndex:0];
    percent = [timerStatusArray  objectAtIndex:1];
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
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x05;
    bt[3]   = 0x01;
    bt[10]  = 0x06;       //数据长度
    bt[18]  = 0x0d;       //结束符
    bt[19]  = 0x0a;
    
    bt[11] = timerIndex;
    bt[12] = [[timerStatusArray lastObject] intValue];
    bt[13] = [[timerStatusArray objectAtIndex:1] intValue];
    NSArray *weekArr = [[timerStatusArray objectAtIndex:2] componentsSeparatedByString:@"&"];
    Byte tt = 0b00000000;                           //八位二进制表示：周一到每天，1表示使能
    for(int i=(int)(weekArr.count-1);i>-1;i--){
        if([[weekArr objectAtIndex:i] intValue] == 1){
            tt += (1<<((weekArr.count-1)-i));
        }
    }
    bt[14] = tt;
    NSArray *timeArr = [[timerStatusArray objectAtIndex:0] componentsSeparatedByString:@":"];
    bt[15] = [[timeArr objectAtIndex:0] intValue];
    bt[16] = [[timeArr objectAtIndex:1] intValue];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}

#pragma mark ---------------------------------------------------- 处理单色触摸面板返回的数据
- (void)dataBackFormDevice:(Byte *)byte{
    switch (byte[2]) {
        case 0x05:              //设置定时器返回值
        {
            if(byte[6] == 0x00){
                [[AwiseGlobal sharedInstance] showRemindMsg:@"设置定时器失败" withTime:1.5];
            }
        }
            break;
        default:
            break;
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
        [self changeArrayValue:(int)btn.tag-1 button:btn];
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
