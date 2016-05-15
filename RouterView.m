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
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x18;
    b3[3] = 0x01;
    b3[4] = 0x00;
    
    NSLog(@"加入路由器的 账号 为：---> %@",ssid);
    NSLog(@"加入路由器的 密码 为：---> %@",pwd);
    NSData * ssidData = [ssid dataUsingEncoding:NSASCIIStringEncoding];
    Byte *ssidBtye = (Byte *)[ssidData bytes];
    
    for(int i=0;i<ssidData.length ;i++){
        b3[i+5] = ssidBtye[i];
    }
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
    [self performSelector:@selector(sendPwdToDevice) withObject:nil afterDelay:0.5];
}

- (void)sendPwdToDevice{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x18;
    b3[3] = 0x02;
    b3[4] = 0x00;
    
    NSString * password = self.pwdField.text;//@"Awise2015@";
    NSData * passwordData = [password dataUsingEncoding:NSASCIIStringEncoding];
    Byte *ssidBtye = (Byte *)[passwordData bytes];
    
    for(int i=0;i<passwordData.length ;i++){
        b3[i+5] = ssidBtye[i];
    }
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
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

#pragma mark ---------------------------------------------------- 处理单色触摸面板返回的数据
- (void)dataBackFormDevice:(Byte *)byte{
    switch (byte[2]) {
        case 0x01:              //读取状态返回值
        {
            
        }
            break;
        case 0x02:              //开关状态返回值
        {
            
        }
            break;
        case 0x03:              //亮度控制返回值
        {
            
        }
            break;
        case 0x04:              //同步时间返回值
        {
            
        }
            break;
        case 0x05:              //设置定时器返回值
        {
            
        }
            break;
        case 0x06:              //设置场景返回值
        {
            
        }
            break;
        case 0x07:              //开关场景返回值
        {
            
        }
            break;
            
        default:
            break;
    }
}


@end
