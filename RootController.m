//
//  RootController.m
//  AwiseController
//
//  Created by rover on 16/4/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "RootController.h"
#import "SingleTouchController.h"


@interface RootController ()

@end

@implementation RootController
@synthesize sqlite;
@synthesize tcpSocket;


- (void)animationImage1{
    [self.deviceImage1 d3_heartbeat];
}

- (void)animationImage2{
    [self.deviceImage2 d3_heartbeat];
}

- (void)animationImage3{
    [self.deviceImage3 d3_heartbeat];
}

- (void)animationImage4{
    [self.deviceImage4 d3_heartbeat];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     *根据当前设备的数量和种类布局界面
     */
    
    
    [self.deviceImage2 setImageWithString:@"Blue" color:nil circular:YES];
    [self.deviceImage3 setImageWithString:@"Water" color:nil circular:YES];
    [self.deviceImage4 setImageWithString:@"Wait" color:nil circular:YES];
    self.deviceImage1.image = [UIImage imageNamed:@"area_school.png"];
    [self.deviceImage1 setImageWithString:@"Touch" color:nil circular:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(animationImage1) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:3.1 target:self selector:@selector(animationImage2) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:2.9 target:self selector:@selector(animationImage3) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:4.1 target:self selector:@selector(animationImage4) userInfo:nil repeats:YES];
    
    
    self.deviceImage1.userInteractionEnabled = YES;
    self.deviceImage2.userInteractionEnabled = YES;
    self.deviceImage3.userInteractionEnabled = YES;
    self.deviceImage4.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterSingleTouchController)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterBuleRGBController)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterLightFishController)];
    tap1.delegate = self;
    tap2.delegate = self;
    tap3.delegate = self;
    [self.deviceImage1 addGestureRecognizer:tap1];
    [self.deviceImage2 addGestureRecognizer:tap2];
    [self.deviceImage3 addGestureRecognizer:tap3];
}

#pragma mark --------------------------- 单色触摸面板
- (void)enterSingleTouchController{
    SingleTouchController *touchCon = [[SingleTouchController alloc] init];
    touchCon.hidesBottomBarWhenPushed = YES;        //隐藏tabbar
    [self.navigationController pushViewController:touchCon animated:YES];
}

#pragma mark --------------------------- 蓝牙
- (void)enterBuleRGBController{
    BlueRGBController *blueCon = [[BlueRGBController alloc] init];
    [self.navigationController pushViewController:blueCon animated:YES];
}

#pragma mark ---------------------------水族灯
-(void)enterLightFishController{
    LightFishController *lightCon = [[LightFishController alloc] init];
    lightCon.hidesBottomBarWhenPushed = YES;        //隐藏tabbar
    [self.navigationController pushViewController:lightCon animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
