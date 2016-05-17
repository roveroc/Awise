//
//  SingleTouchScene.m
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "SingleTouchScene.h"

@implementation SingleTouchScene


- (void)drawRect:(CGRect)rect {
#pragma mark - 显示场景值
    NSArray *sceneArray = [[AwiseUserDefault sharedInstance].singleTouchSceneValue componentsSeparatedByString:@"&"];
    [self.sceneBtn1 setTitle:[[sceneArray objectAtIndex:0] stringByAppendingString:@"%"]
                    forState:UIControlStateNormal];
    [self.sceneBtn2 setTitle:[[sceneArray objectAtIndex:1] stringByAppendingString:@"%"]
                    forState:UIControlStateNormal];
    [self.sceneBtn3 setTitle:[[sceneArray objectAtIndex:2] stringByAppendingString:@"%"]
                    forState:UIControlStateNormal];
    [self.sceneBtn4 setTitle:[[sceneArray objectAtIndex:3] stringByAppendingString:@"%"]
                    forState:UIControlStateNormal];

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
            bt[11] = 0x01;
            break;
        case 2:
            bt[11] = 0x02;
            break;
        case 3:
            bt[11] = 0x03;
            break;
        case 4:
            bt[11] = 0x04;
            break;
        default:
            break;
    }
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
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
