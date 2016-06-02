//
//  RootController.h
//  AwiseController
//
//  Created by rover on 16/4/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QRCodeReaderViewController.h>
#import "RoverSqlite.h"
#import "TCPCommunication.h"
#import "AwiseGlobal.h"
#import "LightFishController.h"
#import "BlueRGBController.h"
#import <UIImageView+Letters.h>
#import "D3View.h"

@interface RootController : UIViewController <QRCodeReaderDelegate,PingDelegate,UIGestureRecognizerDelegate>{
    RoverSqlite             *sqlite;
    TCPCommunication        *tcpSocket;
    UIScrollView            *deviceScroll;
    NSMutableArray          *deviceImgArray;
    NSTimer                 *imgMoveTimer;
}
@property (nonatomic, retain) RoverSqlite           *sqlite;
@property (nonatomic, retain) TCPCommunication      *tcpSocket;
@property (nonatomic, retain) UIScrollView          *deviceScroll;
@property (nonatomic, retain) NSMutableArray        *deviceImgArray;
@property (nonatomic, retain) NSTimer               *imgMoveTimer;

- (IBAction)VIPClicked:(id)sender;
- (IBAction)searchFun:(id)sender;
- (IBAction)changeFun:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *deviceImage1;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage2;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage3;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage4;

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;



@end
