//
//  SaveDataView.m
//  AwiseController
//
//  Created by rover on 16/6/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "SaveDataView.h"

@implementation SaveDataView
@synthesize delegate;
@synthesize weekArray;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

#pragma mark ----------------------------------------- 加载以保存的值
- (void)loadWeekData:(NSMutableArray *)arr{
    self.weekArray = [[NSMutableArray alloc] initWithArray:(NSArray *)arr];
    for(int i=0;i<arr.count;i++){
        UIButton *btn = [self viewWithTag:i+1];
        if ([[arr objectAtIndex:i] intValue] == 1){
            btn.backgroundColor = [UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.];
        }else if ([[arr objectAtIndex:i] intValue] == 0){
            btn.backgroundColor = [UIColor grayColor];
        }
    }
}


- (void)cornerBtn:(UIButton *)btn{
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = true;
}

- (void)drawRect:(CGRect)rect {
    [self cornerBtn:self.btn1];
    [self cornerBtn:self.btn2];
    [self cornerBtn:self.btn3];
    [self cornerBtn:self.btn4];
    [self cornerBtn:self.btn5];
    [self cornerBtn:self.btn6];
    [self cornerBtn:self.btn7];
    [self cornerBtn:self.btn8];
    [self cornerBtn:self.cancelBtn];
    [self cornerBtn:self.okBtn];
}

#pragma mark ----------------------------------------- 点击选择星期
- (IBAction)weekBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int value = [[self.weekArray objectAtIndex:btn.tag-1] intValue];
    if(value == 1){         //表示选中当天
        [weekArray replaceObjectAtIndex:btn.tag-1 withObject:@"0"];
        btn.backgroundColor = [UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.];
    }else if(value == 0){   //表示没选中当天
        [weekArray replaceObjectAtIndex:btn.tag-1 withObject:@"1"];
        btn.backgroundColor = [UIColor grayColor];
    }
}

#pragma mark ----------------------------------------- 取消，不保存
- (IBAction)cancelBtnClicked:(id)sender {
    [self.delegate cancelSave];
}

#pragma mark ----------------------------------------- 保存编辑的数据
- (IBAction)okBtnClicked:(id)sender {
    [self.delegate okSave:self.weekArray];
}
@end
