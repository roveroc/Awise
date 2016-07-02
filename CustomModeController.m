//
//  CustomModeController.m
//  AwiseController
//
//  Created by rover on 16/6/11.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "CustomModeController.h"

@interface CustomModeController ()

@end

@implementation CustomModeController
@synthesize timerData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.modeTableView.delegate   = self;
    self.modeTableView.dataSource = self;
    
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    [self getDataFromFile];
}

- (void)getDataFromFile{
    NSString *path1;
    NSString *path2;
    NSString *path3;
    NSString *path4;
    NSString *path5;
    NSString *path6;
    NSString *path7;
    [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = LightFishDevice_1_1;
    if([AwiseGlobal sharedInstance].tcpSocket.controlDeviceType == TC420Device){
        path1 = [[AwiseGlobal sharedInstance] getFilePath:@"TC420_timerData1.plist"];
        path2 = [[AwiseGlobal sharedInstance] getFilePath:@"TC420_timerData2.plist"];
        path3 = [[AwiseGlobal sharedInstance] getFilePath:@"TC420_timerData3.plist"];
        path4 = [[AwiseGlobal sharedInstance] getFilePath:@"TC420_timerData4.plist"];
        path5 = [[AwiseGlobal sharedInstance] getFilePath:@"TC420_timerData5.plist"];
        path6 = [[AwiseGlobal sharedInstance] getFilePath:@"TC420_timerData6.plist"];
        path7 = [[AwiseGlobal sharedInstance] getFilePath:@"TC420_timerData7.plist"];
    }else if ([AwiseGlobal sharedInstance].tcpSocket.controlDeviceType == LightFishDevice_1_1){
        path1 = [[AwiseGlobal sharedInstance] getFilePath:@"LightFish11_timerData1.plist"];
        path2 = [[AwiseGlobal sharedInstance] getFilePath:@"LightFish11_timerData2.plist"];
        path3 = [[AwiseGlobal sharedInstance] getFilePath:@"LightFish11_timerData3.plist"];
        path4 = [[AwiseGlobal sharedInstance] getFilePath:@"LightFish11_timerData4.plist"];
        path5 = [[AwiseGlobal sharedInstance] getFilePath:@"LightFish11_timerData5.plist"];
        path6 = [[AwiseGlobal sharedInstance] getFilePath:@"LightFish11_timerData6.plist"];
        path7 = [[AwiseGlobal sharedInstance] getFilePath:@"LightFish11_timerData7.plist"];
    }
    
    NSMutableArray *tempArr1 = [[NSMutableArray alloc] initWithContentsOfFile:path1];
    NSMutableArray *tempArr2 = [[NSMutableArray alloc] initWithContentsOfFile:path2];
    NSMutableArray *tempArr3 = [[NSMutableArray alloc] initWithContentsOfFile:path3];
    NSMutableArray *tempArr4 = [[NSMutableArray alloc] initWithContentsOfFile:path4];
    NSMutableArray *tempArr5 = [[NSMutableArray alloc] initWithContentsOfFile:path5];
    NSMutableArray *tempArr6 = [[NSMutableArray alloc] initWithContentsOfFile:path6];
    NSMutableArray *tempArr7 = [[NSMutableArray alloc] initWithContentsOfFile:path7];
    if(tempArr1 == nil){
        tempArr1 = [[NSMutableArray alloc] init];
    }else{
        [tempArr1 removeObjectAtIndex:0];
    }
    if(tempArr2 == nil){
        tempArr2 = [[NSMutableArray alloc] init];
    }else{
        [tempArr2 removeObjectAtIndex:0];
    }
    if(tempArr3 == nil){
        tempArr3 = [[NSMutableArray alloc] init];
    }else{
        [tempArr3 removeObjectAtIndex:0];
    }
    if(tempArr4 == nil){
        tempArr4 = [[NSMutableArray alloc] init];
    }else{
        [tempArr4 removeObjectAtIndex:0];
    }
    if(tempArr5 == nil){
        tempArr5 = [[NSMutableArray alloc] init];
    }else{
        [tempArr5 removeObjectAtIndex:0];
    }
    if(tempArr6 == nil){
        tempArr6 = [[NSMutableArray alloc] init];
    }else{
        [tempArr6 removeObjectAtIndex:0];
    }
    if(tempArr7 == nil){
        tempArr7 = [[NSMutableArray alloc] init];
    }else{
        [tempArr7 removeObjectAtIndex:0];
    }
    if(self.timerData.count > 1){
        [self.timerData removeAllObjects];
    }
    self.timerData = [[NSMutableArray alloc] initWithObjects:tempArr1,
                      tempArr2,
                      tempArr3,
                      tempArr4,
                      tempArr5,
                      tempArr6,
                      tempArr7, nil];
}

#pragma mark ------------------------------------------------ TC420 编辑的数据被保存，刷新tableView
- (void)dataSaved{
    [self getDataFromFile];
    [self.modeTableView reloadData];
}

#pragma mark ------------------------------------------------ 水族灯1.1版本 编辑的数据被保存，刷新tableView
- (void)LightFish11_dataSaved{
    [self getDataFromFile];
    [self.modeTableView reloadData];
}

#pragma mark ------------------------------------------------ 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark ------------------------------------------------ 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

#pragma mark ------------------------------------------------ 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.;
}

#pragma mark ------------------------------------------------ 点击行，进入帧编辑界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    TC420_EditTimerController *editCon = [[TC420_EditTimerController alloc] init];
//    editCon.fileName       = [NSString stringWithFormat:@"TC420_timerData%d.plist",(int)indexPath.row+1];
//    editCon.timerInfoArray = [[NSMutableArray alloc] initWithContentsOfFile:editCon.fileName];
//    editCon.delegate       = self;
//    [self.navigationController pushViewController:editCon animated:YES];
    
    LightFish11_EditTimerController *com = [[LightFish11_EditTimerController alloc] init];
    com.fileName       = [NSString stringWithFormat:@"LightFish11_timerData%d.plist",(int)indexPath.row+1];
    NSString *filePath = [[AwiseGlobal sharedInstance] getFilePath:com.fileName];
    com.timerInfoArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    com.delegate       = self;
    com.timerNumber    = (int)indexPath.row;
    [self.navigationController pushViewController:com animated:YES];
}

#pragma mark ------------------------------------------------ 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* CellIdentifier = @"";
    UITableViewCell* cell = nil;
    
    CellIdentifier =@"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"CustomModeCell" owner:self options:nil];
        if(iPhone4 || iPhone5)
            cell = (UITableViewCell *)[array  objectAtIndex:0];
        else if(iPhone6)
            cell = (UITableViewCell *)[array  objectAtIndex:1];
        else if(iPhone6P)
            cell = (UITableViewCell *)[array  objectAtIndex:2];
        else
            cell = (UITableViewCell *)[array  objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *imgView = [cell viewWithTag:1];
        [imgView  setImageWithString:@"效果1" color:nil circular:YES];
    }
    UIImageView *imgview = (UIImageView *)[cell viewWithTag:10];
    UILabel *msgLabel    = (UILabel *)[cell viewWithTag:100];
    NSMutableArray *tempArr = [self.timerData objectAtIndex:indexPath.row];
    NSLog(@"row = lineArraylineArraylineArraylineArray %@",tempArr);
    if(tempArr != nil && tempArr.count > 0){
        NSLog(@"row = %ld",(long)indexPath.row);
        imgview.hidden = NO;
        msgLabel.hidden = YES;
        lineView *line = [[lineView alloc] init];
        line.pipeNumber = 5;
        line.lineDataArray = tempArr;
        line.userInteractionEnabled = NO;
        if(iPhone4 || iPhone5)
            line.frame = CGRectMake(78, 5, 231, 90);
        else if (iPhone6)
            line.frame = CGRectMake(78, 5, 286, 90);
        else if (iPhone6P)
            line.frame = CGRectMake(78, 5, 325, 90);
        else
            line.frame = CGRectMake(78, 5, 231, 90);
        [line setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:line];
    }else{
        msgLabel.hidden = NO;
        imgview.hidden = YES;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
