//
//  DeviceMannagerController.h
//  FishDemo
//
//  Created by rover on 16/3/5.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"
#import "MBProgressHUD.h"

@interface DeviceMannagerController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSString                *nameStr;
    NSString                *ssidStr;       //wifi账号
    NSString                *pwdStr;        //wifi密码
    Byte                    attest;         //wifi认证方式  <在wifi有设置密码的提前下>
    Byte                    encrypt;        //wifi加密模式  <在wifi有设置密码的提前下>
    MBProgressHUD           *hud;
}
@property (nonatomic, retain) NSString          *nameStr;
@property (nonatomic, retain) NSString          *ssidStr;
@property (nonatomic, retain) NSString          *pwdStr;
@property (assign)            Byte              attest;
@property (assign)            Byte              encrypt;
@property (nonatomic, retain) MBProgressHUD     *hud;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UITableView *deviceTable;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameFeild;
@property (weak, nonatomic) IBOutlet UITextField *ssidFeild;
@property (weak, nonatomic) IBOutlet UITextField *pwdFeild;


@property (weak, nonatomic) IBOutlet UIButton *sendBtn;


@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *attestLabel;
@property (weak, nonatomic) IBOutlet UILabel *encryptLabel;

@property (weak, nonatomic) IBOutlet UIButton *wpapskBtn;
@property (weak, nonatomic) IBOutlet UIButton *wpa2pskBtn;
@property (weak, nonatomic) IBOutlet UIButton *tkipBtn;
@property (weak, nonatomic) IBOutlet UIButton *aesBtn;


- (IBAction)wpapskBtnClicked:(id)sender;
- (IBAction)wpa2pskBtnClicked:(id)sender;
- (IBAction)tkipBtnClicked:(id)sender;
- (IBAction)aesBtnClicked:(id)sender;




- (IBAction)sendBtnClicked:(id)sender;

- (IBAction)editNameFun:(id)sender;
- (IBAction)editSSIDFun:(id)sender;
- (IBAction)editPWDFun:(id)sender;




@end
