//
//  DetailEditController.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "DetailEditController.h"
#import "lineView.h"

@interface DetailEditController ()

@end

@implementation DetailEditController
@synthesize navTitle;
@synthesize singleArray;
@synthesize lineview;
@synthesize index;
@synthesize tempArray;
@synthesize fuckFlag;
@synthesize isChange;

@synthesize lab1,lab2,lab3,lab4;
@synthesize slider1,slider2,slider3,slider4;
@synthesize valueLab1,valueLab2,valueLab3,valueLab4;


- (UILabel *)customLabel:(UILabel *)lab rect:(CGRect)ret text:(NSString *)txt{
    lab = [[UILabel alloc] initWithFrame:ret];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = txt;
    lab.font = [UIFont fontWithName:@"Arial" size:15];
    lab.textColor = [UIColor blackColor];
    [self.view addSubview:lab];
    return lab;
}

- (UISlider *)customSlider:(UISlider *)slider rect:(CGRect)ret{
    slider = [[UISlider alloc] initWithFrame:ret];
    slider.backgroundColor = [UIColor clearColor];
    slider.maximumValue = 100;
    slider.minimumValue = 0;
    slider.value = 50;
    [self.view addSubview:slider];
    return slider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backFun)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.title = navTitle;
    self.fuckFlag = NO;
    self.isChange = NO;
    
    self.lineview = [[lineView alloc] init];
    self.lineview.frame = CGRectMake(13, 70, SCREEN_WIDHT-28, 100);
    [self.lineview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.lineview];
    
    [self.datepicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    NSString *time = [self.singleArray objectAtIndex:0];
    int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.datepicker setCountDownDuration:tv];
    });
    
    [AwiseGlobal sharedInstance].freshFlag = NO;
    self.tempArray = [self.singleArray mutableCopy];//[[NSMutableArray alloc] initWithArray:(NSArray *)self.singleArray];
    
    CGRect re1,re2,re3,re4;
    CGRect re1_1,re2_1,re3_1,re4_1;
    CGRect re1_2,re2_2,re3_2,re4_2;
    if(iPhone4){
        re1 = CGRectMake(13, 406-50, 23, 21);
        re2 = CGRectMake(13, 445-55, 23, 21);
        re3 = CGRectMake(13, 484-60, 23, 21);
        re4 = CGRectMake(13, 526-70, 23, 21);
        
        re1_1 = CGRectMake(39, 399-50, 236, 31);
        re2_1 = CGRectMake(39, 439-55, 236, 31);
        re3_1 = CGRectMake(39, 478-60, 236, 31);
        re4_1 = CGRectMake(39, 521-70, 236, 31);
        
        re1_2 = CGRectMake(280, 406-50, 46, 21);
        re2_2 = CGRectMake(280, 445-55, 46, 21);
        re3_2 = CGRectMake(280, 484-60, 46, 21);
        re4_2 = CGRectMake(280, 526-70, 46, 21);
    }else if(iPhone5){
        re1 = CGRectMake(13, 406, 23, 21);
        re2 = CGRectMake(13, 445, 23, 21);
        re3 = CGRectMake(13, 484, 23, 21);
        re4 = CGRectMake(13, 526, 23, 21);
        
        re1_1 = CGRectMake(39, 399, 236, 31);
        re2_1 = CGRectMake(39, 439, 236, 31);
        re3_1 = CGRectMake(39, 478, 236, 31);
        re4_1 = CGRectMake(39, 521, 236, 31);
        
        re1_2 = CGRectMake(280, 406, 46, 21);
        re2_2 = CGRectMake(280, 445, 46, 21);
        re3_2 = CGRectMake(280, 484, 46, 21);
        re4_2 = CGRectMake(280, 526, 46, 21);
    }else{
        re1 = CGRectMake(13, 406, 23, 21);
        re2 = CGRectMake(13, 445, 23, 21);
        re3 = CGRectMake(13, 484, 23, 21);
        re4 = CGRectMake(13, 526, 23, 21);
        
        re1_1 = CGRectMake(39, 399, SCREEN_WIDHT-39-56, 31);
        re2_1 = CGRectMake(39, 439, SCREEN_WIDHT-39-56, 31);
        re3_1 = CGRectMake(39, 478, SCREEN_WIDHT-39-56, 31);
        re4_1 = CGRectMake(39, 521, SCREEN_WIDHT-39-56, 31);
        
        re1_2 = CGRectMake(39+(SCREEN_WIDHT-39-56)+8, 406, 46, 21);
        re2_2 = CGRectMake(39+(SCREEN_WIDHT-39-56)+8, 445, 46, 21);
        re3_2 = CGRectMake(39+(SCREEN_WIDHT-39-56)+8, 484, 46, 21);
        re4_2 = CGRectMake(39+(SCREEN_WIDHT-39-56)+8, 526, 46, 21);
    }
    
    [self.slider1 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider1 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    [self.slider2 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider2 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    [self.slider3 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider3 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    self.lab1 = [self customLabel:self.lab1 rect:re1 text:@"A:"];
    self.lab2 = [self customLabel:self.lab2 rect:re2 text:@"B:"];
    self.lab3 = [self customLabel:self.lab3 rect:re3 text:@"C:"];
//    self.lab4 = [self customLabel:self.lab4 rect:re4 text:@"W:"];
    
    self.slider1 = [self customSlider:self.slider1 rect:re1_1];
    self.slider2 = [self customSlider:self.slider2 rect:re2_1];
    self.slider3 = [self customSlider:self.slider3 rect:re3_1];
//    self.slider4 = [self customSlider:self.slider4 rect:re4_1];
    
    [self.slider1 addTarget:self action:@selector(slider1ValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider2 addTarget:self action:@selector(slider2ValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider3 addTarget:self action:@selector(slider3ValueChange:) forControlEvents:UIControlEventValueChanged];
//    [self.slider4 addTarget:self action:@selector(slider4ValueChange:) forControlEvents:UIControlEventValueChanged];
    
    self.valueLab1 = [self customLabel:self.valueLab1 rect:re1_2 text:[NSString stringWithFormat:@"%d%%",(int)self.slider1.value]];
    self.valueLab2 = [self customLabel:self.valueLab2 rect:re2_2 text:[NSString stringWithFormat:@"%d%%",(int)self.slider2.value]];
    self.valueLab3 = [self customLabel:self.valueLab3 rect:re3_2 text:[NSString stringWithFormat:@"%d%%",(int)self.slider3.value]];
//    self.valueLab4 = [self customLabel:self.valueLab4 rect:re4_2 text:[NSString stringWithFormat:@"%d%%",(int)self.slider4.value]];

    
    [self labelValue];
}


- (void)labelValue{
    self.slider1.value = [[self.singleArray objectAtIndex:3] intValue];
    self.slider2.value = [[self.singleArray objectAtIndex:2] intValue];
    self.slider3.value = [[self.singleArray objectAtIndex:1] intValue];
//    self.slider4.value = [[self.singleArray objectAtIndex:4] intValue];
    
    self.valueLab1.text = [NSString stringWithFormat:@"%d%%",(int)self.slider1.value];
    self.valueLab2.text = [NSString stringWithFormat:@"%d%%",(int)self.slider2.value];
    self.valueLab3.text = [NSString stringWithFormat:@"%d%%",(int)self.slider3.value];
    self.valueLab4.text = [NSString stringWithFormat:@"%d%%",(int)self.slider4.value];
}

#pragma mark - 将NSDate转化成字符串
- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

#pragma mark - 讲String转换为NSDate
- (NSDate *)stringToDate:(NSString *)string{
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate *date =[dateFormat1 dateFromString:string];
    return date;
}


#pragma mark - 时间点改变
- (void)dateChange:(UIDatePicker *)picker{
    int pre;
    int next;
    if(self.index == 0){
        pre = (int)[AwiseGlobal sharedInstance].lineArray.count -1;
        next = self.index + 1;
    }
    else if(self.index == [AwiseGlobal sharedInstance].lineArray.count -1){
        pre = self.index - 1;
        next = 0;
    }
    else{
        pre = self.index - 1;
        next = self.index + 1;
    }
    NSString *tt = [[[AwiseGlobal sharedInstance].lineArray objectAtIndex:pre] objectAtIndex:0];
    NSArray *timeArr = [tt componentsSeparatedByString:@":"];
    int value = [[timeArr objectAtIndex:0] intValue]*60*60 + [[timeArr objectAtIndex:1] intValue]*60;
    
    NSString *tt1 = [[[AwiseGlobal sharedInstance].lineArray objectAtIndex:next] objectAtIndex:0];
    NSArray *timeArr1 = [tt1 componentsSeparatedByString:@":"];
    int value1 = [[timeArr1 objectAtIndex:0] intValue]*60*60 + [[timeArr1 objectAtIndex:1] intValue]*60;
    
    NSString *currentS = [[self dateToString:picker.date] componentsSeparatedByString:@" "][1];
    NSArray *timeArr2 = [currentS componentsSeparatedByString:@":"];
    int value2 = [[timeArr2 objectAtIndex:0] intValue]*60*60 + [[timeArr2 objectAtIndex:1] intValue]*60;
    
    if(value2 == value){
        [self.datepicker setCountDownDuration:value2+60];
    }
    else if(value1 == value){
        [self.datepicker setCountDownDuration:value2+60];
    }
    
    NSString *_currentS = [[self dateToString:picker.date] componentsSeparatedByString:@" "][1];
    [self.singleArray replaceObjectAtIndex:0 withObject:_currentS];
    [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:self.index withObject:self.singleArray];
    [self sortTheTime];
    for(int i=0;i<[AwiseGlobal sharedInstance].lineArray.count;i++){
        NSString *_s = [AwiseGlobal sharedInstance].lineArray[i][0];
        if([_s isEqualToString:_currentS]){
            self.index = i;
            break;
        }
    }
    self.navigationItem.title = [NSString stringWithFormat:@"Edit Timer%d--%d",[AwiseGlobal sharedInstance].timerNumber,self.index+1];
    self.navTitle = [NSString stringWithFormat:@"Edit Timer%d--%d",[AwiseGlobal sharedInstance].timerNumber,self.index+1];
    
    [self reloadLineview];

    self.fuckFlag = YES;
    self.isChange = YES;
}

#pragma mark - 给数组排序，根据时间的先后
- (void)sortTheTime{
    for(int j=0;j<[AwiseGlobal sharedInstance].lineArray.count-1;j++){
        for(int i=0;i<[AwiseGlobal sharedInstance].lineArray.count-1-j;i++){
            NSArray *timeArr1 = [[AwiseGlobal sharedInstance].lineArray[i][0] componentsSeparatedByString:@":"];
            int value1 = [[timeArr1 objectAtIndex:0] intValue]*60*60 + [[timeArr1 objectAtIndex:1] intValue]*60;
            
            NSArray *timeArr2 = [[AwiseGlobal sharedInstance].lineArray[i+1][0] componentsSeparatedByString:@":"];
            int value2 = [[timeArr2 objectAtIndex:0] intValue]*60*60 + [[timeArr2 objectAtIndex:1] intValue]*60;
            
            if(value1 > value2){
                [[AwiseGlobal sharedInstance].lineArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
        }
    }
}

#pragma mark - 保存
- (void)SaveData{
    [AwiseGlobal sharedInstance].freshFlag = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 返回
- (void)backFun{
    if(self.isChange == YES){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"had change,do you want to save?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        alert.tag = 3;
        alert.delegate = self;
        [alert show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadLineview{
    if(self.lineview != nil){
        [self.lineview removeFromSuperview];
        self.lineview = [[lineView alloc] init];
        self.lineview.frame = CGRectMake(13, 70, SCREEN_WIDHT-28, 100);
        [self.lineview setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.lineview];
    }
}

- (void)slider1ValueChange:(id)sender {
    UISlider *s = (UISlider *)sender;
    self.valueLab1.text = [NSString stringWithFormat:@"%d%%",(int)s.value];
    [self.singleArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",(int)s.value]];
    [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:self.index withObject:self.singleArray];
    [self reloadLineview];
    self.isChange = YES;
}

- (void)slider2ValueChange:(id)sender {
    UISlider *s = (UISlider *)sender;
    self.valueLab2.text = [NSString stringWithFormat:@"%d%%",(int)s.value];
    [self.singleArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",(int)s.value]];
    [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:self.index withObject:self.singleArray];
    [self reloadLineview];
    self.isChange = YES;
}

- (void)slider3ValueChange:(id)sender {
    UISlider *s = (UISlider *)sender;
    self.valueLab3.text = [NSString stringWithFormat:@"%d%%",(int)s.value];
    [self.singleArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",(int)s.value]];
    [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:self.index withObject:self.singleArray];
    [self reloadLineview];
    self.isChange = YES;
}

- (void)slider4ValueChange:(id)sender {
    UISlider *s = (UISlider *)sender;
    self.valueLab4.text = [NSString stringWithFormat:@"%d%%",(int)s.value];
    [self.singleArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d",(int)s.value]];
    [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:self.index withObject:self.singleArray];
    [self reloadLineview];
    self.isChange = YES;
}

- (IBAction)previousFrame:(id)sender {
    int value = [[navTitle componentsSeparatedByString:@"--"][1] intValue];
    if(value == 1){
        NSLog(@"已经是第一帧");
        return;
    }
    if(self.isChange == YES){
        self.index --;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"had change,do you want to save?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
//        alert.tag = 1;
//        alert.delegate = self;
//        [alert show];
        int value = [[navTitle componentsSeparatedByString:@"--"][1] intValue];
        int v = value > 1 ? --value : 1;
        NSArray *arr = [navTitle componentsSeparatedByString:@"--"];
        self.navigationItem.title = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        self.navTitle = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        
        NSMutableArray *tt = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray objectAtIndex:value-1]];
        
        self.singleArray = [tt mutableCopy];
        self.tempArray   = [tt mutableCopy];
        
        NSString *time   = [self.singleArray objectAtIndex:0];
        int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        [self.datepicker setCountDownDuration:tv];
        [self labelValue];
    }
    else{
        int v = value > 1 ? --value : 1;
        NSArray *arr = [navTitle componentsSeparatedByString:@"--"];
        self.navigationItem.title = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        self.navTitle = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        
//        self.singleArray = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray objectAtIndex:value-1]];
//        self.tempArray = [[NSMutableArray alloc] initWithArray:(NSArray *)self.singleArray];
        
        [self.singleArray removeAllObjects];
        NSMutableArray *tt = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray objectAtIndex:value-1]];
        self.singleArray = [tt mutableCopy];
        [self.tempArray removeAllObjects];
        self.tempArray = [tt mutableCopy];
        
        NSString *time = [self.singleArray objectAtIndex:0];
        int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        [self.datepicker setCountDownDuration:tv];
        [self labelValue];
        self.index --;
        [self labelValue];
    }
}

- (IBAction)nextFrame:(id)sender {
    int value = [[navTitle componentsSeparatedByString:@"--"][1] intValue];
    if(value == [AwiseGlobal sharedInstance].lineArray.count){
        NSLog(@"已经是最后帧");
        return;
    }
    if(self.isChange == YES){
        self.index ++;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"had change,do you want to save?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
//        alert.tag = 2;
//        alert.delegate = self;
//        [alert show];
        
        int total = (int)[AwiseGlobal sharedInstance].lineArray.count;
        int value = [[navTitle componentsSeparatedByString:@"--"][1] intValue];
        int v = value < total ? ++value : total;
        NSArray *arr = [navTitle componentsSeparatedByString:@"--"];
        self.navigationItem.title = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        self.navTitle = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        
        NSMutableArray *tt = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray objectAtIndex:value-1]];
        
        self.singleArray = [tt mutableCopy];
        self.tempArray   = [tt mutableCopy];
        
        NSString *time   = [self.singleArray objectAtIndex:0];
        int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        [self.datepicker setCountDownDuration:tv];
        [self labelValue];
    }
    else{
        int total = (int)[AwiseGlobal sharedInstance].lineArray.count;
        int value = [[navTitle componentsSeparatedByString:@"--"][1] intValue];
        int v = value < total ? ++value : total;
        NSArray *arr = [navTitle componentsSeparatedByString:@"--"];
        self.navigationItem.title = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        self.navTitle = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        
        [self.singleArray removeAllObjects];
        NSMutableArray *tt = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray objectAtIndex:value-1]];
        self.singleArray = [tt mutableCopy];
        [self.tempArray removeAllObjects];
        self.tempArray = [tt mutableCopy];
        NSString *time   = [self.singleArray objectAtIndex:0];
        int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        [self.datepicker setCountDownDuration:tv];
        [self labelValue];
        
        NSLog(@"lineArray lineArray = %@",[AwiseGlobal sharedInstance].lineArray);
        self.index ++;
        [self labelValue];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.isChange = NO;
    if(alertView.tag == 1){
        NSLog(@"上一帧");
        int value = [[navTitle componentsSeparatedByString:@"--"][1] intValue];
        int v = value > 1 ? --value : 1;
        NSArray *arr = [navTitle componentsSeparatedByString:@"--"];
        self.navigationItem.title = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        self.navTitle = [NSString stringWithFormat:@"%@--%d",arr[0],v];

        if(buttonIndex == 0){
            NSLog(@"不保存");
            [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:[arr[1] intValue]-1 withObject:self.tempArray];
        }
        else if (buttonIndex == 1){
            NSLog(@"保存");
        }
        NSMutableArray *tt = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray objectAtIndex:value-1]];
        
        self.singleArray = [tt mutableCopy];
        self.tempArray   = [tt mutableCopy];
        
        NSString *time   = [self.singleArray objectAtIndex:0];
        int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        [self.datepicker setCountDownDuration:tv];
        NSLog(@"index = %d  value = %d",self.index,value-1);
    }
    else if (alertView.tag == 2){
        NSLog(@"下一帧");
        int total = (int)[AwiseGlobal sharedInstance].lineArray.count;
        int value = [[navTitle componentsSeparatedByString:@"--"][1] intValue];
        int v = value < total ? ++value : total;
        NSArray *arr = [navTitle componentsSeparatedByString:@"--"];
        self.navigationItem.title = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        self.navTitle = [NSString stringWithFormat:@"%@--%d",arr[0],v];
        if(buttonIndex == 0){
            NSLog(@"不保存");
            
            NSLog(@"self.tempArray = %@",self.tempArray);
            
            [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:[arr[1] intValue]-1 withObject:self.tempArray];
        }
        else if (buttonIndex == 1){
            NSLog(@"保存");
        }
        NSMutableArray *tt = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray objectAtIndex:value-1]];

        self.singleArray = [tt mutableCopy];
        self.tempArray   = [tt mutableCopy];
        
        NSString *time   = [self.singleArray objectAtIndex:0];
        int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        [self.datepicker setCountDownDuration:tv];

    }
    else if (alertView.tag == 3){
        NSArray *arr = [navTitle componentsSeparatedByString:@"--"];
        if(buttonIndex == 0){
            [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:[arr[1] intValue]-1 withObject:self.tempArray];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (buttonIndex == 1){
            NSLog(@"保存");
            [AwiseGlobal sharedInstance].freshFlag = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    [self reloadLineview];
    [self labelValue];
}


@end
