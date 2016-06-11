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
    for (int i=0; i<10; i++) {
        NSMutableArray *arr;
        if(i == 0){
            arr = [[NSMutableArray alloc] initWithObjects:@"1:10",@"20",@"30",@"40", nil];
        }else if(i == 1){
            arr = [[NSMutableArray alloc] initWithObjects:@"3:10",@"40",@"11",@"22", nil];
        }else if(i == 2){
            arr = [[NSMutableArray alloc] initWithObjects:@"5:10",@"14",@"33",@"55", nil];
        }else if(i == 3){
            arr = [[NSMutableArray alloc] initWithObjects:@"10:10",@"64",@"34",@"26", nil];
        }else if(i == 4){
            arr = [[NSMutableArray alloc] initWithObjects:@"12:10",@"78",@"45",@"55", nil];
        }else if(i == 5){
            arr = [[NSMutableArray alloc] initWithObjects:@"13:10",@"77",@"90",@"55", nil];
        }else if(i == 6){
            arr = [[NSMutableArray alloc] initWithObjects:@"15:10",@"88",@"33",@"22", nil];
        }else{
            arr = [[NSMutableArray alloc] initWithObjects:@"15:10",@"11",@"65",@"98", nil];
        }
        
        
        [[AwiseGlobal sharedInstance].lineArray addObject:arr];
    }
    
    
    
    
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
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *imgView = [cell viewWithTag:1];
        [imgView  setImageWithString:@"效果1" color:nil circular:YES];
    }
    lineView *line = [[lineView alloc] init];
    line.frame = CGRectMake(13, 70, SCREEN_WIDHT-28, 100);
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
