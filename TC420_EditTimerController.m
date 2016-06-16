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
}

#pragma mark ----------------------------------------- 自定义初始化Label
- (UILabel *)customLabel:(UILabel *)lab rect:(CGRect)ret text:(NSString *)txt{
    lab = [[UILabel alloc] initWithFrame:ret];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = txt;
    lab.font = [UIFont fontWithName:@"Arial" size:15];
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

#pragma mark ----------------------------------------- 添加5个通道值Slider
- (void)viewWillLayoutSubviews{
    if(self.sliderScroll != nil)
        return;
    self.sliderScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 400, SCREEN_WIDHT, 300)];
    int y = 12;
    int temp = 40;
    self.label1       = [self customLabel:self.label1       rect:CGRectMake(10, y, 20, 20) text:@"A:"];
    self.slider1      = [self customSlider:self.slider1     rect:CGRectMake(35, y-5, SCREEN_WIDHT-90, 30)       tag:1];
    self.value_label1 = [self customLabel:self.value_label1 rect:CGRectMake(SCREEN_WIDHT-45, y, 40, 20)         text:@"100%"];
    
    self.label2       = [self customLabel:self.label2       rect:CGRectMake(10, y+temp, 20, 20) text:@"B:"];
    self.slider2      = [self customSlider:self.slider2     rect:CGRectMake(35, y-5+temp, SCREEN_WIDHT-90, 30)  tag:3];
    self.value_label2 = [self customLabel:self.value_label2 rect:CGRectMake(SCREEN_WIDHT-45, y+temp, 40, 20)    text:@"100%"];
    
    self.label3       = [self customLabel:self.label3       rect:CGRectMake(10, y+temp*2, 20, 20) text:@"C:"];
    self.slider3      = [self customSlider:self.slider3     rect:CGRectMake(35, y-5+temp*2, SCREEN_WIDHT-90, 30) tag:3];
    self.value_label3 = [self customLabel:self.value_label3 rect:CGRectMake(SCREEN_WIDHT-45, y+temp*2, 40, 20)   text:@"100%"];
    
    self.label4       = [self customLabel:self.label4       rect:CGRectMake(10, y+temp*3, 20, 20) text:@"D:"];
    self.slider4      = [self customSlider:self.slider4     rect:CGRectMake(35, y-5+temp*3, SCREEN_WIDHT-90, 30) tag:4];
    self.value_label4 = [self customLabel:self.value_label4 rect:CGRectMake(SCREEN_WIDHT-45, y+temp*3, 40, 20)   text:@"100%"];
    
    self.label5       = [self customLabel:self.label5       rect:CGRectMake(10, y+temp*4, 20, 20) text:@"E:"];
    self.slider5      = [self customSlider:self.slider5     rect:CGRectMake(35, y-5+temp*4, SCREEN_WIDHT-90, 30) tag:5];
    self.value_label5 = [self customLabel:self.value_label5 rect:CGRectMake(SCREEN_WIDHT-45, y+temp*4, 40, 20)   text:@"100%"];
    
    [self.view addSubview:self.sliderScroll];
    [self.sliderScroll addSubview:self.label1];
    [self.sliderScroll addSubview:self.slider1];
    [self.sliderScroll addSubview:self.value_label1];
    
    [self.sliderScroll addSubview:self.label2];
    [self.sliderScroll addSubview:self.slider2];
    [self.sliderScroll addSubview:self.value_label2];
    
    [self.sliderScroll addSubview:self.label3];
    [self.sliderScroll addSubview:self.slider3];
    [self.sliderScroll addSubview:self.value_label3];
    
    [self.sliderScroll addSubview:self.label4];
    [self.sliderScroll addSubview:self.slider4];
    [self.sliderScroll addSubview:self.value_label4];
    
    [self.sliderScroll addSubview:self.label5];
    [self.sliderScroll addSubview:self.slider5];
    [self.sliderScroll addSubview:self.value_label5];
    
    self.preBtn.layer.cornerRadius = 5;
    self.preBtn.layer.masksToBounds = true;
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.masksToBounds = true;
    
    //添加时间曲线时间轴
    lineView *line = [[lineView alloc] init];
    line.frame = CGRectMake(5, 72, SCREEN_WIDHT-16, 75);
    [line setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:line];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)preBtnClicked:(id)sender {
}

- (IBAction)nextBtnClicked:(id)sender {
}

#pragma mark ----------------------------------------- Slider值发生变化
- (IBAction)effect1BtnClicked:(id)sender {
    [self.effect1Btn setBackgroundImage:[UIImage imageNamed:@"effect_selected"] forState:UIControlStateNormal];
    [self.effcct2Btn setBackgroundImage:[UIImage imageNamed:@"effect_disSelected"] forState:UIControlStateNormal];
}

#pragma mark ----------------------------------------- Slider值发生变化
- (IBAction)effected2BtnClicked:(id)sender {
    [self.effect1Btn setBackgroundImage:[UIImage imageNamed:@"effect_disSelected"] forState:UIControlStateNormal];
    [self.effcct2Btn setBackgroundImage:[UIImage imageNamed:@"effect_selected"] forState:UIControlStateNormal];
}

- (void)selectEffect1{
    [self.effect1Btn setBackgroundImage:[UIImage imageNamed:@"effect_selected"] forState:UIControlStateNormal];
    [self.effcct2Btn setBackgroundImage:[UIImage imageNamed:@"effect_disSelected"] forState:UIControlStateNormal];
}

- (void)selectEffect2{
    [self.effect1Btn setBackgroundImage:[UIImage imageNamed:@"effect_disSelected"] forState:UIControlStateNormal];
    [self.effcct2Btn setBackgroundImage:[UIImage imageNamed:@"effect_selected"] forState:UIControlStateNormal];
}

@end
