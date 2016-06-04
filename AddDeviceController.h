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
#import "RoverSqlite.h"
#import "AwiseGlobal.h"
#import "RouterView.h"

@interface AddDeviceController : UIViewController<QRCodeReaderDelegate,TCPSocketDelegate>{
    RoverSqlite                 *sql;
    RouterView                  *routeView;
}
@property (nonatomic, retain) RoverSqlite                   *sql;                   //数据库对象
@property (nonatomic, retain) RouterView                    *routeView;


@property (weak, nonatomic) IBOutlet UIButton *QRBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;




- (IBAction)QRBtnClicked:(id)sender;
- (IBAction)showBtnClicked:(id)sender;


@end
