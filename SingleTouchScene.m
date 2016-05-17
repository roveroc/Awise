//
//  SingleTouchScene.m
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "SingleTouchScene.h"

@implementation SingleTouchScene
@synthesize selectLabel;

- (void)drawRect:(CGRect)rect {
#pragma mark - 显示场景值
    NSArray *sceneArray = [[AwiseUserDefault sharedInstance].singleTouchSceneValue componentsSeparatedByString:@"&"];
    
    self.label1.text = [[sceneArray objectAtIndex:0] stringByAppendingString:@"%"];
    self.label2.text = [[sceneArray objectAtIndex:1] stringByAppendingString:@"%"];
    self.label3.text = [[sceneArray objectAtIndex:2] stringByAppendingString:@"%"];
    self.label4.text = [[sceneArray objectAtIndex:3] stringByAppendingString:@"%"];
}

#pragma mark ------------------------------------------------ 运行某个场景值
- (IBAction)sceneClicked:(id)sender {
    [[AwiseGlobal sharedInstance] showWaitingView:0];
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x07;
    bt[3]   = 0x01;
    bt[10]  = 0x01;       //数据长度
    bt[18]  = 0x0d;       //结束符
    bt[19]  = 0x0a;
    UIButton *sceneBtn = (UIButton *)sender;
    switch (sceneBtn.tag) {
        case 1:
//            [self setLabelEffect:self.label1];
            self.selectLabel = self.label1;
            bt[11] = 0x01;
            break;
        case 2:
//            [self setLabelEffect:self.label2];
            self.selectLabel = self.label2;
            bt[11] = 0x02;
            break;
        case 3:
//            [self setLabelEffect:self.label3];
            self.selectLabel = self.label3;
            bt[11] = 0x03;
            break;
        case 4:
//            [self setLabelEffect:self.label4];
            self.selectLabel = self.label4;
            bt[11] = 0x04;
            break;
        default:
            break;
    }
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}

#pragma mark ------------------------------------------------ 设置Label的效果
- (void)setLabelEffect:(UILabel *)label{
    self.label1.textColor = [UIColor grayColor];
    self.label2.textColor = [UIColor grayColor];
    self.label3.textColor = [UIColor grayColor];
    self.label4.textColor = [UIColor grayColor];
    self.label1.shadowColor = [UIColor clearColor];
    self.label2.shadowColor = [UIColor clearColor];
    self.label3.shadowColor = [UIColor clearColor];
    self.label4.shadowColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    label.shadowOffset = CGSizeMake(2.0f, 2.0f);
}

#pragma mark ------------------------------------------------ 编辑场景值
- (IBAction)editScene:(id)sender {
    UIButton *sceneBtn = (UIButton *)sender;
    EditSingleTouchSceneController *editCon = [[EditSingleTouchSceneController alloc] init];
    editCon.index = (int)sceneBtn.tag-1;
    editCon.delegate = [self viewController];
    [[self viewController].navigationController pushViewController:editCon animated:YES];
}

#pragma mark ------------------------------------------------ 找寻父Controller
- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
