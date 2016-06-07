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
@synthesize deviceScroll;
@synthesize deviceImgArray;
@synthesize imgMoveTimer;

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
    
//    [self.deviceImage1 setImageWithString:@"单色触摸面板" color:nil circular:YES];
//    [self.deviceImage2 setImageWithString:@"蓝牙RGB" color:nil circular:YES];
//    [self.deviceImage3 setImageWithString:@"水族灯" color:nil circular:YES];
//    [self.deviceImage4 setImageWithString:@"健身房大灯" color:nil circular:YES];
//    
//    
//    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(animationImage1) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:3.1 target:self selector:@selector(animationImage2) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:2.9 target:self selector:@selector(animationImage3) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:4.1 target:self selector:@selector(animationImage4) userInfo:nil repeats:YES];
//    
//    
//    self.deviceImage1.userInteractionEnabled = YES;
//    self.deviceImage2.userInteractionEnabled = YES;
//    self.deviceImage3.userInteractionEnabled = YES;
//    self.deviceImage4.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterSingleTouchController)];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterBuleRGBController)];
//    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterLightFishController)];
//    tap1.delegate = self;
//    tap2.delegate = self;
//    tap3.delegate = self;
//    [self.deviceImage1 addGestureRecognizer:tap1];
//    [self.deviceImage2 addGestureRecognizer:tap2];
//    [self.deviceImage3 addGestureRecognizer:tap3];
    
//监听是否需要重新布局界面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDeviceLayout) name:@"NeedLayoutDevice"
                                               object:nil];
    if([AwiseGlobal sharedInstance].deviceArray.count == 0){
        self.remindLabel.hidden = NO;
    }
}

- (void)updateDeviceLayout{
    if([AwiseGlobal sharedInstance].deviceArray.count > 0){
        self.remindLabel.hidden = YES;
    }
    [self layoutDevice];
}

- (void)viewWillLayoutSubviews{
    if(self.deviceScroll != nil)
        return;
    if([AwiseGlobal sharedInstance].deviceArray.count > 0){
        self.remindLabel.hidden = YES;
    }
    [self layoutDevice];
}

#pragma mark ----------------------------------------- 根据数据库中设备的数量布局界面
- (void)layoutDevice{
    if(self.deviceImgArray.count == 0){
        self.deviceImgArray = [[NSMutableArray alloc] init];
    }
    [self removeScrollSubView];
    int size = 110;         //长宽
    int distance = 80;      //竖间距
    int x = (SCREEN_WIDHT/2 - size)/2;
    int y = 150;
    int contenctHeight = (int)([AwiseGlobal sharedInstance].deviceArray.count/4);
    if(contenctHeight == 0)
        contenctHeight = 1;
    self.deviceScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.deviceScroll.contentSize = CGSizeMake(SCREEN_WIDHT, contenctHeight);
    [self.view addSubview:self.deviceScroll];
    for(int i=0;i<[AwiseGlobal sharedInstance].deviceArray.count;i++){
        NSMutableArray *deviceInfo = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:i];
        if(i%2 == 0){
            x = (SCREEN_WIDHT/2 - size)/2;
            y = size * (i/2) + 150 + distance * (i/2);
        }else{
            x = (SCREEN_WIDHT/2 - size)/2 + SCREEN_WIDHT/2;
            y = size * (i/2) + 150 + distance * (i/2);
        }
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, size, size)];
        [imgView d3_heartbeat];
        [self.deviceImgArray addObject:imgView];
        UIButton    *btn     = [[UIButton alloc] initWithFrame:CGRectMake(x, y, size, size)];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(enterDeviceController:) forControlEvents:UIControlEventTouchUpInside];
        [imgView setImageWithString:[deviceInfo objectAtIndex:0] color:nil circular:YES];
        [self.deviceScroll addSubview:imgView];
        [self.deviceScroll addSubview:btn];
    }
    if(self.imgMoveTimer == nil){
        self.imgMoveTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(deviceImgAnimation) userInfo:nil repeats:YES];
        [self.imgMoveTimer fire];
    }
}

- (void)deviceImgAnimation{
    for(int i=0;i<self.deviceImgArray.count;i++){
        srand((unsigned)time(0));  //不加这句每次产生的随机数不变
        int num = rand() % self.deviceImgArray.count;
        UIImageView *img = (UIImageView *)[self.deviceImgArray objectAtIndex:num];
        [img d3_heartbeat];
    }
}

#pragma mark --------------------------- 进入设备控制界面，根据button的tag值
- (void)enterDeviceController:(UIButton *)sender{
    NSLog(@"sender.tag = %ld",(long)sender.tag);
    long tag = (long)sender.tag;
    NSMutableArray *deviceInfo = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:tag-1];
    NSString *deviceType = [deviceInfo objectAtIndex:5];
    if([deviceType isEqualToString:@"Awise_WIFI_Fish"]){
        LightFishController *lightCon = [[LightFishController alloc] init];
        lightCon.hidesBottomBarWhenPushed = YES;        //隐藏tabbar
        lightCon.deviceInfo = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:tag-1];
        [self.navigationController pushViewController:lightCon animated:YES];
    }else if ([deviceType isEqualToString:@"Awise_WIFI_SingleTouch"]){
        
    }else if([deviceType isEqualToString:@"Awise_Bule_RGB"]){
        
    }
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

#pragma mark --------------------------- 水族灯
-(void)enterLightFishController{
    if([AwiseGlobal sharedInstance].deviceArray.count > 0){
        LightFishController *lightCon = [[LightFishController alloc] init];
        lightCon.hidesBottomBarWhenPushed = YES;        //隐藏tabbar
        lightCon.deviceInfo = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:0];
        [self.navigationController pushViewController:lightCon animated:YES];
    }
}

#pragma mark --------------------------- 移除原有布局
- (void)removeScrollSubView{
    NSArray *subView = [self.deviceScroll subviews];
    for(int i=0;i<subView.count;i++){
        UIView *v = subView[i];
        [v removeFromSuperview];
    }
    [self.deviceScroll removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
