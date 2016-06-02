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
@synthesize sql;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sql = [[RoverSqlite alloc] init];
    [self.sql openDataBase];
}

#pragma mark ------------------------------------------------ 断开连接
- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
    }
}

#pragma mark --------------------- 连接设备成功
- (void)TCPSocketConnectSuccess{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(showMsg)
                                               object:nil];
    [[AwiseGlobal sharedInstance] disMissHUD];
}

- (void)viewDidLayoutSubviews{
    
}

- (void)viewWillLayoutSubviews{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------------------------------------------- 扫码到设备后，连接设备
- (void)connectDevice:(NSString *)ip port:(NSString *)port{
    [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"正在连接设备" time:2.0];
    [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:ip port:port];
    [self performSelector:@selector(showMsg) withObject:nil afterDelay:2.0];
}

//如果设备没有连接成功，则提示是否设备正常上电在工作
- (void)showMsg{
    if(![[AwiseGlobal sharedInstance].tcpSocket.socket isConnected]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请确保设备在正常工作";
        [hud hide:YES afterDelay:0.8];
        [[[UIApplication sharedApplication] keyWindow] addSubview:hud];
    }
}

#pragma mark ------------------------------------------- 点击扫描二维码,扫描成功后，加入数据库
- (IBAction)QRBtnClicked:(id)sender {
    if([AwiseGlobal sharedInstance].wifiSSID != nil && [[AwiseGlobal sharedInstance].wifiSSID rangeOfString:@"Awise-"].location != NSNotFound){
        QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
        // Set the presentation style
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        // Define the delegate receiver
        vc.delegate = self;
        // Or use blocks
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSMutableArray *infoArr = [[NSMutableArray alloc] init];
    //DeviceName&5ccf7f1b4390&192.168.3.26&30000&1.1.1.1&Awise_WIFI_Fish&www.awise123.com
            if([resultAsString rangeOfString:@"Awise"].location != NSNotFound){
                if([resultAsString rangeOfString:@"Awise_WIFI"].location != NSNotFound){             //表明扫描到是Wifi类控制器
                    //NSString *info = [resultAsString substringFromIndex:9];
                    infoArr = (NSMutableArray *)[resultAsString componentsSeparatedByString:@"&"];
                    NSLog(@"infoArr = %@",infoArr);
                    NSString *ip   = [infoArr objectAtIndex:2];
                    NSString *port = [infoArr objectAtIndex:3];
                    [self connectDevice:ip port:port];
                }else if([resultAsString rangeOfString:@"AwiseBLE"].location != NSNotFound){            //表明扫描到是蓝牙类控制器
                    //NSString *info = [resultAsString substringFromIndex:9];
    //DeviceName&5ccf7f1b4390&192.168.3.26&333&1.1.1.1&Awise_Bule_RGB&www.awise123.com
                    infoArr = (NSMutableArray *)[resultAsString componentsSeparatedByString:@"&"];
                }
                for(int i=0;i<[AwiseGlobal sharedInstance].deviceArray.count;i++){                  //判断设备是否已经添加过
                    NSMutableArray *temp = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:i];
                    if([temp containsObject:[infoArr objectAtIndex:1]]){
                        NSLog(@"该产品已添加");
                        goto break_label;       //跳出比较
                    }
                }
                if([self.sql insertDeivceInfo:infoArr] == YES){
                    NSLog(@"添加的产品信息成功 --- %@", infoArr);
                    [AwiseGlobal sharedInstance].deviceArray = [self.sql getAllDeviceInfomation];   //获取所有已添加设备信息
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedLayoutDevice" object:nil];
                }else{
                    NSLog(@"添加的产品信息出错，请再次添加");
                }
            }else{
                NSLog(@"请扫描购买设备配套的二维码，更多产品信息：www.awise123.com");
            }
        break_label:[vc stopScanning];
            vc.delegate = nil;
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else{
        [[AwiseGlobal sharedInstance] showRemindMsg:@"请先连接将要添加的设备WIFI" withTime:1.5];
    }
}

#pragma mark ------------------------------------- 弹出加入路由对话框
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
