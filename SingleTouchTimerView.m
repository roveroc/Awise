//
//  SingleTouchTimerView.m
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "SingleTouchTimerView.h"

@implementation SingleTouchTimerView



- (void)drawRect:(CGRect)rect {
    self.timerTable.delegate = self;
    self.timerTable.dataSource = self;
    [self.timerTable reloadData];
}


#pragma mark ------------------------------------------------ 将文件中保存的定时器数据解析到界面
- (void)parseTimerDataToCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UILabel  *timeLabel = [cell viewWithTag:1];
    UILabel  *weekLabel = [cell viewWithTag:2];
    UILabel  *perLabel  = [cell viewWithTag:3];
    UISwitch *_switch   = [cell viewWithTag:4];
    NSMutableArray *arr = [[AwiseGlobal sharedInstance].singleTouchTimerArray objectAtIndex:indexPath.row];
    timeLabel.text = [arr objectAtIndex:0];
    perLabel.text = [arr objectAtIndex:1];
}

#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

#pragma mark 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.;
}

#pragma mark 点击行出发
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditSingleTouchTimerController *timerCon = [[EditSingleTouchTimerController alloc] init];
    timerCon.timerIndex = (int)indexPath.row;
    [[self viewController].navigationController pushViewController:timerCon animated:YES];
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"TimerCell" owner:self options:nil];
        if(iPhone4 || iPhone5)
            cell = (UITableViewCell *)[array  objectAtIndex:0];
        else if(iPhone6)
            cell = (UITableViewCell *)[array  objectAtIndex:1];
        else if(iPhone6P)
            cell = (UITableViewCell *)[array  objectAtIndex:2];
    }
    [self parseTimerDataToCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark - 找寻父Controller
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
