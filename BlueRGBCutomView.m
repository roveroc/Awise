//
//  BlueRGBCutomView.m
//  AwiseController
//
//  Created by rover on 16/6/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "BlueRGBCutomView.h"
#import "AwiseGlobal.h"

@implementation BlueRGBCutomView
@synthesize colorPicker;
@synthesize R_lbale,G_lbale,B_lbale;
@synthesize R_slider,G_slider,B_slider;
@synthesize R_valueLabel,G_valueLabel,B_valueLabel;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if(self.R_lbale != nil)
        return;
    self.colorPicker = [[KZColorPicker alloc] initWithFrame:self.bounds];
    self.colorPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.colorPicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.colorPicker setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.colorPicker];
    
    int y = 400;
    int temp = 40;
    self.R_lbale       = [self customLabel:self.R_lbale       rect:CGRectMake(10, y, 20, 20) text:@"R:"];
    self.R_slider      = [self customSlider:self.R_slider     rect:CGRectMake(30, y-5, SCREEN_WIDHT-75, 30)       tag:1];
    self.R_valueLabel = [self customLabel:self.R_valueLabel   rect:CGRectMake(SCREEN_WIDHT-40, y, 40, 20)         text:@"0"];
    
    self.G_lbale       = [self customLabel:self.G_lbale       rect:CGRectMake(10, y+temp, 20, 20) text:@"G:"];
    self.G_slider = [self customSlider:self.G_slider     rect:CGRectMake(30, y-5+temp, SCREEN_WIDHT-75, 30)  tag:2];
    self.G_valueLabel = [self customLabel:self.G_valueLabel rect:CGRectMake(SCREEN_WIDHT-45, y+temp, 40, 20)    text:@"0"];
    
    self.B_lbale       = [self customLabel:self.B_lbale       rect:CGRectMake(10, y+temp*2, 20, 20) text:@"C:"];
    self.B_slider      = [self customSlider:self.B_slider     rect:CGRectMake(30, y-5+temp*2, SCREEN_WIDHT-75, 30) tag:3];
    self.B_valueLabel = [self customLabel:self.B_valueLabel rect:CGRectMake(SCREEN_WIDHT-40, y+temp*2, 40, 20)   text:@"0"];
    
    self.R_slider.minimumTrackTintColor = [UIColor redColor];
    self.G_slider.minimumTrackTintColor = [UIColor greenColor];
    self.B_slider.minimumTrackTintColor = [UIColor blueColor];
    
    [self addSubview:self.R_lbale];
    [self addSubview:self.R_slider];
    [self addSubview:self.R_valueLabel];
    
    [self addSubview:self.G_lbale];
    [self addSubview:self.G_slider];
    [self addSubview:self.G_valueLabel];
    
    [self addSubview:self.B_lbale];
    [self addSubview:self.B_slider];
    [self addSubview:self.B_valueLabel];
    
//添加八个默认的UIButton
    int size = 60;
    int gap = (SCREEN_WIDHT - size*4)/5;
    //int x   = gap;
    for(int i=0;i++;i<8){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+10;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = true;
        if(i<4){
            btn.frame = CGRectMake((i+1)*gap+i*size, 430, size, size);
        }else{
            btn.frame = CGRectMake((i+1)*gap+i*size, 430+70, size, size);
        }
        [self addSubview:btn];
    }
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
    slider.maximumValue = 255;
    slider.minimumValue = 0;
    slider.value = 0;
    slider.tag = tag;
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    return slider;
}

#pragma mark ----------------------------------------- Slider值发生变化
- (void)sliderValueChange:(UISlider *)slider{
    int value = (int)slider.value;
    switch (slider.tag) {
        case 1:
        {
            self.R_valueLabel.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        case 2:
        {
            self.G_valueLabel.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        case 3:
        {
            self.B_valueLabel.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        default:
            break;
    }
}

#pragma mark ----------------------------------- 颜色改变
- (void)pickerChanged:(KZColorPicker *)cp{
    
}


@end
