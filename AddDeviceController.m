//
//  AddDeviceController.m
//  AwiseController
//
//  Created by rover on 16/5/3.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "AddDeviceController.h"
#import "RouterView.h"

@interface AddDeviceController ()

@end

@implementation AddDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidLayoutSubviews{
    
}

- (void)viewWillLayoutSubviews{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------------------------------------------- 点击进入扫描二维码界面
- (IBAction)QRBtnClicked:(id)sender {
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    
    // Set the presentation style
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    // Define the delegate receiver
    vc.delegate = self;
    // Or use blocks
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"扫描结果--->%@", resultAsString);
        [vc stopScanning];
        vc.delegate = nil;
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)showBtnClicked:(id)sender {
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"RouterView" owner:nil options:nil];
    UIView *routeView = [nibView objectAtIndex:0];
    routeView.frame = self.view.frame;
    routeView.alpha = 0.0;
    [UIView beginAnimations:@"animation" context:nil];
    //动画时长
    [UIView setAnimationDuration:0.3];
    routeView.alpha = 1.0;
    //动画结束
    [UIView commitAnimations];
    [self.view addSubview:routeView];
    
}

#pragma mark - 扫描二维码代理
- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
