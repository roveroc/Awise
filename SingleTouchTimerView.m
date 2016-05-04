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
    self.timerTable.tableFooterView = [[UIView alloc] init];
    [self.timerTable reloadData];
}


#pragma mark ------------------------------------------------ 将文件中保存的定时器数据解析到界面
- (void)parseTimerDataToCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UILabel  *timeLabel = [cell viewWithTag:1];
    UILabel  *perLabel  = [cell viewWithTag:3];
    UILabel  *weekLabel = [cell viewWithTag:2];
    UISwitch *_switch   = [cell viewWithTag:4];
    NSMutableArray *arr = [[AwiseGlobal sharedInstance].singleTouchTimerArray objectAtIndex:indexPath.row];
    timeLabel.text = [arr objectAtIndex:0];
    perLabel.text = [[arr objectAtIndex:1] stringByAppendingString:@"%"];
    weekLabel.text = [[AwiseGlobal sharedInstance] convertWeekDayToString:[arr objectAtIndex:2]];
    if([[arr objectAtIndex:3] intValue] == 0){
        [_switch setOn:NO];
    }
    else{
        [_switch setOn:YES];
    }
    [_switch addTarget:self action:@selector(operateSwitch:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark ------------------------------------------------ 操作开关,发送指令
- (void)operateSwitch:(id)sender{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    UITableViewCell *cell;
    if([phoneVersion intValue] > 8){
        UIView *v = [sender superview];             //获取父类view
        cell = (UITableViewCell *)[v superview];    //获取cell
    }
    int index = (int)cell.tag-10;
    UISwitch *swi = (UISwitch *)[cell viewWithTag:4];
    NSString *value = [NSString stringWithFormat:@"%d",swi.on];
    NSMutableArray *temp = [[AwiseGlobal sharedInstance].singleTouchTimerArray objectAtIndex:index];
    [temp replaceObjectAtIndex:3 withObject:value];
    [[AwiseGlobal sharedInstance].singleTouchTimerArray writeToFile:[[AwiseGlobal sharedInstance] getFilePath:AwiseSingleTouchTimer]
                                                         atomically:YES];
    Byte bt[20];
    for(int k=0;k<20;k++){
        bt[k] = 0x00;
    }
    bt[0]   = 0x4d;
    bt[1]   = 0x41;
    bt[2]   = 0x03;
    bt[3]   = 0x01;
    bt[10]  = 0x01;       //数据长度
    bt[18]  = 0x0d;       //结束符
    bt[19]  = 0x0a;
    
    bt[11] = index;
    bt[12] = [[temp lastObject] intValue];
    bt[13] = [[temp objectAtIndex:1] intValue];
    NSArray *weekArr = [[temp objectAtIndex:2] componentsSeparatedByString:@"&"];
    Byte tt = 0b00000000;                           //八位二进制表示：周一到每天，1表示使能
    for(int i=(int)(weekArr.count-1);i>-1;i--){
        if([[weekArr objectAtIndex:i] intValue] == 1){
            tt += (1<<((weekArr.count-1)-i));
        }
    }
    bt[14] = tt;
    NSArray *timeArr = [[temp objectAtIndex:0] componentsSeparatedByString:@":"];
    bt[15] = [[timeArr objectAtIndex:0] intValue];
    bt[16] = [[timeArr objectAtIndex:1] intValue];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:bt length:20];
}

#pragma mark ------------------------------------------------ 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark ------------------------------------------------ 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

#pragma mark ------------------------------------------------ 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.;
}

#pragma mark ------------------------------------------------ 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditSingleTouchTimerController *timerCon = [[EditSingleTouchTimerController alloc] init];
    timerCon.timerIndex = (int)indexPath.row;       //记录当前编辑的定时器
    timerCon.timerStatusArray = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].singleTouchTimerArray
                                                       objectAtIndex:indexPath.row]];       //抽出将要编辑的定时器
    timerCon.delegate = [self viewController];
    [[self viewController].navigationController pushViewController:timerCon animated:YES];
}

#pragma mark ------------------------------------------------ 返回每行的单元格
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
    cell.tag = indexPath.row+10;    //+10,避免和cell上的Switch冲突
    [self parseTimerDataToCell:cell indexPath:indexPath];
    return cell;
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
