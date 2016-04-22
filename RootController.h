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

@interface RootController : UIViewController <QRCodeReaderDelegate>{
    RoverSqlite *sqlite;
}
@property (nonatomic, retain) RoverSqlite *sqlite;


- (IBAction)VIPClicked:(id)sender;


- (IBAction)searchFun:(id)sender;


- (IBAction)changeFun:(id)sender;


@end
