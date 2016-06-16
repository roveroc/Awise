//
//  TC_MainController.m
//  AwiseController
//
//  Created by rover on 16/6/10.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "TC_MainController.h"
#import "AwiseGlobal.h"
#import "CustomModeController.h"
#import "LightFishController.h"

@interface TC_MainController ()

@end

@implementation TC_MainController
@synthesize slider1;
@synthesize slider2;
@synthesize slider3;
@synthesize slider4;
@synthesize slider5;
@synthesize value_label1;
@synthesize value_label2;
@synthesize value_label3;
@synthesize value_label4;
@synthesize value_label5;
@synthesize effectImgView;
@synthesize lightImgView;
@synthesize cloudyImgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -------------------------------- 初始化Slider
- (UISlider *)customInitSlider:(UISlider *)slider tag:(int)tag{
    slider = [[UISlider alloc] init];
    slider.tag = tag;
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.minimumTrackTintColor = [UIColor colorWithRed:0x90/255.
                                                   green:0xee/255.
                                                    blue:0x90/255.
                                                   alpha:1.0];
    slider.maximumTrackTintColor = [UIColor colorWithRed:0xd1/255.
                                                   green:0xee/255.
                                                    blue:0xee/255.
                                                   alpha:1.0];
    [slider addTarget:self
               action:@selector(sliderVauleChange:)
     forControlEvents:UIControlEventValueChanged];
    return slider;
}

#pragma mark -------------------------------- 初始化UIlabel
- (UILabel *)customInitLabel:(UILabel *)label{
    label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Arial" size:15];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"100%";
    return label;
}

#pragma mark -------------------------------- 滑动条值改变函数
- (void)sliderVauleChange:(id)sender{
    UISlider *slider = (UISlider *)sender;
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

#pragma mark -------------------------------- 布局界面
- (void)viewWillLayoutSubviews{
    if(self.slider1 != nil)
        return;
    self.slider1 = [self customInitSlider:self.slider1 tag:1];
    self.slider2 = [self customInitSlider:self.slider2 tag:2];
    self.slider3 = [self customInitSlider:self.slider3 tag:3];
    self.slider4 = [self customInitSlider:self.slider4 tag:4];
    self.slider5 = [self customInitSlider:self.slider5 tag:5];
    
    self.value_label1 = [self customInitLabel:self.value_label1];
    self.value_label2 = [self customInitLabel:self.value_label2];
    self.value_label3 = [self customInitLabel:self.value_label3];
    self.value_label4 = [self customInitLabel:self.value_label4];
    self.value_label5 = [self customInitLabel:self.value_label5];
    
    self.effectImgView = [[UIImageView alloc] init];
    self.lightImgView  = [[UIImageView alloc] init];
    self.cloudyImgView = [[UIImageView alloc] init];
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(enterEffectController)];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(enterLightingController)];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(enterCloudyController)];
    gesture1.delegate = self;
    gesture2.delegate = self;
    gesture3.delegate = self;
    [self.effectImgView addGestureRecognizer:gesture1];
    [self.lightImgView  addGestureRecognizer:gesture2];
    [self.cloudyImgView addGestureRecognizer:gesture3];
    
    int gap = SCREEN_WIDHT/5;    //每一个间隔宽度
    int sliderWidth = 250;       //Slider宽度
    int slider_y    = 360;       //slider的y坐标
    int slider1_x = 0*gap + (gap/2) - sliderWidth/2;
    int slider2_x = 1*gap + (gap/2) - sliderWidth/2;
    int slider3_x = 2*gap + (gap/2) - sliderWidth/2;
    int slider4_x = 3*gap + (gap/2) - sliderWidth/2;
    int slider5_x = 4*gap + (gap/2) - sliderWidth/2;
    
    int labelWidth = 50;
    int labelHeiht = 25;
    int label_y   = 225;
    int label1_x  = 0*gap + (gap/2)-labelWidth/2;
    int label2_x  = 1*gap + (gap/2)-labelWidth/2;
    int label3_x  = 2*gap + (gap/2)-labelWidth/2;
    int label4_x  = 3*gap + (gap/2)-labelWidth/2;
    int label5_x  = 4*gap + (gap/2)-labelWidth/2;
    
    int imageViewSize = 80;     //imageview的大小
    int imageGap = SCREEN_WIDHT/3;
    int image_y  = label_y + sliderWidth + 35;
    int image1_x = 0*imageGap + (imageGap/2)-imageViewSize/2;
    int image2_x = 1*imageGap + (imageGap/2)-imageViewSize/2;
    int image3_x = 2*imageGap + (imageGap/2)-imageViewSize/2;
    
    self.slider1.frame = CGRectMake(slider1_x, slider_y, sliderWidth, 30);
    self.slider2.frame = CGRectMake(slider2_x, slider_y, sliderWidth, 30);
    self.slider3.frame = CGRectMake(slider3_x, slider_y, sliderWidth, 30);
    self.slider4.frame = CGRectMake(slider4_x, slider_y, sliderWidth, 30);
    self.slider5.frame = CGRectMake(slider5_x, slider_y, sliderWidth, 30);
    
    self.value_label1.frame = CGRectMake(label1_x, label_y, labelWidth, labelHeiht);
    self.value_label2.frame = CGRectMake(label2_x, label_y, labelWidth, labelHeiht);
    self.value_label3.frame = CGRectMake(label3_x, label_y, labelWidth, labelHeiht);
    self.value_label4.frame = CGRectMake(label4_x, label_y, labelWidth, labelHeiht);
    self.value_label5.frame = CGRectMake(label5_x, label_y, labelWidth, labelHeiht);
    
    self.lightImgView.frame = CGRectMake(image1_x, image_y, imageViewSize, imageViewSize);
    self.effectImgView.frame  = CGRectMake(image2_x, image_y, imageViewSize, imageViewSize);
    self.cloudyImgView.frame = CGRectMake(image3_x, image_y, imageViewSize, imageViewSize);
    self.lightImgView.userInteractionEnabled = YES;
    self.effectImgView.userInteractionEnabled = YES;
    self.cloudyImgView.userInteractionEnabled = YES;
    [self.lightImgView  setImageWithString:@"闪电效果" color:nil circular:YES];
    [self.effectImgView setImageWithString:@"自定义效果" color:nil circular:YES];
    [self.cloudyImgView setImageWithString:@"多云效果" color:nil circular:YES];
    
    self.slider1.transform = CGAffineTransformRotate(self.slider1.transform,270.0/180*M_PI);
    self.slider2.transform = CGAffineTransformRotate(self.slider2.transform,270.0/180*M_PI);
    self.slider3.transform = CGAffineTransformRotate(self.slider3.transform,270.0/180*M_PI);
    self.slider4.transform = CGAffineTransformRotate(self.slider4.transform,270.0/180*M_PI);
    self.slider5.transform = CGAffineTransformRotate(self.slider5.transform,270.0/180*M_PI);
    
    [self.view addSubview:self.slider1];
    [self.view addSubview:self.slider2];
    [self.view addSubview:self.slider3];
    [self.view addSubview:self.slider4];
    [self.view addSubview:self.slider5];
    
    [self.view addSubview:self.value_label1];
    [self.view addSubview:self.value_label2];
    [self.view addSubview:self.value_label3];
    [self.view addSubview:self.value_label4];
    [self.view addSubview:self.value_label5];
    
    [self.view addSubview:self.effectImgView];
    [self.view addSubview:self.lightImgView];
    [self.view addSubview:self.cloudyImgView];
}

#pragma mark --------------------------------------- 进入自定义效果
- (void)enterEffectController{
    CustomModeController *customCon = [[CustomModeController alloc] init];
    [self.navigationController pushViewController:customCon animated:YES];
}

#pragma mark --------------------------------------- 进入闪电效果
- (void)enterLightingController{
    LightFishController *con = [[LightFishController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark --------------------------------------- 进入多云效果
- (void)enterCloudyController{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
