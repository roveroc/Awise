//
//  SingleTouchController.m
//  AwiseController
//
//  Created by rover on 16/4/22.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "SingleTouchController.h"

@interface SingleTouchController ()

@end

@implementation SingleTouchController
@synthesize tbSlider;
@synthesize switchButton;
@synthesize tempView;
@synthesize switchState;
@synthesize tcpSocket;
@synthesize timerTable;
@synthesize sceneView;

- (void)viewDidLoad {
    [super viewDidLoad];

    tcpSocket = [[TCPCommunication alloc] init];
//    tcpSocket connectToDevice:<#(NSString *)#> port:<#(int)#>
}

- (void)viewDidAppear:(BOOL)animated{
    if(tempView != nil)
        return;
    tempView = [[UIView alloc] initWithFrame:self.view.bounds];
    tempView.center = CGPointMake(self.view.center.x, self.view.center.y);
    tempView.transform = CGAffineTransformMakeRotation(M_PI_4*3);
    
    tbSlider = [[TBCircularSlider alloc]initWithFrame:CGRectMake(0, 0, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    [tbSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    tbSlider.center = self.view.center;
    [tempView addSubview:tbSlider];

    switchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    switchButton.layer.cornerRadius = switchButton.frame.size.height/2;
    switchButton.layer.masksToBounds = YES;
    [switchButton setContentMode:UIViewContentModeScaleAspectFill];
    [switchButton setClipsToBounds:YES];
    switchButton.center = self.view.center;
    [switchButton setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_open@3x.png"] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchButton];
    
    NSArray *nibView01 = [[NSBundle mainBundle] loadNibNamed:@"SingleTouchTimerView" owner:nil options:nil];
    timerTable = [nibView01 firstObject];
    timerTable.frame = CGRectMake(SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
    
    NSArray *nibView02 = [[NSBundle mainBundle] loadNibNamed:@"SingleTouchScene" owner:nil options:nil];
    sceneView = [nibView02 firstObject];
    sceneView.frame = CGRectMake(SCREEN_WIDHT*2, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
    
    [self.view addSubview:tempView];
    [self.view addSubview:timerTable];
    [self.view addSubview:sceneView];
    
    switchState = YES;
    centerPoint = self.view.center;
    [self.view bringSubviewToFront:self.controlSegment];
    [self.view bringSubviewToFront:switchButton];
}


#pragma mark ------------------------------------------------ 开关
- (void)switchFunction:(id)sender{
    if(switchState == YES){
        [switchButton setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_open@3x.png"] forState:UIControlStateNormal];
        switchState = NO;
    }
    else{
        [switchButton setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_close@3x.png"] forState:UIControlStateNormal];
        switchState = YES;
    }
}

#pragma mark ------------------------------------------------ 圆环代理,值发生改变触发
- (void)sliderValueChange:(TBCircularSlider *)slider{
    if(slider.angle < 90)
        return;
    int value = (100/270.)*(360-slider.angle);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ------------------------------------------------ 点击切换界面
- (IBAction)SwitchControlMode:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0){
        [UIView beginAnimations:nil context:nil];   //开始动画
        [UIView setAnimationDuration:0.3];          //动画时长
        timerTable.frame = CGRectMake(SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        sceneView.frame = CGRectMake(SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        tempView.center = centerPoint;
        switchButton.center = centerPoint;
        [UIView commitAnimations];
        
    }
    else if (seg.selectedSegmentIndex == 1){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        timerTable.frame = CGRectMake(SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        sceneView.frame = CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        tempView.center = CGPointMake(-500, tempView.center.y);
        switchButton.center = CGPointMake(-500, switchButton.center.y);
        [UIView commitAnimations];
    }
    else if (seg.selectedSegmentIndex == 2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        timerTable.frame = CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        sceneView.frame = CGRectMake(-SCREEN_WIDHT, 0, SCREEN_WIDHT, SCREEN_HEIGHT);
        tempView.center = CGPointMake(-500, tempView.center.y);
        switchButton.center = CGPointMake(-500, switchButton.center.y);
    }
}
@end
