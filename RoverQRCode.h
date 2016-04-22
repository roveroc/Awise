//
//  QRCodeRover.h
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol RoverQRCodeDelegate <NSObject>

- (void)RoverQRCodeScanResult:(NSString *)result;

@end

@interface RoverQRCode : NSObject <AVCaptureMetadataOutputObjectsDelegate,RoverQRCodeDelegate>{
    AVCaptureSession * session;//输入输出的中间桥梁
    id<RoverQRCodeDelegate> delegate;
}
@property (nonatomic, retain) AVCaptureSession * session;
@property (nonatomic, retain) id<RoverQRCodeDelegate>   delegate;

- (void)startScan:(UIViewController *)controller;


@end
