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