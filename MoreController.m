//
//  MoreController.m
//  AwiseController
//
//  Created by rover on 16/4/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "MoreController.h"
#import "ManageDeviceController.h"
#import "AboutUsController.h"

@interface MoreController ()

@end

@implementation MoreController
@synthesize tableViewItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableViewItems = [[NSArray alloc] initWithObjects:
                           [[AwiseGlobal sharedInstance] DPLocalizedString:@"addDevice"],
                           [[AwiseGlobal sharedInstance] DPLocalizedString:@"managerDevice"],
                           [[AwiseGlobal sharedInstance] DPLocalizedString:@"about"],
                           nil];
    self.moreTable.delegate   = self;
    self.moreTable.dataSource = self;
    self.moreTable.tableFooterView = [[UIView alloc] init];
    
    if([AwiseGlobal sharedInstance].tcpSocket == nil ||
       [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType != SingleTouchDevice){
        [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
        [AwiseGlobal sharedInstance].tcpSocket.delegate = nil;
    }
    [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    [AwiseGlobal sharedInstance].tcpSocket.controlDeviceType = SingleTouchDevice;  //受控设备为触摸面板
//    [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:@"192.168.3.26" port:30000];
}

- (void)TCPSocketConnectSuccess{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------------------------------------------------ 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark ------------------------------------------------ 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewItems.count;
}

#pragma mark ------------------------------------------------ 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.;
}

#pragma mark ------------------------------------------------ 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        AddDeviceController *addCon = [[AddDeviceController alloc] init];
        addCon.hidesBottomBarWhenPushed = YES;        //隐藏tabbar
        [self.navigationController pushViewController:addCon animated:YES];
    }
    else if (indexPath.row == 1){
        ManageDeviceController *manCon = [[ManageDeviceController alloc] init];
        manCon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:manCon animated:YES];
    }
    else if (indexPath.row == 2){
        AboutUsController *manCon = [[AboutUsController alloc] init];
        manCon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:manCon animated:YES];
    }
    else if (indexPath.row == 3){
        [self sendRouterAccount];
    }
}


- (void)sendRouterAccount{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x18;
    b3[3] = 0x01;
    b3[4] = 0x00;
    

    NSData * ssidData = [@"AwiseTechnology" dataUsingEncoding:NSASCIIStringEncoding];
    Byte *ssidBtye = (Byte *)[ssidData bytes];
    
    for(int i=0;i<ssidData.length ;i++){
        b3[i+5] = ssidBtye[i];
    }
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
    [self performSelector:@selector(sendPwdToDevice) withObject:nil afterDelay:0.5];
}

- (void)sendPwdToDevice{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x18;
    b3[3] = 0x02;
    b3[4] = 0x00;
    
    NSString * password = @"Awise2015@";
    NSData * passwordData = [password dataUsingEncoding:NSASCIIStringEncoding];
    Byte *ssidBtye = (Byte *)[passwordData bytes];
    
    for(int i=0;i<passwordData.length ;i++){
        b3[i+5] = ssidBtye[i];
    }
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    [[AwiseGlobal sharedInstance].tcpSocket sendMeesageToDevice:b3 length:64];
}

#pragma mark ------------------------------------------------ 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row == 0)
        cell.imageView.image=[UIImage imageNamed:@"addDevice.png"];
    else if(indexPath.row == 1)
        cell.imageView.image=[UIImage imageNamed:@"set.png"];
    else if(indexPath.row == 2)
        cell.imageView.image=[UIImage imageNamed:@"aboutUs.png"];
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.textLabel.text = [self.tableViewItems objectAtIndex:indexPath.row];
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

@end
