//
//  TC420_EditTimerController.m
//  AwiseController
//
//  Created by rover on 16/6/13.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "TC420_EditTimerController.h"
#import "AwiseGlobal.h"
#import "lineView.h"

@interface TC420_EditTimerController ()

@end

@implementation TC420_EditTimerController
@synthesize timerInfoArray;
@synthesize label1,label2,label3,label4,label5;
@synthesize slider1,slider2,slider3,slider4,slider5;
@synthesize value_label1,value_label2,value_label3,value_label4,value_label5;
@synthesize sliderScroll;
@synthesize currentIndex,totalIndex;
@synthesize lView;
@synthesize swi1,swi2,swi3,swi4,swi5;
@synthesize currentFrameArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEffect1)];
    tap1.delegate = self;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEffect2)];
    tap2.delegate = self;
    self.effect1Label.userInteractionEnabled = YES;
    self.effect2Label.userInteractionEnabled = YES;
    [self.effect1Label addGestureRecognizer:tap1];
    [self.effect2Label addGestureRecognizer:tap2];
    
    self.currentFrameArray = [[NSMutableArray alloc] init];
    self.timerInfoArray    = [[NSMutableArray alloc] init];
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
}

#pragma mark ----------------------------------------- 将NSDate转化成字符串
- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

#pragma mark ----------------------------------------- datePicker时间
- (void)dateChange:(UIDatePicker *)picker{
    if(self.timerInfoArray.count == 0)
        return;
    
    int pre;
    int next;
    if(self.currentIndex == 0){
        pre = (int)[AwiseGlobal sharedInstance].lineArray.count -1;
        next = self.currentIndex + 1;
    }
    else if(self.currentIndex == [AwiseGlobal sharedInstance].lineArray.count -1){
        pre = self.currentIndex - 1;
        next = 0;
    }
    else{
        pre = self.currentIndex - 1;
        next = self.currentIndex + 1;
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
        [self.datePicker setCountDownDuration:value2+60];
    }
    else if(value1 == value){
        [self.datePicker setCountDownDuration:value2+60];
    }
    NSString *_currentS = [[self dateToString:picker.date] componentsSeparatedByString:@" "][1];
    [self.currentFrameArray replaceObjectAtIndex:0 withObject:_currentS];
    [[AwiseGlobal sharedInstance].lineArray replaceObjectAtIndex:self.currentIndex withObject:self.currentFrameArray];
    [self sortTheTime];
    for(int i=0;i<[AwiseGlobal sharedInstance].lineArray.count;i++){
        NSString *_s = [AwiseGlobal sharedInstance].lineArray[i][0];
        if([_s isEqualToString:_currentS]){
            self.currentIndex = i;
            self.lView.activeIndex = i;
            break;
        }
    }
    self.title = [NSString stringWithFormat:@"(%d/%d)",currentIndex+1,self.totalIndex];
    [self reloadLineview];
}

#pragma mark ----------------------------------------- 给数组排序，根据时间的先后
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

#pragma mark ----------------------------------------- 保存编辑的数据
- (void)saveData{
    
}

#pragma mark ----------------------------------------- 自定义初始化Label
- (UILabel *)customLabel:(UILabel *)lab rect:(CGRect)ret text:(NSString *)txt{
    lab = [[UILabel alloc] initWithFrame:ret];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = txt;
    lab.font = [UIFont fontWithName:@"Arial" size:14];
    lab.textColor = [UIColor blackColor];
    return lab;
}

#pragma mark ----------------------------------------- 自定义初始化Slider
- (UISlider *)customSlider:(UISlider *)slider rect:(CGRect)ret tag:(int)tag{
    slider = [[UISlider alloc] initWithFrame:ret];
    slider.backgroundColor = [UIColor clearColor];
    slider.maximumValue = 100;
    slider.minimumValue = 0;
    slider.value = 100;
    slider.tag = tag;
    slider.minimumTrackTintColor = [UIColor colorWithRed:0x90/255.
                                                   green:0xee/255.
                                                    blue:0x90/255.
                                                   alpha:1.0];
    slider.maximumTrackTintColor = [UIColor colorWithRed:0xd1/255.
                                                   green:0xee/255.
                                                    blue:0xee/255.
                                                   alpha:1.0];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    return slider;
}

#pragma mark ----------------------------------------- 自定义DVSwitch
- (DVSwitch *)customDVSwtich:(DVSwitch *)swi  rect:(CGRect)ret{
    swi = [[DVSwitch alloc] initWithStringsArray:@[@"渐变", @"跳变"]];
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    swi.font = font;
    swi.sliderColor = [UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.];
    swi.backgroundColor  = [UIColor lightGrayColor];
    swi.frame = ret;
    [swi setPressedHandler:^(NSUInteger index) {
        NSLog(@"Did switch to index: %lu", (unsigned long)index);
    }];
    return swi;
}

#pragma mark ----------------------------------------- 添加5个通道值Slider
- (void)viewWillLayoutSubviews{
    if(self.sliderScroll != nil)
        return;
    self.sliderScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 400, SCREEN_WIDHT, 300)];
    int y = 12;
    int temp = 40;
    self.label1       = [self customLabel:self.label1       rect:CGRectMake(10, y, 20, 20) text:@"A:"];
    self.slider1      = [self customSlider:self.slider1     rect:CGRectMake(30, y-5, SCREEN_WIDHT-90-60, 30)       tag:1];
    self.value_label1 = [self customLabel:self.value_label1 rect:CGRectMake(SCREEN_WIDHT-55-60, y, 40, 20)         text:@"100%"];
    self.swi1         = [self customDVSwtich:self.swi1      rect:CGRectMake(SCREEN_WIDHT-80, y-2, 70, 24)];
    [self.swi1 setPressedHandler:^(NSUInteger index) {
        NSLog(@"switch 111 to index: %lu", (unsigned long)index);
    }];
    
    self.label2       = [self customLabel:self.label2       rect:CGRectMake(10, y+temp, 20, 20) text:@"B:"];
    self.slider2      = [self customSlider:self.slider2     rect:CGRectMake(30, y-5+temp, SCREEN_WIDHT-90-60, 30)  tag:2];
    self.value_label2 = [self customLabel:self.value_label2 rect:CGRectMake(SCREEN_WIDHT-55-60, y+temp, 40, 20)    text:@"100%"];
    self.swi2         = [self customDVSwtich:self.swi2      rect:CGRectMake(SCREEN_WIDHT-80, y-2+temp, 70, 24)];
    [self.swi2 setPressedHandler:^(NSUInteger index) {
        NSLog(@"switch 222 to index: %lu", (unsigned long)index);
    }];
    
    self.label3       = [self customLabel:self.label3       rect:CGRectMake(10, y+temp*2, 20, 20) text:@"C:"];
    self.slider3      = [self customSlider:self.slider3     rect:CGRectMake(30, y-5+temp*2, SCREEN_WIDHT-90-60, 30) tag:3];
    self.value_label3 = [self customLabel:self.value_label3 rect:CGRectMake(SCREEN_WIDHT-55-60, y+temp*2, 40, 20)   text:@"100%"];
    self.swi3         = [self customDVSwtich:self.swi3      rect:CGRectMake(SCREEN_WIDHT-80, y-2+temp*2, 70, 24)];
    [self.swi3 setPressedHandler:^(NSUInteger index) {
        NSLog(@"switch 333 to index: %lu", (unsigned long)index);
    }];
    
    self.label4       = [self customLabel:self.label4       rect:CGRectMake(10, y+temp*3, 20, 20) text:@"D:"];
    self.slider4      = [self customSlider:self.slider4     rect:CGRectMake(30, y-5+temp*3, SCREEN_WIDHT-90-60, 30) tag:4];
    self.value_label4 = [self customLabel:self.value_label4 rect:CGRectMake(SCREEN_WIDHT-55-60, y+temp*3, 40, 20)   text:@"100%"];
    self.swi4         = [self customDVSwtich:self.swi4      rect:CGRectMake(SCREEN_WIDHT-80, y-2+temp*3, 70, 24)];
    [self.swi4 setPressedHandler:^(NSUInteger index) {
        NSLog(@"switch 444 to index: %lu", (unsigned long)index);
    }];
    
    self.label5       = [self customLabel:self.label5       rect:CGRectMake(10, y+temp*4, 20, 20) text:@"E:"];
    self.slider5      = [self customSlider:self.slider5     rect:CGRectMake(30, y-5+temp*4, SCREEN_WIDHT-90-60, 30) tag:5];
    self.value_label5 = [self customLabel:self.value_label5 rect:CGRectMake(SCREEN_WIDHT-55-60, y+temp*4, 40, 20)   text:@"100%"];
    self.swi5         = [self customDVSwtich:self.swi5      rect:CGRectMake(SCREEN_WIDHT-80, y-2+temp*4, 70, 24)];
    [self.swi5 setPressedHandler:^(NSUInteger index) {
        NSLog(@"switch 555 to index: %lu", (unsigned long)index);
    }];
    
    [self.view addSubview:self.sliderScroll];
    [self.sliderScroll addSubview:self.label1];
    [self.sliderScroll addSubview:self.slider1];
    [self.sliderScroll addSubview:self.value_label1];
    [self.sliderScroll addSubview:self.swi1];
    
    [self.sliderScroll addSubview:self.label2];
    [self.sliderScroll addSubview:self.slider2];
    [self.sliderScroll addSubview:self.value_label2];
    [self.sliderScroll addSubview:self.swi2];
    
    [self.sliderScroll addSubview:self.label3];
    [self.sliderScroll addSubview:self.slider3];
    [self.sliderScroll addSubview:self.value_label3];
    [self.sliderScroll addSubview:self.swi3];
    
    [self.sliderScroll addSubview:self.label4];
    [self.sliderScroll addSubview:self.slider4];
    [self.sliderScroll addSubview:self.value_label4];
    [self.sliderScroll addSubview:self.swi4];
    
    [self.sliderScroll addSubview:self.label5];
    [self.sliderScroll addSubview:self.slider5];
    [self.sliderScroll addSubview:self.value_label5];
    [self.sliderScroll addSubview:self.swi5];
    
    
    
    self.preBtn.layer.cornerRadius = 5;
    self.preBtn.layer.masksToBounds = true;
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.masksToBounds = true;
    
    //添加时间曲线时间轴
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    if(self.timerInfoArray.count > 0){
        [AwiseGlobal sharedInstance].lineArray = self.timerInfoArray;
        self.totalIndex   = (int)[AwiseGlobal sharedInstance].lineArray.count;
        self.currentIndex = 0;
        self.currentFrameArray = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:0];
    }else{
        self.totalIndex   = 1;
        self.currentIndex = 0;
        int tValue = (currentIndex+1)*30;
        int hour = tValue/60;
        int minute = tValue%60;
        NSString *timeStr = [NSString stringWithFormat:@"%d:%d",hour,minute];
        int tv = [[timeStr componentsSeparatedByString:@":"][0] intValue]*60*60 +
                 [[timeStr componentsSeparatedByString:@":"][1] intValue]*60;
        [self.datePicker setCountDownDuration:tv];
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:timeStr,@"10",@"20",@"30",@"40",@"50",@"1",@"0",@"1",@"0",@"1", nil];
        [self.timerInfoArray addObject:tempArr];
        [AwiseGlobal sharedInstance].lineArray = self.timerInfoArray;
        self.currentFrameArray = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:0];
        self.slider1.value = 20;
        self.slider2.value = 30;
        self.slider3.value = 40;
        self.slider4.value = 50;
        self.slider5.value = 60;
        self.value_label1.text = [NSString stringWithFormat:@"%@%%",tempArr[1]];
        self.value_label2.text = [NSString stringWithFormat:@"%@%%",tempArr[2]];
        self.value_label3.text = [NSString stringWithFormat:@"%@%%",tempArr[3]];
        self.value_label4.text = [NSString stringWithFormat:@"%@%%",tempArr[4]];
        self.value_label5.text = [NSString stringWithFormat:@"%@%%",tempArr[5]];
        [self.swi1 selectIndex:[tempArr[5] intValue] animated:NO];
        [self.swi2 selectIndex:[tempArr[6] intValue] animated:NO];
        [self.swi3 selectIndex:[tempArr[7] intValue] animated:NO];
        [self.swi4 selectIndex:[tempArr[8] intValue] animated:NO];
        [self.swi5 selectIndex:[tempArr[9] intValue] animated:NO];
    }
    self.title = [NSString stringWithFormat:@"(%d/%d)",currentIndex+1,self.totalIndex];
    
    self.lView = [[lineView alloc] init];
    self.lView.delegate = self;
    self.lView.frame = CGRectMake(5, 72, SCREEN_WIDHT-16, 75);
    [self.lView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.lView];
}

#pragma mark ----------------------------------------- 刷新lineview
- (void)reloadLineview{
    if(self.lView != nil){
        [self.lView removeFromSuperview];
        self.lView.delegate = nil;
        self.lView = [[lineView alloc] init];
        self.lView.delegate = self;
        self.lView.frame = CGRectMake(5, 72, SCREEN_WIDHT-16, 75);
        [self.lView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.lView];
    }
}

#pragma mark ----------------------------------------- Slider值发生变化
- (void)sliderValueChange:(UISlider *)slider{
    int value = (int)slider.value;
    switch (slider.tag) {
        case 1:{
            self.value_label1.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
        case 2:{
            self.value_label2.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
        case 3:{
            self.value_label3.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
        case 4:{
            self.value_label4.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
        case 5:{
            self.value_label5.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
        default:
            break;
    }
    NSMutableArray *tempArr = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
    [tempArr replaceObjectAtIndex:slider.tag withObject:[NSString stringWithFormat:@"%d",value]];
    [self reloadLineview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----------------------------------------- 前一帧
- (IBAction)preBtnClicked:(id)sender {
    if(self.currentIndex == 0)
        return;
    self.currentIndex --;
    self.title = [NSString stringWithFormat:@"(%d/%d)",self.currentIndex+1,totalIndex];
    self.currentFrameArray = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
}

#pragma mark ----------------------------------------- 后一帧 （点击时，如果小于48帧，则相当于插入帧）
- (IBAction)nextBtnClicked:(id)sender {
    if(self.totalIndex == 48){
        [[AwiseGlobal sharedInstance] showRemindMsg:@"最多添加48个时间段" withTime:0.8];
        return;
    }
    if(self.currentIndex+1 == self.totalIndex){
        int tValue = (currentIndex+2)*30;
        if(tValue == 30)
            tValue = 60;
        int hour = tValue/60;
        int minute = tValue%60;
        NSString *timeStr = [NSString stringWithFormat:@"%d:%d",hour,minute];
        int tv = [[timeStr componentsSeparatedByString:@":"][0] intValue]*60*60 +
                 [[timeStr componentsSeparatedByString:@":"][1] intValue]*60;
        [self.datePicker setCountDownDuration:tv];
        NSString *v1 = [NSString stringWithFormat:@"%d",(int)self.slider1.value];
        NSString *v2 = [NSString stringWithFormat:@"%d",(int)self.slider2.value];
        NSString *v3 = [NSString stringWithFormat:@"%d",(int)self.slider3.value];
        NSString *v4 = [NSString stringWithFormat:@"%d",(int)self.slider4.value];
        NSString *v5 = [NSString stringWithFormat:@"%d",(int)self.slider5.value];
        NSString *s1 = [NSString stringWithFormat:@"%d",(int)self.swi1.selectedIndex];
        NSString *s2 = [NSString stringWithFormat:@"%d",(int)self.swi2.selectedIndex];
        NSString *s3 = [NSString stringWithFormat:@"%d",(int)self.swi3.selectedIndex];
        NSString *s4 = [NSString stringWithFormat:@"%d",(int)self.swi4.selectedIndex];
        NSString *s5 = [NSString stringWithFormat:@"%d",(int)self.swi5.selectedIndex];
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:timeStr,v1,v2,v3,v4,v5,s1,s2,s3,s4,s5, nil];
        [self.timerInfoArray addObject:tempArr];
        [self reloadLineview];
        self.totalIndex ++;
        self.currentIndex ++;
        self.title = [NSString stringWithFormat:@"(%d/%d)",self.currentIndex+1,totalIndex];
        self.currentFrameArray = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
    }else{
        self.currentIndex ++;
        self.title = [NSString stringWithFormat:@"(%d/%d)",self.currentIndex+1,totalIndex];
        self.currentFrameArray = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
    }
}

#pragma mark ----------------------------------------- 点击LineView快速点位
- (void)lineViewPointSelected:(int)index{
    NSLog(@"当前点位的帧为 === %d",index);
    self.currentIndex = index-1;
    self.title = [NSString stringWithFormat:@"(%d/%d)",self.currentIndex+1,totalIndex];
    self.currentFrameArray = [self.timerInfoArray objectAtIndex:self.currentIndex];
    [self layoutFrameData];
}


#pragma mark ----------------------------------------- 根据当前帧的数据，刷新界面
- (void)layoutFrameData{
    NSString *time   = [self.currentFrameArray objectAtIndex:0];
    int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
    [self.datePicker setCountDownDuration:tv];
    self.slider1.value = [[self.currentFrameArray objectAtIndex:1] intValue];
    self.slider1.value = [[self.currentFrameArray objectAtIndex:2] intValue];
    self.slider1.value = [[self.currentFrameArray objectAtIndex:3] intValue];
    self.slider1.value = [[self.currentFrameArray objectAtIndex:4] intValue];
    self.slider1.value = [[self.currentFrameArray objectAtIndex:5] intValue];
    self.value_label1.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:1]];
    self.value_label2.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:2]];
    self.value_label3.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:3]];
    self.value_label4.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:4]];
    self.value_label5.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:5]];
    [self.swi1 selectIndex:[[self.currentFrameArray objectAtIndex:6] intValue] animated:NO];
    [self.swi2 selectIndex:[[self.currentFrameArray objectAtIndex:7] intValue] animated:NO];
    [self.swi3 selectIndex:[[self.currentFrameArray objectAtIndex:8] intValue] animated:NO];
    [self.swi4 selectIndex:[[self.currentFrameArray objectAtIndex:9] intValue] animated:NO];
    [self.swi5 selectIndex:[[self.currentFrameArray objectAtIndex:10] intValue] animated:NO];
}

#pragma mark ----------------------------------------- Slider值发生变化 （No Use）
- (IBAction)effect1BtnClicked:(id)sender {
    [self.effect1Btn setBackgroundImage:[UIImage imageNamed:@"effect_selected"] forState:UIControlStateNormal];
    [self.effcct2Btn setBackgroundImage:[UIImage imageNamed:@"effect_disSelected"] forState:UIControlStateNormal];
}

#pragma mark ----------------------------------------- Slider值发生变化 （No Use）
- (IBAction)effected2BtnClicked:(id)sender {
    [self.effect1Btn setBackgroundImage:[UIImage imageNamed:@"effect_disSelected"] forState:UIControlStateNormal];
    [self.effcct2Btn setBackgroundImage:[UIImage imageNamed:@"effect_selected"] forState:UIControlStateNormal];
}

//（No Use）
- (void)selectEffect1{
    [self.effect1Btn setBackgroundImage:[UIImage imageNamed:@"effect_selected"] forState:UIControlStateNormal];
    [self.effcct2Btn setBackgroundImage:[UIImage imageNamed:@"effect_disSelected"] forState:UIControlStateNormal];
}

//（No Use）
- (void)selectEffect2{
    [self.effect1Btn setBackgroundImage:[UIImage imageNamed:@"effect_disSelected"] forState:UIControlStateNormal];
    [self.effcct2Btn setBackgroundImage:[UIImage imageNamed:@"effect_selected"] forState:UIControlStateNormal];
}

@end
