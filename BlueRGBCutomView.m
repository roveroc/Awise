//
//  BlueRGBCutomView.m
//  AwiseController
//
//  Created by rover on 16/6/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "BlueRGBCutomView.h"
#import "AwiseGlobal.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@implementation BlueRGBCutomView
@synthesize colorPicker;
@synthesize R_lbale,G_lbale,B_lbale;
@synthesize R_slider,G_slider,B_slider;
@synthesize R_valueLabel,G_valueLabel,B_valueLabel;
@synthesize R_value,G_value,B_value;
@synthesize editTimer;
@synthesize editIndex;
@synthesize sceneArray;
@synthesize delegate;
@synthesize backScrollView;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if(self.R_lbale != nil)
        return;
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT)];
    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDHT, 667);
    [self addSubview:self.backScrollView];
    
    self.colorPicker = [[KZColorPicker alloc] initWithFrame:self.bounds];
    self.colorPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.colorPicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.colorPicker setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:self.colorPicker];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopShake)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    self.editIndex = -1;
    
    int y = 340;
    int temp = 40;
    self.R_lbale       = [self customLabel:self.R_lbale       rect:CGRectMake(10, y, 20, 20) text:@"R:"];
    self.R_slider      = [self customSlider:self.R_slider     rect:CGRectMake(30, y-5, SCREEN_WIDHT-75, 30)       tag:1];
    self.R_valueLabel = [self customLabel:self.R_valueLabel   rect:CGRectMake(SCREEN_WIDHT-35, y, 40, 20)         text:@"255"];
    
    self.G_lbale       = [self customLabel:self.G_lbale       rect:CGRectMake(10, y+temp, 20, 20) text:@"G:"];
    self.G_slider = [self customSlider:self.G_slider     rect:CGRectMake(30, y-5+temp, SCREEN_WIDHT-75, 30)  tag:2];
    self.G_valueLabel = [self customLabel:self.G_valueLabel rect:CGRectMake(SCREEN_WIDHT-35, y+temp, 40, 20)    text:@"255"];
    
    self.B_lbale       = [self customLabel:self.B_lbale       rect:CGRectMake(10, y+temp*2, 20, 20) text:@"C:"];
    self.B_slider      = [self customSlider:self.B_slider     rect:CGRectMake(30, y-5+temp*2, SCREEN_WIDHT-75, 30) tag:3];
    self.B_valueLabel = [self customLabel:self.B_valueLabel rect:CGRectMake(SCREEN_WIDHT-35, y+temp*2, 40, 20)   text:@"255"];
    
    self.R_slider.minimumTrackTintColor = [UIColor redColor];
    self.G_slider.minimumTrackTintColor = [UIColor greenColor];
    self.B_slider.minimumTrackTintColor = [UIColor blueColor];
    
    [self.backScrollView addSubview:self.R_lbale];
    [self.backScrollView addSubview:self.R_slider];
    [self.backScrollView addSubview:self.R_valueLabel];
    
    [self.backScrollView addSubview:self.G_lbale];
    [self.backScrollView addSubview:self.G_slider];
    [self.backScrollView addSubview:self.G_valueLabel];
    
    [self.backScrollView addSubview:self.B_lbale];
    [self.backScrollView addSubview:self.B_slider];
    [self.backScrollView addSubview:self.B_valueLabel];
    
    NSArray *arr = [[AwiseUserDefault sharedInstance].blueRGB_scene componentsSeparatedByString:@"_"];
    self.sceneArray = [[NSMutableArray alloc] initWithArray:arr];
    
//添加八个默认的UIButton
    int size = 50;
    int gap = (SCREEN_WIDHT - size*4)/5;
    for(int i=0;i<8;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *s = [self.sceneArray objectAtIndex:i];
        NSArray *a  = [s componentsSeparatedByString:@"&"];
        if([a[0] intValue] == -1){
            btn.backgroundColor = [UIColor blackColor];
        }else{
            int r = [a[0] intValue];
            int g = [a[1] intValue];
            int b = [a[2] intValue];
            btn.backgroundColor = [UIColor colorWithRed:r/255. green:g/255. blue:b/7255. alpha:1.0];
        }
        btn.tag = i+10;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = true;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1.0;
        if(i<4){
            btn.frame = CGRectMake((i+1)*gap+i*size, 470, size, size);
        }else{
            btn.frame = CGRectMake(((i-4)+1)*gap+(i-4)*size, 470+70, size, size);
        }
        [self.backScrollView addSubview:btn];
        
        //在btn上添加删除按钮
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"del.png"] forState:UIControlStateNormal];
        delBtn.tag = (i+10)*10;
        delBtn.frame = CGRectMake(20, -20, 30, 30);
        delBtn.hidden = YES;
        if(i<4){
            delBtn.frame = CGRectMake((i+1)*gap+i*size+35, 470-10, 30, 30);
        }else{
            delBtn.frame = CGRectMake(((i-4)+1)*gap+(i-4)*size+35, 470+70-10, 30, 30);
        }
        [delBtn addTarget:self action:@selector(deleteCustomColor:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:delBtn];
        
        //长安
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(shakeCustomBtn)];
        longGesture.delegate = self;
        [btn addGestureRecognizer:longGesture];
        //单机
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(customBtnClick:)];
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(multipleTap:)];
        tapOnce.numberOfTapsRequired = 1;
        tapOnce.delegate = self;
        [btn addGestureRecognizer:tapOnce];
        [tapOnce requireGestureRecognizerToFail:tapTwice];
        //双击
        tapTwice.numberOfTapsRequired = 2;
        tapTwice.delegate = self;
        [btn addGestureRecognizer:tapTwice];
    }
}

#pragma mark ----------------------------------------- 删除自定义的颜色
- (void)deleteCustomColor:(UIButton *)btn{
    int tag = (int)btn.tag/10;
    UIButton *c_btn = (UIButton *)[self viewWithTag:tag];
    [c_btn setBackgroundColor:[UIColor blackColor]];
    int index = tag - 10;
    NSString *rgb = @"-1&-1&-1";
    [self.sceneArray replaceObjectAtIndex:index withObject:rgb];
    [AwiseUserDefault sharedInstance].blueRGB_scene = [self.sceneArray componentsJoinedByString:@"_"];
}

#pragma mark ----------------------------------------- 单机  单机
- (void)customBtnClick:(UIGestureRecognizer *)gesture{
    int tag = (int)gesture.view.tag;
    NSString *rgb = [self.sceneArray objectAtIndex:tag-10];
    NSArray *argbArray = [rgb componentsSeparatedByString:@"&"];
    if([argbArray[0] intValue] == -1){
        [self.delegate customSceneValue:0 g:0 b:0];
    }else{
        [self.delegate customSceneValue:[argbArray[0] intValue] g:[argbArray[1] intValue] b:[argbArray[2] intValue]];
        [self.colorPicker setSelectedColor:[UIColor colorWithRed:[argbArray[0] intValue]/255.
                                                           green:[argbArray[1] intValue]/255.
                                                            blue:[argbArray[2] intValue]/255.
                                                           alpha:1]
                                  animated:YES];
        self.R_value = [argbArray[0] intValue];
        self.R_valueLabel.text = [NSString stringWithFormat:@"%d",[argbArray[0] intValue]];
        self.G_value = [argbArray[1] intValue];
        self.G_valueLabel.text = [NSString stringWithFormat:@"%d",[argbArray[1] intValue]];
        self.B_value = [argbArray[02] intValue];
        self.B_valueLabel.text = [NSString stringWithFormat:@"%d",[argbArray[2] intValue]];
    }
}

#pragma mark ----------------------------------------- 双击  双击
- (void)multipleTap:(UIGestureRecognizer *)sender{
    UIButton *btn = (UIButton *)sender.view;
    if(self.editIndex == (int)btn.tag){
        [self.editTimer invalidate];
        self.editTimer = nil;
        self.editIndex = -1;
    }else{
        self.editIndex = (int)btn.tag;
        NSLog(@"tag 双击 双击 == %d",(int)btn.tag);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:btn forKey:@"btn"];
        if([self.editTimer isValid]){
            [self.editTimer invalidate];
            self.editTimer = nil;
        }
        self.editTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startEditCustomBtn:) userInfo:dict repeats:YES];
        [self.editTimer fire];
    }
}

- (void)startEditCustomBtn:(NSTimer *)timer{
    UIButton *btn = [[timer userInfo] objectForKey:@"btn"];
    [btn d3_heartbeat];
    NSLog(@"tag 双击 双击 == %d",(int)btn.tag);
}

#pragma mark ----------------------------------------- 抖动UIbutton，开始编辑
- (void)shakeCustomBtn{
    for(int i=0;i<8;i++){
        UIButton *btn = (UIButton *)[self.viewForLastBaselineLayout viewWithTag:i+10];
        UIButton *delbtn = (UIButton *)[self.viewForLastBaselineLayout viewWithTag:(i+10)*10];
        delbtn.hidden = NO;
        CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5.0));
        CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5.0));
        btn.transform = leftWobble;  // starting point
        [UIView beginAnimations:@"wobble" context:(__bridge void * _Nullable)(btn)];
        [UIView setAnimationRepeatAutoreverses:YES];
        [UIView setAnimationRepeatCount:5000]; // adjustable
        [UIView setAnimationDuration:0.125];
        [UIView setAnimationDelegate:self];
        btn.transform = rightWobble;         // end here & auto-reverse
        [UIView commitAnimations];
    }
}

#pragma mark ----------------------------------------- 停止UIbutton抖动
- (void)stopShake{
    for(int i=0;i<8;i++){
        UIButton *btn = (UIButton *)[self.viewForLastBaselineLayout viewWithTag:i+10];
        UIButton *delbtn = (UIButton *)[self.viewForLastBaselineLayout viewWithTag:(i+10)*10];
        delbtn.hidden = YES;
        [btn.layer removeAllAnimations];
        CGAffineTransform stop = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0.0));
        btn.transform = stop;
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
    slider.value = 255;
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
            self.R_value = value;
            self.R_valueLabel.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        case 2:
        {
            self.G_value = value;
            self.G_valueLabel.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        case 3:
        {
            self.B_value = value;
            self.B_valueLabel.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        default:
            break;
    }
    [self.colorPicker setSelectedColor:[UIColor colorWithRed:self.R_value/255.
                                                      green:self.G_value/255.
                                                       blue:self.B_value/255.
                                                      alpha:1]
                             animated:YES];
    if(self.editIndex != -1){
        UIButton *btn = (UIButton *)[self viewWithTag:self.editIndex];
        [btn setBackgroundColor:[UIColor colorWithRed:self.R_value/255.
                                                green:self.G_value/255.
                                                 blue:self.B_value/255.
                                                alpha:1]];
        int index = (int)btn.tag - 10;
        NSString *rgb = [NSString stringWithFormat:@"%d&%d&%d",self.R_value,self.G_value,self.B_value];
        [self.sceneArray replaceObjectAtIndex:index withObject:rgb];
        [AwiseUserDefault sharedInstance].blueRGB_scene = [self.sceneArray componentsJoinedByString:@"_"];
    }
    //delegate
    [self.delegate rgbColorChange:self.R_value g:self.G_value b:self.B_value];
}

#pragma mark ----------------------------------- 颜色改变
- (void)pickerChanged:(KZColorPicker *)cp{
    NSString *RGBValue = [NSString stringWithFormat:@"%@",cp.selectedColor];
    NSArray *arr = [RGBValue componentsSeparatedByString:@" "];
    self.R_value = 255*[[arr objectAtIndex:1] floatValue];
    self.G_value = 255*[[arr objectAtIndex:2] floatValue];
    self.B_value = 255*[[arr objectAtIndex:3] floatValue];
    self.R_slider.value = R_value;
    self.G_slider.value = G_value;
    self.B_slider.value = B_value;
    self.R_valueLabel.text = [NSString stringWithFormat:@"%d",self.R_value];
    self.G_valueLabel.text = [NSString stringWithFormat:@"%d",self.G_value];
    self.B_valueLabel.text = [NSString stringWithFormat:@"%d",self.B_value];
    
    if(self.editIndex != -1){
        UIButton *btn = (UIButton *)[self viewWithTag:self.editIndex];
        [btn setBackgroundColor:cp.selectedColor];
        int index = (int)btn.tag - 10;
        NSString *rgb = [NSString stringWithFormat:@"%d&%d&%d",self.R_value,self.G_value,self.B_value];
        [self.sceneArray replaceObjectAtIndex:index withObject:rgb];
        [AwiseUserDefault sharedInstance].blueRGB_scene = [self.sceneArray componentsJoinedByString:@"_"];
    }
    //delegate
    [self.delegate rgbColorChange:self.R_value g:self.G_value b:self.B_value];
}


@end
