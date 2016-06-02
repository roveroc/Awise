//
//  ManageDeviceController.m
//  AwiseController
//
//  Created by rover on 16/5/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "ManageDeviceController.h"

@interface ManageDeviceController ()

@end

@implementation ManageDeviceController
@synthesize tempButton;
@synthesize routeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.deviceTable.delegate = self;
    self.deviceTable.dataSource = self;
    
    self.tempButton = [[UIButton alloc] init];
}

#pragma mark ------------------------------------------------ 断开连接
- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[AwiseGlobal sharedInstance].tcpSocket breakConnect:[AwiseGlobal sharedInstance].tcpSocket.socket];
    }
}


#pragma mark ------------------------------------------------ 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark ------------------------------------------------ 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [AwiseGlobal sharedInstance].deviceArray.count;
}

#pragma mark ------------------------------------------------ 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.;
}

#pragma mark ------------------------------------------------ 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ------------------------------------------------ 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"MannageCell"
                                                       owner:self
                                                     options:nil];
        if(iPhone4 || iPhone5)
            cell = (UITableViewCell *)[array  objectAtIndex:0];
        else if(iPhone6)
            cell = (UITableViewCell *)[array  objectAtIndex:1];
        else if(iPhone6P)
            cell = (UITableViewCell *)[array  objectAtIndex:2];
        UIButton *nameBtn  = (UIButton *)[cell viewWithTag:11];
        UIButton *routeBtn = (UIButton *)[cell viewWithTag:12];
        UIButton *delBtn   = (UIButton *)[cell viewWithTag:13];
        [nameBtn addTarget:self action:@selector(editNameFunction:) forControlEvents:UIControlEventTouchUpInside];
        [routeBtn addTarget:self action:@selector(editRouteFunction:) forControlEvents:UIControlEventTouchUpInside];
        [delBtn addTarget:self action:@selector(delDeviceFunction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.tag = indexPath.row;
    NSMutableArray *deviceInfo = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = [cell viewWithTag:10];
    nameLabel.text = [deviceInfo objectAtIndex:0];
    return cell;
}

#pragma mark --------------------------------- 编辑设备名
- (void)editNameFunction:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell;
    if( [[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        cell = (UITableViewCell *)btn.superview.superview;
    }
    else{
        cell = (UITableViewCell *)btn.superview.superview.superview;
    }
    NSMutableArray *deviceInfo = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:cell.tag];
    self.tempButton = (UIButton *)sender;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"取个响亮的名字吧" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
    alert.tag = 1;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *text = [alert textFieldAtIndex:0];
    text.placeholder = [deviceInfo objectAtIndex:0];
    alert.delegate = self;
    [alert show];
}

#pragma mark --------------------------------- 加入路由
- (void)editRouteFunction:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell;
    if( [[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        cell = (UITableViewCell *)btn.superview.superview;
    }
    else{
        cell = (UITableViewCell *)btn.superview.superview.superview;
    }
    NSMutableArray *deviceInfo = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:cell.tag];
    NSString *ip;
    NSString *port;
    if([AwiseGlobal sharedInstance].cMode == AP){
        ip   = [deviceInfo objectAtIndex:2];
        port = [deviceInfo objectAtIndex:3];
        NSString *macStr = [[[[AwiseGlobal sharedInstance].wifiSSID componentsSeparatedByString:@"-"] lastObject] lowercaseStringWithLocale:[NSLocale currentLocale]];
        if([[deviceInfo objectAtIndex:1] rangeOfString:macStr].location != NSNotFound){
            [self connectDevice:ip port:port];
        }else{
            [[AwiseGlobal sharedInstance] showRemindMsg:@"请先连接至该设备Wifi" withTime:2.0];
        }
        
    }else if([AwiseGlobal sharedInstance].cMode == STA){
        ip   = [deviceInfo objectAtIndex:4];
        port = [deviceInfo objectAtIndex:3];
        [self connectDevice:ip port:port];
    }else{
        [[AwiseGlobal sharedInstance] showRemindMsg:@"请先连接至Wifi" withTime:1.2];
    }
}

#pragma mark ------------------------------------------- 扫码到设备后，连接设备
- (void)connectDevice:(NSString *)ip port:(NSString *)port{
    [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"正在连接设备" time:2.0];
    [AwiseGlobal sharedInstance].tcpSocket = [[TCPCommunication alloc] init];
    [AwiseGlobal sharedInstance].tcpSocket.delegate = self;
    [[AwiseGlobal sharedInstance].tcpSocket connectToDevice:ip port:port];
    [self performSelector:@selector(showMsg) withObject:nil afterDelay:2.0];
}

//如果设备没有连接成功，则提示是否设备正常上电在工作
- (void)showMsg{
    if(![[AwiseGlobal sharedInstance].tcpSocket.socket isConnected]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请确保设备在正常工作";
        [hud hide:YES afterDelay:0.8];
        [[[UIApplication sharedApplication] keyWindow] addSubview:hud];
    }
}


#pragma mark --------------------------------- 连接设备成功
- (void)TCPSocketConnectSuccess{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(showMsg)
                                               object:nil];
    [[AwiseGlobal sharedInstance] disMissHUD];
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"RouterView" owner:nil options:nil];
    routeView = [nibView objectAtIndex:0];
    routeView.frame = self.view.frame;
    routeView.alpha = 0.0;
    [UIView beginAnimations:@"animation" context:nil];
    //动画时长
    [UIView setAnimationDuration:0.3];
    routeView.alpha = 1.0;
    //动画结束
    [UIView commitAnimations];
    [self.view addSubview:routeView];
}

#pragma mark --------------------------------- 弹出框代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITableViewCell *cell;
    if( [[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        cell = (UITableViewCell *)self.tempButton.superview.superview;
    }
    else{
        cell = (UITableViewCell *)self.tempButton.superview.superview.superview;
    }
    NSMutableArray *deviceInfo = [[AwiseGlobal sharedInstance].deviceArray objectAtIndex:cell.tag];
    if(alertView.tag == 1){
        UITextField *filed = [alertView textFieldAtIndex:0];
        if(filed.text.length == 0){
            filed.placeholder = @"不能为空";
            return;
        }
        if(buttonIndex == 1){
            NSString *mac = [deviceInfo objectAtIndex:1];
            RoverSqlite *sql = [[RoverSqlite alloc] init];
            if([sql modifyDeviceName:mac newName:filed.text]){
                [AwiseGlobal sharedInstance].deviceArray = [sql getAllDeviceInfomation];
                [self.deviceTable reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedLayoutDevice" object:nil];
            }
        }
    }
    else if (alertView.tag == 2){
        if(buttonIndex == 1){
            NSString *mac = [deviceInfo objectAtIndex:1];
            RoverSqlite *sql = [[RoverSqlite alloc] init];
            if([sql deleteDeviceInfo:mac]){
                [[AwiseGlobal sharedInstance] showRemindMsg:@"设备删除成功" withTime:1.2];
                [[AwiseGlobal sharedInstance].deviceArray removeObjectAtIndex:cell.tag];
                [self.deviceTable reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedLayoutDevice" object:nil];
            }
        }
    }
}

#pragma mark --------------------------------- 删除设备
- (void)delDeviceFunction:(UIButton *)sender{
    self.tempButton = (UIButton *)sender;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除该设备吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alert.tag = 2;
    alert.delegate = self;
    [alert show];
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

#pragma mark ---------------------------------------------------- 处理单色触摸面板返回的数据
- (void)dataBackFormDevice:(Byte *)byte{
    switch (byte[2]) {
        case 0x18:{              //发送账号密码成功
            [[AwiseGlobal sharedInstance] disMissHUD];
            [[AwiseGlobal sharedInstance] showWaitingViewWithTime:@"设备正在切换网络，请切换至对应网络控制" time:2.0];
            [self.routeView removeRouteView];
        }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
