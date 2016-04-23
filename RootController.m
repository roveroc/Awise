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
    [self.navigationController pushViewController:touchCon animated:YES];

}

- (IBAction)searchFun:(id)sender {
//    NSMutableArray *arr = [sqlite getAllDeviceInfomation];
//    NSLog(@"所有的设备信息 ---> %@",arr);
    
    tcpSocket = [[TCPCommunication alloc] init];
    
    [tcpSocket connectToDevice:@"192.168.3.26" port:333];
    
}

- (IBAction)changeFun:(id)sender {

    Byte b3[20];
    for(int k=0;k<20;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x4d;
    b3[1] = 0x41;
    b3[2] = 0x01;
    b3[3] = 0x05;
    b3[4] = 0x01;
    
    b3[18]= 0x0d;
    b3[19]= 0x0a;
    
    [tcpSocket sendMeesageToDevice:b3 length:20];
}
@end
