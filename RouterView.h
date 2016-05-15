//
//  RouterView.h
//  AwiseController
//
//  Created by rover on 16/5/4.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"

@interface RouterView : UIView <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *backGroundImg;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *ssidField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)sureBtnClicked:(id)sender;

- (IBAction)ssidFieldBeginEdit:(id)sender;
- (IBAction)pwdFieldBeginEdit:(id)sender;
- (IBAction)ssidFieldEndEdit:(id)sender;
- (IBAction)pwdFieldEndEdit:(id)sender;




@end
