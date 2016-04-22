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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    sqlite = [[RoverSqlite alloc] init];
    [sqlite openDataBase];
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
    NSMutableArray *arr = [sqlite getAllDeviceInfomation];
    NSLog(@"所有的设备信息 ---> %@",arr);
}

- (IBAction)changeFun:(id)sender {
    [sqlite modifyDeviceName:@"adbachdff" newName:@"Rover"];
}
@end
