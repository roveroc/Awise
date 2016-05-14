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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     *根据当前设备的数量和种类布局界面
     */
    
}

- (void)viewWillAppear:(BOOL)animated{
    
}


#pragma mark - 扫描二维码代理
- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 圆环代理
- (void)sliderValue:(TBCircularSlider *)slider{
    NSLog(@"Slider Value %d",slider.angle);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)VIPClicked:(id)sender {
    SingleTouchController *touchCon = [[SingleTouchController alloc] init];
    touchCon.hidesBottomBarWhenPushed = YES;        //隐藏tabbar
    [self.navigationController pushViewController:touchCon animated:YES];

}

- (IBAction)searchFun:(id)sender {
//    tcpSocket = [[TCPCommunication alloc] init];
//    [tcpSocket connectToDevice:@"192.168.3.26" port:5050];
//    [AwiseGlobal sharedInstance].delegate = self;

    LightFishController *lightCon = [[LightFishController alloc] init];
    lightCon.hidesBottomBarWhenPushed = YES;        //隐藏tabbar
    [self.navigationController pushViewController:lightCon animated:YES];
    
}

- (void)scanNetworkFinish{
    NSLog(@"扫码完毕，开始获取ARP表");
    NSMutableDictionary *dic = [[AwiseGlobal sharedInstance] getARPTable];
    NSLog(@"ARP表获取成功 = %@",dic);
}



#pragma mark - ping IP 返回的结果
- (void)ipIsOnline:(BOOL)result{
    NSLog(@"result = %d",result);
}

- (IBAction)changeFun:(id)sender {
    BlueRGBController *blueCon = [[BlueRGBController alloc] init];
    [self.navigationController pushViewController:blueCon animated:YES];
}
@end
