//
//  RouterView.m
//  AwiseController
//
//  Created by rover on 16/5/4.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "RouterView.h"

@implementation RouterView
@synthesize wifiAccount;
@synthesize wifiPwd;

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
    [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
    [self removeRouteView];
}

- (void)removeRouteView{
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
    [[AwiseGlobal sharedInstance] showWaitingView];
    self.wifiAccount = self.ssidField.text;
    self.wifiPwd  = self.pwdField.text;
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x18;
    b3[3] = 0x01;
    b3[4] = 0x00;
    
    NSLog(@"加入路由器的 账号 为：---> %@",self.wifiAccount);
    NSLog(@"加入路由器的 密码 为：---> %@",self.wifiPwd);
    NSData * ssidData = [self.wifiAccount dataUsingEncoding:NSASCIIStringEncoding];
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
    
//    NSString * password = self.pwdField.text;//@"Awise2015@";
    NSData * passwordData = [self.wifiPwd dataUsingEncoding:NSASCIIStringEncoding];
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

#pragma mark ---------------------------------------------------- 处理设置完路由器返回的数据
- (void)dataBackFormDevice:(Byte *)byte{
    switch (byte[2]) {
        case 0x18:{              //发送账号密码成功
            if(byte[3] == 0x02){
                [[AwiseGlobal sharedInstance] disMissHUD];
                [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"请稍候，控制器正在重启..." time:20.0];
                //在设备重启的时候，在后台Ping一边局域网
                [self performSelector:@selector(doScanNetwork) withObject:nil afterDelay:10.0];
            }
        }
            break;
            
        default:
            break;
    }
}


- (void)doScanNetwork{
    if([AwiseGlobal sharedInstance].cMode == STA){
        [[AwiseGlobal sharedInstance] scanNetwork];
    }
}


@end
