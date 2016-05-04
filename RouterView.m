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
    self.ssidField.delegate = self;
    self.ssidField.returnKeyType = UIReturnKeyDone;
    self.pwdField.delegate = self;
    self.pwdField.returnKeyType = UIReturnKeyDone;
}


- (IBAction)cancelBtnClicked:(id)sender {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromTop;
    animation.duration = 0.2;
    [self.inputView.layer addAnimation:animation forKey:nil];
    self.inputView.center = self.center;
    [self.ssidField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    self.alpha = 0.0;
    [self removeFromSuperview];
}

- (IBAction)sureBtnClicked:(id)sender {
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromTop;
    animation.duration = 0.2;
    [self.inputView.layer addAnimation:animation forKey:nil];
    self.inputView.center = self.center;
    [self.ssidField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    return YES;
}


- (IBAction)ssidFieldBeginEdit:(id)sender {
    if(self.inputView.center.y < self.center.y){
        return;
    }
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromBottom;
    animation.duration = 0.2;
    [self.inputView.layer addAnimation:animation forKey:nil];
    self.inputView.center = CGPointMake(self.inputView.center.x, self.inputView.center.y-110);
}

- (IBAction)pwdFieldBeginEdit:(id)sender {
    if(self.inputView.center.y < self.center.y){
        return;
    }
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromBottom;
    animation.duration = 0.2;
    [self.inputView.layer addAnimation:animation forKey:nil];
    self.inputView.center = CGPointMake(self.inputView.center.x, self.inputView.center.y-110);
}

- (IBAction)ssidFieldEndEdit:(id)sender {

}

- (IBAction)pwdFieldEndEdit:(id)sender {

}
@end
