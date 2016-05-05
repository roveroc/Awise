//
//  RouterView.m
//  AwiseController
//
//  Created by rover on 16/5/4.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "RouterView.h"

@implementation RouterView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.ssidField.delegate         = self;
    self.ssidField.returnKeyType    = UIReturnKeyDone;
    self.ssidField.placeholder      = @"路由器帐号";
    [self.ssidField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.ssidField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.pwdField.delegate          = self;
    self.pwdField.returnKeyType     = UIReturnKeyDone;
    self.pwdField.placeholder      = @"路由器密码";
    [self.pwdField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.pwdField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}

#pragma mark ------------------------------------------------ 取消
- (IBAction)cancelBtnClicked:(id)sender {
    [UIView beginAnimations:@"animation" context:nil];
    //动画时长
    [UIView setAnimationDuration:0.3];
    self.alpha = 0.0;
    //动画结束
    [UIView commitAnimations];
    [self.ssidField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    [self performSelector:@selector(removeInputView) withObject:nil afterDelay:0.4];
}

#pragma mark ------------------------------------------------ 动画完成后，移除View
- (void)removeInputView{
    self.ssidField.delegate = nil;
    self.pwdField.delegate = nil;
    [self.inputView removeFromSuperview];
}

#pragma mark ------------------------------------------------ 确定
- (IBAction)sureBtnClicked:(id)sender {
    if(self.ssidField.text.length < 1){                 //改变提示颜色
        self.ssidField.placeholder = @"帐号不能为空";
        [self.ssidField setValue:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        return;
    }
    NSString *ssid = self.ssidField.text;
    NSString *pwd  = self.pwdField.text;
}

#pragma mark ------------------------------------------------ 点击Done，即完成按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView beginAnimations:@"animation" context:nil];
    //动画时长
    [UIView setAnimationDuration:0.3];
    self.inputView.center = self.center;
    //动画结束
    [UIView commitAnimations];
    
    [self.ssidField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    return YES;
}

#pragma mark ------------------------------------------------ 点击输入框，开始编辑
- (IBAction)ssidFieldBeginEdit:(id)sender {
    if(self.inputView.center.y < self.center.y){
        return;
    }
    [UIView beginAnimations:@"animation" context:nil];
    //动画时长
    [UIView setAnimationDuration:0.3];
    self.inputView.center = CGPointMake(self.inputView.center.x, self.inputView.center.y-110);
    //动画结束
    [UIView commitAnimations];
    
}

#pragma mark ------------------------------------------------ 点击输入框，开始编辑
- (IBAction)pwdFieldBeginEdit:(id)sender {
    if(self.inputView.center.y < self.center.y){
        return;
    }
    [UIView beginAnimations:@"animation" context:nil];
    //动画时长
    [UIView setAnimationDuration:0.3];
    self.inputView.center = CGPointMake(self.inputView.center.x, self.inputView.center.y-110);
    //动画结束
    [UIView commitAnimations];
}


@end
