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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.modeTableView.delegate   = self;
    self.modeTableView.dataSource = self;
    
    
    [AwiseGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *arr1 = [[NSMutableArray alloc]
                            initWithObjects:@"06:00",@"10",@"20",@"30",@"40",@"90", nil];
    NSMutableArray *arr2 = [[NSMutableArray alloc]
                            initWithObjects:@"08:00",@"50",@"60",@"70",@"60",@"50", nil];
    NSMutableArray *arr3 = [[NSMutableArray alloc]
                            initWithObjects:@"10:00",@"20",@"40",@"60",@"80",@"10", nil];
    NSMutableArray *arr4 = [[NSMutableArray alloc]
                            initWithObjects:@"12:00",@"20",@"40",@"60",@"100",@"20", nil];
    NSMutableArray *arr5 = [[NSMutableArray alloc]
                            initWithObjects:@"14:00",@"20",@"40",@"60",@"10",@"50", nil];
    NSMutableArray *arr6 = [[NSMutableArray alloc]
                            initWithObjects:@"16:00",@"20",@"40",@"60",@"40",@"80", nil];
    
    [[AwiseGlobal sharedInstance].lineArray addObject:arr1];
    [[AwiseGlobal sharedInstance].lineArray addObject:arr2];
    [[AwiseGlobal sharedInstance].lineArray addObject:arr3];
    [[AwiseGlobal sharedInstance].lineArray addObject:arr4];
    [[AwiseGlobal sharedInstance].lineArray addObject:arr5];
    [[AwiseGlobal sharedInstance].lineArray addObject:arr6];
    
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
    return 125.;
}

#pragma mark ------------------------------------------------ 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
    lineView *line = [[lineView alloc] init];
    if(iPhone4 || iPhone5)
        line.frame = CGRectMake(81, 5, 231, 90);
    else if (iPhone6)
        line.frame = CGRectMake(81, 5, 286, 90);
    else if (iPhone6P)
        line.frame = CGRectMake(81, 5, 325, 90);
    else
        line.frame = CGRectMake(81, 5, 231, 90);
    [line setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:line];
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
