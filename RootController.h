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

@interface RootController : UIViewController <QRCodeReaderDelegate>{
    RoverSqlite *sqlite;
    TCPCommunication *tcpSocket;
}
@property (nonatomic, retain) RoverSqlite *sqlite;
@property (nonatomic, retain) TCPCommunication *tcpSocket;


- (IBAction)VIPClicked:(id)sender;


- (IBAction)searchFun:(id)sender;


- (IBAction)changeFun:(id)sender;


@end
