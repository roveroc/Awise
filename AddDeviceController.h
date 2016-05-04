//
//  AddDeviceController.h
//  AwiseController
//
//  Created by rover on 16/5/3.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QRCodeReader.h>
#import <QRCodeReaderViewController.h>

@interface AddDeviceController : UIViewController<QRCodeReaderDelegate>



@property (weak, nonatomic) IBOutlet UIButton *QRBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;


- (IBAction)QRBtnClicked:(id)sender;


@end
