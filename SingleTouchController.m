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

- (void)viewDidLoad {
    [super viewDidLoad];

    tcpSocket = [[TCPCommunication alloc] init];
//    tcpSocket connectToDevice:<#(NSString *)#> port:<#(int)#>
}

- (void)viewDidAppear:(BOOL)animated{
    tempView = [[UIView alloc] initWithFrame:self.view.bounds];
    tempView.center = CGPointMake(self.view.center.x, self.view.center.y);
    tempView.transform = CGAffineTransformMakeRotation(M_PI_4*3);
    [self.view addSubview:tempView];
    
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
    
    switchState = YES;
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
    NSLog(@"slider.value = %d",value);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
