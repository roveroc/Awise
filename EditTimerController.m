//
//  EditTimerController.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "EditTimerController.h"
#import "lineView.h"
#import "DetailEditController.h"

@interface EditTimerController ()

@end

@implementation EditTimerController
@synthesize navTitle;
@synthesize timerTable;
@synthesize oldArray;
@synthesize tableRow;
@synthesize lineview;
@synthesize fileName;
@synthesize dataArr;

- (void)viewWillAppear:(BOOL)animated{
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    if([AwiseGlobal sharedInstance].freshFlag == YES){
        [self.timerTable reloadData];
        if(self.lineview != nil){
            [self.lineview removeFromSuperview];
            self.lineview = [[lineView alloc] init];
            self.lineview.frame = CGRectMake(10, 70, SCREEN_WIDHT-20, 100);
            [self.lineview setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:self.lineview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[AwiseGlobal sharedInstance] hideTabBar:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backFun)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = self.navTitle;
    
    self.lineview = [[lineView alloc] init];
    self.lineview.frame = CGRectMake(13, 70, SCREEN_WIDHT-28, 100);
    [self.lineview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.lineview];
    
    CGRect rect;
    UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dBtn setBackgroundImage:[UIImage imageNamed:@"btnBackimg.png"] forState:UIControlStateNormal];
    [dBtn addTarget:self action:@selector(downDataToDevice) forControlEvents:UIControlEventTouchUpInside];
    [dBtn setTitle:@"DownLoad" forState:UIControlStateNormal];
    if(iPhone4){
        rect = CGRectMake(10, 230, 300, 160);
        dBtn.frame = CGRectMake(75, 408, 171, 45);
    }
    else if(iPhone5){
        rect = CGRectMake(10, 230, SCREEN_WIDHT, 260);
        dBtn.frame = CGRectMake(75, 510, 171, 45);
    }
    else{
        rect = CGRectMake(10, 230, SCREEN_WIDHT, 320);
        dBtn.frame = CGRectMake(75, 610, 171, 45);
    }
    [self.view addSubview:dBtn];
    dBtn.center = CGPointMake(SCREEN_WIDHT/2, dBtn.center.y);
    
    timerTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    timerTable.delegate = self;
    timerTable.dataSource = self;
    [timerTable setBackgroundColor:[UIColor whiteColor]];
    self.tableRow = 6;
    [self.view addSubview:timerTable];
    
//    [[AwiseGlobal sharedInstance].lineArray removeAllObjects];
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:[self getPlistPath]];
    if(arr.count > 0)
        [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] initWithArray:(NSArray *)arr];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self getPlistPath]]){
        NSLog(@"exist");
    }
    
#pragma mark ---------------------------------------- 默认三个时间段的值
    if([AwiseGlobal sharedInstance].lineArray.count == 0){
        NSMutableArray *arr1 = [[NSMutableArray alloc] initWithObjects:@"06:00",@"10",@"20",@"30", nil];
        NSMutableArray *arr2 = [[NSMutableArray alloc] initWithObjects:@"08:00",@"50",@"60",@"70", nil];
        NSMutableArray *arr3 = [[NSMutableArray alloc] initWithObjects:@"10:00",@"20",@"40",@"60", nil];
        NSMutableArray *arr4 = [[NSMutableArray alloc] initWithObjects:@"12:00",@"20",@"40",@"60", nil];
        NSMutableArray *arr5 = [[NSMutableArray alloc] initWithObjects:@"14:00",@"20",@"40",@"60", nil];
        NSMutableArray *arr6 = [[NSMutableArray alloc] initWithObjects:@"16:00",@"20",@"40",@"60", nil];
        
        [[AwiseGlobal sharedInstance].lineArray addObject:arr1];
        [[AwiseGlobal sharedInstance].lineArray addObject:arr2];
        [[AwiseGlobal sharedInstance].lineArray addObject:arr3];
        [[AwiseGlobal sharedInstance].lineArray addObject:arr4];
        [[AwiseGlobal sharedInstance].lineArray addObject:arr5];
        [[AwiseGlobal sharedInstance].lineArray addObject:arr6];
        
        [[AwiseGlobal sharedInstance].lineArray writeToFile:[self getPlistPath] atomically:YES];
    }
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] initWithContentsOfFile:[self getPlistPath]];
//将数据备份
    self.oldArray = [[NSMutableArray alloc] initWithContentsOfFile:[self getPlistPath]];
    
    self.dataArr = [[NSMutableArray alloc] init];
}

#pragma mark ---------------------------------------- 下载数据到设备
- (void)downDataToDevice{
    [[AwiseGlobal sharedInstance] showWaitingView];
    NSLog(@"下载数据到设备 ");
    if(self.dataArr.count > 0)
       [self.dataArr removeAllObjects];
    
    Byte b3[64];
    
    for(int i = 0;i<[AwiseGlobal sharedInstance].lineArray.count;i++){
        NSMutableArray *temp = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:i];
        int index = 5;
        for(int k=0;k<64;k++){
            b3[k] = 0x00;
        }
        b3[0] = 0x55;
        b3[1] = 0xAA;
        b3[2] = 0x01;
        b3[3] = [AwiseGlobal sharedInstance].timerNumber;
        b3[4] = 0x00;
        if(i==0)
            b3[index++] = 0x01;
        else if(i==1)
            b3[index++] = 0x02;
        else if(i==2)
            b3[index++] = 0x03;
        else if(i==3)
            b3[index++] = 0x04;
        else if(i==4)
            b3[index++] = 0x05;
        else if(i==5)
            b3[index++] = 0x06;
        for(int j=0;j<temp.count;j++){
            
            if(j == 0){
                NSArray *time = [[temp objectAtIndex:0] componentsSeparatedByString:@":"];
                b3[index++] = [[time objectAtIndex:0] intValue];
                b3[index++] = [[time objectAtIndex:1] intValue];
            }
            else{
                b3[index++] = [[temp objectAtIndex:j] intValue];
            }
            
        }
        b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
        NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
        [self.dataArr addObject:data];
    }
    
    for(int i=0;i<self.dataArr.count;i++){
        NSData *dd = [self.dataArr objectAtIndex:i];
        [self performSelector:@selector(sendTimerData:) withObject:dd afterDelay:i*0.5];
    }
}

#pragma mark ---------------------------------------------------- 数据返回超时
- (void)dataBackTimeOut{
    [[AwiseGlobal sharedInstance] disMissHUD];
}


#pragma mark ----------------------------------- 解析从设备的返回值
- (void)dataBackFormDevice:(Byte *)byte{
    [[AwiseGlobal sharedInstance] disMissHUD];
    if (byte[2] == 0x01 && byte[5] == 0x00){                           //下载数据到设备是否成功
        [[AwiseGlobal sharedInstance] showRemindMsg:@"设置定时器数据失败" withTime:1.5];
    }
}

- (void)sendTimerData:(NSData *)dd{
    Byte *by = (Byte *)[dd bytes];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:by length:64];
}

#pragma mark ---------------------------------------- 获取数据存储路径
- (NSString *)getPlistPath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:self.fileName];
    NSString *path = [[AwiseGlobal sharedInstance] getFilePath:self.fileName];
    return path;
}


#pragma mark ---------------------------------------- 返回
- (void)backFun{
    self.hidesBottomBarWhenPushed = NO;
    [[AwiseGlobal sharedInstance].lineArray writeToFile:[self getPlistPath] atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---------------------------------------- 保存
- (void)SaveData{
    NSLog(@"保存");
    [[AwiseGlobal sharedInstance].lineArray writeToFile:[self getPlistPath] atomically:YES];
    [self backFun];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* CellIdentifier = @"";
    UITableViewCell* cell = nil;
    
    CellIdentifier =@"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"RoverCell" owner:self options:nil];
        if(iPhone4 || iPhone5)
            cell = (UITableViewCell *)[array  objectAtIndex:0];
        else if(iPhone6)
            cell = (UITableViewCell *)[array  objectAtIndex:1];
        else if(iPhone6P)
            cell = (UITableViewCell *)[array  objectAtIndex:2];
        cell.backgroundColor = [UIColor clearColor];
        UIButton *editBtn = (UIButton *)[cell viewWithTag:17];
        [editBtn addTarget:self action:@selector(enterEditView:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    NSMutableArray *arr = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:indexPath.row];
    
    UILabel *b1 = (UILabel *)[cell viewWithTag:11];
    int r = (int)indexPath.row + 1;
    NSString *s = r > 9 ? [NSString stringWithFormat:@"%d",r] : [NSString stringWithFormat:@"0%d",r];
    b1.text = s;
    
    UILabel *tl = (UILabel *)[cell viewWithTag:12];
    UILabel *rl = (UILabel *)[cell viewWithTag:13];
    UILabel *gl = (UILabel *)[cell viewWithTag:14];
    UILabel *bl = (UILabel *)[cell viewWithTag:15];
//    UILabel *wl = (UILabel *)[cell viewWithTag:16];
    tl.text = [arr objectAtIndex:0];
    rl.text = [arr objectAtIndex:1];
    gl.text = [arr objectAtIndex:2];
    bl.text = [arr objectAtIndex:3];
//    wl.text = [arr objectAtIndex:4];
    
    return cell;
}


- (void)enterEditView:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell;
    if( [[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        cell = (UITableViewCell *)btn.superview.superview;
    }
    else{
        cell = (UITableViewCell *)btn.superview.superview.superview;
    }
    DetailEditController *detailCon = [[DetailEditController alloc] init];
    detailCon.navTitle = [self.navTitle stringByAppendingFormat:@"--%d",(int)cell.tag+1];
    NSMutableArray *tt = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray objectAtIndex:(int)cell.tag]];
    detailCon.singleArray = [tt mutableCopy];
    detailCon.index = (int)cell.tag;
    [self.navigationController pushViewController:detailCon animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableRow;
}

#pragma mark ---------------------------------------- 添加行（最大24）
- (IBAction)addRow:(id)sender {
    if(tableRow > 23)
        tableRow = 24;
    else{
        tableRow++;
        NSMutableArray *temp = [[AwiseGlobal sharedInstance].lineArray lastObject];
        NSString *timeS = [temp[0] copy];
        NSArray *arr = [timeS componentsSeparatedByString:@":"];
        if([arr[0] intValue] < 24){
            NSString *_timeS = [NSString stringWithFormat:@"%d:%@",[arr[0] intValue]+1,arr[1]];
            NSMutableArray *newArr = [[NSMutableArray alloc] initWithObjects:_timeS,@"50",@"50",@"50",@"50", nil];
            [[AwiseGlobal sharedInstance].lineArray addObject:newArr];
        }
        else{
            NSMutableArray *newArr = [[NSMutableArray alloc] initWithObjects:timeS,@"50",@"50",@"50",@"50", nil];
            [[AwiseGlobal sharedInstance].lineArray addObject:newArr];
        }
        [self.timerTable reloadData];
    }
}

#pragma mark ---------------------------------------- 添加行（最小3）
- (IBAction)subRow:(id)sender {
    if(tableRow < 4)
        tableRow = 3;
    else{
        tableRow--;
        [[AwiseGlobal sharedInstance].lineArray removeLastObject];
        [self.timerTable reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
