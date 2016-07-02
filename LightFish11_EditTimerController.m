//
//  LightFish11_EditTimerController.m
//  AwiseController
//
//  Created by rover on 16/6/29.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "LightFish11_EditTimerController.h"

@interface LightFish11_EditTimerController ()

@end

@implementation LightFish11_EditTimerController
@synthesize backScrollView;
@synthesize msgLabel;
@synthesize effectBtn1,effectBtn2,effectBtn3,effectBtn4;
@synthesize effectSwitch;
@synthesize selectEffect;
@synthesize speedLabel,speedSlider,speedValueLabel;
@synthesize timerInfoArray;
@synthesize timerWeekArray;
@synthesize currentFrameArray;
@synthesize timelineView;
@synthesize currentIndex;
@synthesize totalIndex;
@synthesize lView;
@synthesize saveView;
@synthesize saveViewBack;
@synthesize fileName;
@synthesize delegate;
@synthesize label1,label2,label3,label4,label5;
@synthesize slider1,slider2,slider3,slider4,slider5;
@synthesize value_label1,value_label2,value_label3,value_label4,value_label5;
@synthesize lightLabel,lightSlider,lightValueLabel;
@synthesize timerNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.cornerRadius = 5;
    
    self.selectEffect = 0;  //默认选中渐变效果
    
    self.currentFrameArray = [[NSMutableArray alloc] init];
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
}

#pragma mark ----------------------------------------------------- 将NSDate转化成字符串
- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

#pragma mark ----------------------------------------------------- datePicker时间
- (void)dateChange:(UIDatePicker *)picker{
    if(self.timerInfoArray.count == 0)
        return;
    
    int pre;
    int next;
    if(self.totalIndex == 1){
        pre = 0;
        next = 0;
    }else{
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

#pragma mark ----------------------------------------------------- 刷新lineview
- (void)reloadLineview{
    if(self.lView != nil){
        [self.lView removeFromSuperview];
        self.lView.delegate = nil;
        self.lView = [[lineView alloc] init];
        self.lView.delegate = self;
        self.lView.lineDataArray = [AwiseGlobal sharedInstance].lineArray;
        self.lView.activeIndex = self.currentIndex+1;
        self.lView.pipeNumber = 5;
        self.lView.frame = CGRectMake(5, 72, SCREEN_WIDHT-16, 75);
        [self.lView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.lView];
    }
}

#pragma mark ----------------------------------------------------- 给数组排序，根据时间的先后
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


#pragma mark ----------------------------------------------------- 取消保存
- (void)cancelSave{
    self.saveView.delegate = nil;
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.3];
    self.saveView.alpha = 0.0;
    [UIView commitAnimations];
    [self.saveView removeFromSuperview];
    [self.saveViewBack removeFromSuperview];
}

#pragma mark ----------------------------------------------------- 确定保存
- (void)okSave:(NSMutableArray *)arr{
    self.saveView.delegate = nil;
    [self.saveView removeFromSuperview];
    [self.saveViewBack removeFromSuperview];
    NSString *filePath = [[AwiseGlobal sharedInstance] getFilePath:self.fileName];
    [self.timerInfoArray insertObject:arr atIndex:0];
    [self.timerInfoArray writeToFile:filePath atomically:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(LightFish11_dataSaved)] ){
        [self.delegate LightFish11_dataSaved];
    }
    NSLog(@"数据 == %@",self.timerInfoArray);
    //发送编辑的数据
    int len = (int)(46+((self.timerInfoArray.count-1)*9+1));
    Byte bb[len];
    for(int k=0;k<len;k++){
        bb[k] = 0x00;
    }
    bb[0]  = 0x55;
    bb[1]  = 0xAA;
    bb[2]  = 0x01;       //总数据包长度，暂时可不填写
    bb[39] = 0x01;      //0x00表示该数据包发往服务器，0x01局域网发送至设备
    
    bb[41] = 0x08;      //指令功能代号
    bb[42] = 0x00;      //指令长度
    bb[43] = len;       //指令长度(优先填充)
    
    bb[46] = timerNumber+4;              //哪一个自定义模式
    int count =47;
    for(int i=0;i<self.timerInfoArray.count-1;i++){
        NSMutableArray *arr = [self.timerInfoArray objectAtIndex:i+1];
        bb[count++] = i;                        //第几个时间段
        bb[count++] = [arr[6] intValue];        //该时间段模式
        NSArray *timeStr = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        bb[count++] = [timeStr[0] intValue];    //时
        bb[count++] = [timeStr[1] intValue];    //分
        if([arr[6] intValue] == 0 || [arr[6] intValue] == 1){
            bb[count++] = [arr[1] intValue];
            bb[count++] = [arr[2] intValue];
            bb[count++] = [arr[3] intValue];
            bb[count++] = [arr[4] intValue];
            bb[count++] = [arr[5] intValue];
        }else if([arr[6] intValue] == 2 || [arr[6] intValue] == 3){
            bb[count++] = [arr[7] intValue];
            bb[count++] = [arr[8] intValue];
            bb[count++] = 0;
            bb[count++] = 0;
            bb[count++] = 0;
        }
    }
    [self.timerInfoArray removeObjectAtIndex:0];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bb length:len];
    
    
    
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----------------------------------------------------- 保存编辑的数据
- (void)saveData{
    if(self.saveView != nil){
        self.saveView.delegate = nil;
        [self.saveView removeFromSuperview];
        [self.saveViewBack removeFromSuperview];
    }
    self.saveViewBack = [[UIView alloc] initWithFrame:self.view.frame];
    self.saveViewBack.alpha = 0.55;
    self.saveViewBack.backgroundColor = [UIColor darkTextColor];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.saveViewBack];
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"SaveDataView" owner:nil options:nil];
    self.saveView = [nibView objectAtIndex:0];
    self.saveView.delegate = self;
    [self.saveView loadWeekData:self.timerWeekArray];
    self.saveView.center = self.view.center;
    self.saveView.layer.cornerRadius = 5;
    self.saveView.layer.masksToBounds = true;
    self.saveView.layer.borderWidth = 1.5f;
    self.saveView.layer.borderColor = [UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.].CGColor;
    
    [self.view addSubview:self.saveView];
    self.saveView.alpha = 0.0;
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.3];
    self.saveView.alpha = 1.0;
    [UIView commitAnimations];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.saveView];
}

#pragma mark ----------------------------------------------------- 自定义初始化Label
- (UILabel *)customLabel:(UILabel *)lab rect:(CGRect)ret text:(NSString *)txt{
    lab = [[UILabel alloc] initWithFrame:ret];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = txt;
    lab.numberOfLines = 0;
    lab.font = [UIFont fontWithName:@"Arial" size:14];
    lab.textColor = [UIColor blackColor];
    return lab;
}

#pragma mark ----------------------------------------------------- 自定义初始化Button
- (UIButton *)customButton:(UIButton *)btn rect:(CGRect)ret text:(NSString *)txt{
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = ret;
    btn.backgroundColor = [UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.];
    [btn setTitle:txt forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    btn.titleLabel.textColor = [UIColor darkGrayColor];
    btn.layer.cornerRadius = 5;
    return btn;
}

#pragma mark ----------------------------------------------------- 自定义初始化UIview
- (UIView *)customView:(UIView *)view rect:(CGRect)ret{
    view = [[UIView alloc] initWithFrame:ret];
    view.frame = ret;
    view.layer.cornerRadius = 5;
    return view;
}

#pragma mark ----------------------------------------------------- 自定义初始化Slider
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

#pragma mark ----------------------------------------------------- 自定义DVSwitch
- (DVSwitch *)customDVSwtich:(DVSwitch *)swi  rect:(CGRect)ret{
    swi = [[DVSwitch alloc] initWithStringsArray:@[@"渐变", @"跳变", @"多云", @"闪电"]];
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    swi.font = font;
    swi.sliderColor = [UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.];
    swi.backgroundColor  = [UIColor lightGrayColor];
    swi.frame = ret;
    __block LightFish11_EditTimerController* weakSelf = self;
    [swi setPressedHandler:^(NSUInteger index) {
        NSLog(@"Did switch to index: %@", weakSelf.currentFrameArray);
        if(index == 0 || index == 1){
            [self showFivePipe];
        }else if (index == 2 || index == 3){
            [self hideFivePipe];
        }
        selectEffect = (int)index;
        [weakSelf.currentFrameArray replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%d",(int)index]];
    }];
    return swi;
}

#pragma mark ----------------------------------------------------- slider 滑动条值改变
- (void)sliderValueChange:(UISlider *)sender{
    int value = (int)sender.value;
    switch (sender.tag) {
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
        case 7:{
            speedValueLabel.text = [NSString stringWithFormat:@"%d%%",value];
        }
            break;
        case 8:{
            lightValueLabel.text = [NSString stringWithFormat:@"%d%%",value];
            NSMutableArray *tempArr = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
            [tempArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",value]];
            [tempArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",value]];
            [tempArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",value]];
            [tempArr replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d",value]];
            [tempArr replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%d",value]];
        }
            break;
        default:
            break;
    }
    NSMutableArray *tempArr = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
    [tempArr replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%d",value]];
    [self reloadLineview];
}

#pragma mark ----------------------------------------------------- 布局界面
- (void)viewWillLayoutSubviews{
    if(backScrollView != nil)
        return;
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 308, SCREEN_WIDHT, SCREEN_HEIGHT-308)];
    if(SCREEN_HEIGHT-308 < 360){
        backScrollView.contentSize = CGSizeMake(SCREEN_WIDHT, 360);
    }
    
    msgLabel = [self customLabel:msgLabel
                            rect:CGRectMake(10, 10, SCREEN_WIDHT-20, 43)
                            text:@"可设置当前时间点运行到下一个时间点的效果，渐变、跳变、多云、闪电"];
    
    effectSwitch = [self customDVSwtich:effectSwitch rect:CGRectMake(20, 60, SCREEN_WIDHT-40, 35)];
    
    [backScrollView addSubview:msgLabel];
    [backScrollView addSubview:effectSwitch];
    
    int y = 115;
    int temp = 40;
    self.label1       = [self customLabel:self.label1       rect:CGRectMake(10, y, 20, 20) text:@"A:"];
    self.slider1      = [self customSlider:self.slider1     rect:CGRectMake(30, y-5, SCREEN_WIDHT-90, 30)       tag:1];
    self.value_label1 = [self customLabel:self.value_label1 rect:CGRectMake(SCREEN_WIDHT-50, y, 40, 20)         text:@"100%"];
  
    self.label2       = [self customLabel:self.label2       rect:CGRectMake(10, y+temp, 20, 20) text:@"B:"];
    self.slider2      = [self customSlider:self.slider2     rect:CGRectMake(30, y-5+temp, SCREEN_WIDHT-90, 30)  tag:2];
    self.value_label2 = [self customLabel:self.value_label2 rect:CGRectMake(SCREEN_WIDHT-50, y+temp, 40, 20)    text:@"100%"];

    self.label3       = [self customLabel:self.label3       rect:CGRectMake(10, y+temp*2, 20, 20) text:@"C:"];
    self.slider3      = [self customSlider:self.slider3     rect:CGRectMake(30, y-5+temp*2, SCREEN_WIDHT-90, 30) tag:3];
    self.value_label3 = [self customLabel:self.value_label3 rect:CGRectMake(SCREEN_WIDHT-50, y+temp*2, 40, 20)   text:@"100%"];
    
    self.label4       = [self customLabel:self.label4       rect:CGRectMake(10, y+temp*3, 20, 20) text:@"D:"];
    self.slider4      = [self customSlider:self.slider4     rect:CGRectMake(30, y-5+temp*3, SCREEN_WIDHT-90, 30) tag:4];
    self.value_label4 = [self customLabel:self.value_label4 rect:CGRectMake(SCREEN_WIDHT-50, y+temp*3, 40, 20)   text:@"100%"];

    self.label5       = [self customLabel:self.label5       rect:CGRectMake(10, y+temp*4, 20, 20) text:@"E:"];
    self.slider5      = [self customSlider:self.slider5     rect:CGRectMake(30, y-5+temp*4, SCREEN_WIDHT-90, 30) tag:5];
    self.value_label5 = [self customLabel:self.value_label5 rect:CGRectMake(SCREEN_WIDHT-50, y+temp*4, 40, 20)   text:@"100%"];

    [backScrollView addSubview:self.label1];
    [backScrollView addSubview:self.slider1];
    [backScrollView addSubview:self.value_label1];
    
    [backScrollView addSubview:self.label2];
    [backScrollView addSubview:self.slider2];
    [backScrollView addSubview:self.value_label2];
    
    [backScrollView addSubview:self.label3];
    [backScrollView addSubview:self.slider3];
    [backScrollView addSubview:self.value_label3];
    
    [backScrollView addSubview:self.label4];
    [backScrollView addSubview:self.slider4];
    [backScrollView addSubview:self.value_label4];
    
    [backScrollView addSubview:self.label5];
    [backScrollView addSubview:self.slider5];
    [backScrollView addSubview:self.value_label5];
    
    [self.view addSubview:backScrollView];
    
    UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dBtn.layer.cornerRadius = 5;
    dBtn.layer.masksToBounds = true;
    [dBtn setBackgroundColor:[UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.]];
    [dBtn addTarget:self action:@selector(deleteCurrentFrame) forControlEvents:UIControlEventTouchUpInside];
    [dBtn setTitle:@"删除当前时间点" forState:UIControlStateNormal];
    dBtn.frame = CGRectMake(10, 315, SCREEN_WIDHT-20, 40);
    [backScrollView addSubview:dBtn];
    
    //添加时间曲线时间轴
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    if(self.timerInfoArray.count > 0){
        self.timerWeekArray = [[NSMutableArray alloc] initWithArray:(NSArray *)[self.timerInfoArray objectAtIndex:0]];
        [self.timerInfoArray removeObjectAtIndex:0];
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
        self.timerWeekArray = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",
                               @"1",@"1",@"1",@"1",@"1",nil];
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:timeStr,@"10",@"20",@"30",@"40",@"50",@"0",@"50",@"100", nil];
        self.timerInfoArray = [[NSMutableArray alloc] init];
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
        [self.effectSwitch selectIndex:[tempArr[6] intValue] animated:NO];
        self.speedSlider.value = 50;
        self.speedValueLabel.text = [NSString stringWithFormat:@"%@%%",tempArr[7]];
    }
    self.title = [NSString stringWithFormat:@"(%d/%d)",currentIndex+1,self.totalIndex];
    
    self.lView = [[lineView alloc] init];
    self.lView.delegate = self;
    self.lView.lineDataArray = [AwiseGlobal sharedInstance].lineArray;
    self.lView.activeIndex = self.currentIndex+1;
    self.lView.pipeNumber = 5;
    self.lView.frame = CGRectMake(5, 72, SCREEN_WIDHT-16, 75);
    [self.lView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.lView];
    [self showCloudyLightingSet];
    [self layoutFrameData];
}

#pragma mark ----------------------------------------------------- 多云和闪电时的设置界面
- (void)showCloudyLightingSet{
    if(self.speedLabel == nil){
        int y = 115;
        int temp = 40;
        speedLabel = [self customLabel:speedLabel             rect:CGRectMake(10, y, 40, 40)                  text:@"速度"];
        speedSlider= [self customSlider:speedSlider           rect:CGRectMake(50, y, SCREEN_WIDHT-110, 40)    tag:7];
        speedValueLabel = [self customLabel:speedValueLabel   rect:CGRectMake(SCREEN_WIDHT-48, y, 40, 40)     text:@"100%"];
        [backScrollView addSubview:speedLabel];
        [backScrollView addSubview:speedSlider];
        [backScrollView addSubview:speedValueLabel];
        
        lightLabel = [self customLabel:lightLabel             rect:CGRectMake(10, y+temp, 40, 40)                  text:@"亮度"];
        lightSlider= [self customSlider:lightSlider           rect:CGRectMake(50, y+temp, SCREEN_WIDHT-110, 40)    tag:8];
        lightValueLabel = [self customLabel:lightValueLabel   rect:CGRectMake(SCREEN_WIDHT-48, y+temp, 40, 40)     text:@"100%"];
        [backScrollView addSubview:lightLabel];
        [backScrollView addSubview:lightSlider];
        [backScrollView addSubview:lightValueLabel];
        speedLabel.hidden = YES;
        speedSlider.hidden = YES;
        speedValueLabel.hidden = YES;
        lightLabel.hidden = YES;
        lightSlider.hidden = YES;
        lightValueLabel.hidden = YES;
    }
}

#pragma mark ----------------------------------------------------- 隐藏五个通道，显示速度、亮度条
- (void)hideFivePipe{
    speedLabel.hidden = NO;
    speedSlider.hidden = NO;
    speedValueLabel.hidden = NO;
    lightLabel.hidden = NO;
    lightSlider.hidden = NO;
    lightValueLabel.hidden = NO;
    
    label1.hidden = YES;    slider1.hidden = YES;    value_label1.hidden = YES;
    label2.hidden = YES;    slider2.hidden = YES;    value_label2.hidden = YES;
    label3.hidden = YES;    slider3.hidden = YES;    value_label3.hidden = YES;
    label4.hidden = YES;    slider4.hidden = YES;    value_label4.hidden = YES;
    label5.hidden = YES;    slider5.hidden = YES;    value_label5.hidden = YES;
}

#pragma mark ----------------------------------------------------- 隐藏五个通道，显示速度、亮度条
- (void)showFivePipe{
    speedLabel.hidden = YES;
    speedSlider.hidden = YES;
    speedValueLabel.hidden = YES;
    lightLabel.hidden = YES;
    lightSlider.hidden = YES;
    lightValueLabel.hidden = YES;
    
    label1.hidden = NO;    slider1.hidden = NO;    value_label1.hidden = NO;
    label2.hidden = NO;    slider2.hidden = NO;    value_label2.hidden = NO;
    label3.hidden = NO;    slider3.hidden = NO;    value_label3.hidden = NO;
    label4.hidden = NO;    slider4.hidden = NO;    value_label4.hidden = NO;
    label5.hidden = NO;    slider5.hidden = NO;    value_label5.hidden = NO;
}

#pragma mark ----------------------------------------------------- 删除当前帧
- (void)deleteCurrentFrame{
    if(self.timerInfoArray.count > 1){
        if(self.currentIndex == 0){
            self.currentIndex = 0;
            [self.timerInfoArray removeObjectAtIndex:0];
        }else if(self.currentIndex+1 == self.totalIndex){
            self.currentIndex = self.totalIndex-2;
            [self.timerInfoArray removeObjectAtIndex:self.totalIndex-1];
        }
        else{
            [self.timerInfoArray removeObjectAtIndex:self.currentIndex];
            self.currentIndex--;
        }
        
        self.totalIndex--;
        self.currentFrameArray = [self.timerInfoArray objectAtIndex:self.currentIndex];
        self.title = [NSString stringWithFormat:@"(%d/%d)",currentIndex+1,self.totalIndex];
        [self reloadLineview];
        [self layoutFrameData];
    }
}

#pragma mark ----------------------------------------------------- 点击LineView快速点位
- (void)lineViewPointSelected:(int)index{
    NSLog(@"当前点位的帧为 === %d",index);
    self.currentIndex = index-1;
    self.title = [NSString stringWithFormat:@"(%d/%d)",self.currentIndex+1,totalIndex];
    self.currentFrameArray = [self.timerInfoArray objectAtIndex:self.currentIndex];
    [self layoutFrameData];
    [self reloadLineview];
}

#pragma mark ----------------------------------------------------- 根据当前帧的数据，刷新界面
- (void)layoutFrameData{
    NSString *time   = [self.currentFrameArray objectAtIndex:0];
    int tv = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
    [self.datePicker setCountDownDuration:tv];
    self.slider1.value = [[self.currentFrameArray objectAtIndex:1] intValue];
    self.slider2.value = [[self.currentFrameArray objectAtIndex:2] intValue];
    self.slider3.value = [[self.currentFrameArray objectAtIndex:3] intValue];
    self.slider4.value = [[self.currentFrameArray objectAtIndex:4] intValue];
    self.slider5.value = [[self.currentFrameArray objectAtIndex:5] intValue];
    self.value_label1.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:1]];
    self.value_label2.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:2]];
    self.value_label3.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:3]];
    self.value_label4.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:4]];
    self.value_label5.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:5]];
    int index = [[self.currentFrameArray objectAtIndex:6] intValue];
    [self.effectSwitch selectIndex:index animated:NO];
    if(index == 0 || index == 1){
        [self showFivePipe];
    }else if (index == 2 || index == 3){
        [self hideFivePipe];
    }
    self.speedSlider.value = [[self.currentFrameArray objectAtIndex:7] intValue];
    self.speedValueLabel.text = [NSString stringWithFormat:@"%@%%",[self.currentFrameArray objectAtIndex:7]];
}

#pragma mark ----------------------------------------------------- 上一帧
- (IBAction)preBtnClicked:(id)sender {
    if(self.currentIndex == 0)
        return;
    self.currentIndex --;
    self.title = [NSString stringWithFormat:@"(%d/%d)",self.currentIndex+1,totalIndex];
    self.currentFrameArray = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
    [self reloadLineview];
    [self layoutFrameData];
}

#pragma mark ----------------------------------------------------- 下一帧
- (IBAction)nextBtnClicked:(id)sender {
    if(self.totalIndex == 18){
        [[AwiseGlobal sharedInstance] showRemindMsg:@"最多添加48个时间段" withTime:0.8];
        return;
    }
    if(self.currentIndex+1 == self.totalIndex){
        NSMutableArray *temp = [self.timerInfoArray objectAtIndex:self.currentIndex];
        NSString *preTime = [temp objectAtIndex:0];
        int old_tv = [[preTime componentsSeparatedByString:@":"][0] intValue]*60 +
        [[preTime componentsSeparatedByString:@":"][1] intValue];
        int tValue = old_tv + 20;  //在当前的基础上加10分钟
        if(tValue > 24*60)
            tValue = 24*60;
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
        NSString *effect = [NSString stringWithFormat:@"%d",(int)self.effectSwitch.selectedIndex];
        NSString *speed  = [NSString stringWithFormat:@"%d",(int)self.speedSlider.value];
        NSString *light  = [NSString stringWithFormat:@"%d",(int)self.speedSlider.value];
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:timeStr,v1,v2,v3,v4,v5,effect,speed,light, nil];
        [self.timerInfoArray addObject:tempArr];
        self.totalIndex ++;
        self.currentIndex ++;
        self.title = [NSString stringWithFormat:@"(%d/%d)",self.currentIndex+1,totalIndex];
        self.currentFrameArray = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
    }else{
        self.currentIndex ++;
        self.title = [NSString stringWithFormat:@"(%d/%d)",self.currentIndex+1,totalIndex];
        self.currentFrameArray = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:self.currentIndex];
    }
    [self layoutFrameData];
    [self reloadLineview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
