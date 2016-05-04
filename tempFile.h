//
//  tempFile.h
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#ifndef tempFile_h
#define tempFile_h


#endif /* tempFile_h */




/*
 
 目的：通过MAC找对应的IP地址
 思路：获取手机的ARP表，轮询查找到IP
 问题：切换手机的连接的WiFi,手机里的ARP表缓存数据好像会清空，导致再次获取手机ARP表的时候不完整，比如路由里有10个设备，
      ARP表只有2个，随着ARP表慢慢重新建立，ARP表记录会有10个。
      一个解决办法，切换WiFi后，先Ping整个局域网（0-255），目的是想让手机建立完整的ARP表，但是Ping0-255等待时间较长，
      而且当局域网内设备较多是，ARP表出现不完整现象。
 参考软件：IP Scanner （苹果商店）,有很多这样的测试软件
 
 */






#pragma mark --- 使用圆圈滑动条代码段
/*
    TBCircularSlider *slider = [[TBCircularSlider alloc]initWithFrame:CGRectMake(0, 60, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    [slider addTarget:self action:@selector(sliderValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
*/

#pragma mark --- 使用二维码功能代码段
/*
 QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
 QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
 
 // Set the presentation style
 vc.modalPresentationStyle = UIModalPresentationFormSheet;
 
 // Define the delegate receiver
 vc.delegate = self;
 
 // Or use blocks
 [reader setCompletionWithBlock:^(NSString *resultAsString) {
 NSLog(@"扫描结果--->%@", resultAsString);
 [self dismissViewControllerAnimated:YES completion:NULL];
 }];
 
 [self presentViewController:vc animated:YES completion:NULL];
 */