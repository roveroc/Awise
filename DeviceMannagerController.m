//
//  DeviceMannagerController.m
//  FishDemo
//
//  Created by rover on 16/3/5.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "DeviceMannagerController.h"

@interface DeviceMannagerController ()

@end

@implementation DeviceMannagerController
@synthesize nameStr;
@synthesize ssidStr;
@synthesize pwdStr;
@synthesize attest;
@synthesize encrypt;

- (void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark -------------------------- 程序回到前台时调用
- (void) appWillEnterForegroundNotification{
    if([[AwiseGlobal sharedInstance].wifiSSID rangeOfString:WIFISSID].location != NSNotFound){
        self.navigationItem.rightBarButtonItem = nil;
        self.attest = 0x01;
        self.encrypt = 0x01;
        [self.wpapskBtn     setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.wpa2pskBtn    setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.tkipBtn       setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.aesBtn        setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else{
        [self searchMode];
    }
}

#pragma mark - 搜索模式下界面做相应的改变
- (void)searchMode{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(searchDevice)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.deviceNameFeild.hidden = YES;
    self.ssidFeild.hidden = YES;
    self.pwdFeild.hidden = YES;
    self.sendBtn.hidden = YES;
    self.ssidLabel.hidden = YES;
    self.pwdLabel.hidden = YES;
    self.attestLabel.hidden = YES;
    self.encryptLabel.hidden = YES;
    self.wpapskBtn.hidden = YES;
    self.wpa2pskBtn.hidden = YES;
    self.tkipBtn.hidden = YES;
    self.aesBtn.hidden = YES;
}

#pragma mark -------------------------- 移除监听
-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Device";
    [[AwiseGlobal sharedInstance] hideTabBar:self];
    
    self.deviceTable.delegate = self;
    self.deviceTable.dataSource = self;
    self.deviceNameFeild.delegate = self;
    self.deviceNameFeild.returnKeyType = UIReturnKeyDone;
    self.ssidFeild.delegate = self;
    self.ssidFeild.returnKeyType = UIReturnKeyDone;
    self.pwdFeild.delegate = self;
    self.pwdFeild.returnKeyType = UIReturnKeyDone;
    
    if([[AwiseGlobal sharedInstance].wifiSSID rangeOfString:WIFISSID].location != NSNotFound){
        self.attest = 0x01;
        self.encrypt = 0x01;
        [self.wpapskBtn     setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.wpa2pskBtn    setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.tkipBtn       setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.aesBtn        setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else{
        [self searchMode];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDeviceTable) name:@"FindNewDevice" object:nil];
}

#pragma mark -------------------------- 搜索到设备后接收到通知刷新列表
- (void)reloadDeviceTable{
    NSLog(@"Global.deviceSSIDArray = %@",[AwiseGlobal sharedInstance].deviceSSIDArray);
    [self.deviceTable reloadData];
}

#pragma mark -------------------------- 获取数据存储路径
- (NSString *)getPlistPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"deviceInfo"];
    return path;
}

#pragma mark -------------------------- 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.view.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT/2-150);
    
}

#pragma mark -------------------------- 点击Done完成编辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.view.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT/2+(50/2));
    if(textField.text.length == 0){
        
    }
    else{
        
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [AwiseGlobal sharedInstance].deviceSSIDArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * showUserInfoCellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:showUserInfoCellIdentifier];
    }
    if([[AwiseGlobal sharedInstance].wifiSSID rangeOfString:WIFISSID].location != NSNotFound){
        cell.textLabel.text = [AwiseGlobal sharedInstance].wifiSSID;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        NSString *mac = [[AwiseGlobal sharedInstance].deviceSSIDArray objectAtIndex:indexPath.row];
        if([mac rangeOfString:@"Awise-"].location == NSNotFound){
            cell.textLabel.text = [NSString stringWithFormat:@"Awise-%@",[[AwiseGlobal sharedInstance].deviceSSIDArray objectAtIndex:indexPath.row]];
        }
        else{
            cell.textLabel.text = [[AwiseGlobal sharedInstance].deviceSSIDArray objectAtIndex:indexPath.row];
        }
        if([AwiseGlobal sharedInstance].deviceSSIDArray.count == 1){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

#pragma mark -------------------------- 当有多个设备时，点击切换控制的设备，切换MAC
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([AwiseGlobal sharedInstance].deviceSSIDArray.count == 1){
        [AwiseUserDefault sharedInstance].activeMAC = [[AwiseGlobal sharedInstance].deviceSSIDArray objectAtIndex:indexPath.row];
        [AwiseGlobal sharedInstance].currentControllDevice = [[AwiseGlobal sharedInstance].deviceSSIDArray objectAtIndex:indexPath.row];
    }
    else{
        self.ssidFeild.enabled = YES;
        self.pwdFeild.enabled = YES;
        self.sendBtn.enabled = YES;
    }
}


#pragma mark - 搜索到设备后，如果设备大于一个，将设备MAC号写入文件
- (void)writeDeviceToFile{
    if([AwiseGlobal sharedInstance].deviceSSIDArray.count > 0){
        [[AwiseGlobal sharedInstance].deviceSSIDArray writeToFile:[self getPlistPath] atomically:YES];
    }
}

#pragma mark -------------------------- 搜索设备
- (void)searchDevice{
    [[AwiseGlobal sharedInstance].deviceSSIDArray removeAllObjects];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:5.0];
    
    
    [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:3.0];
    [self performSelector:@selector(writeDeviceToFile) withObject:nil afterDelay:4.0]; //当搜索到的设备写入到文件
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x19;
    b3[3] = 0x00;
    b3[4] = 0x00;
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
//    [[AwiseGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -------------------------- 认证方式
- (IBAction)wpapskBtnClicked:(id)sender {
    self.attest = 0x01;
    [self.wpapskBtn     setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wpa2pskBtn    setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
}

- (IBAction)wpa2pskBtnClicked:(id)sender {
    self.attest = 0x02;
    [self.wpapskBtn     setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
    [self.wpa2pskBtn    setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark -------------------------- 加密算法
- (IBAction)tkipBtnClicked:(id)sender {
    self.encrypt = 0x02;
    [self.tkipBtn     setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.aesBtn      setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (IBAction)aesBtnClicked:(id)sender {
    self.encrypt = 0x01;
    [self.tkipBtn     setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.aesBtn      setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark -------------------------- 发送WIFI账号密码  <分两条指令发送>
- (IBAction)sendBtnClicked:(id)sender {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:3.0];
    if(self.ssidFeild.text.length < 1){
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"提示" message:@"Wifi账号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [AwiseGlobal sharedInstance].isSuccess = NO;
        [self performSelector:@selector(confirmSSIDSuccess) withObject:nil afterDelay:1.0];
        Byte b3[64];
        for(int k=0;k<64;k++){
            b3[k] = 0x00;
        }
        b3[0] = 0x55;
        b3[1] = 0xAA;
        b3[2] = 0x18;
        b3[3] = 0x01;
        b3[4] = 0x00;
        
        NSString * ssid = self.ssidFeild.text;//@"AwiseTechnology";
        NSLog(@"加入路由器的 账号 为：---> %@",self.ssidFeild.text);
        NSData * ssidData = [ssid dataUsingEncoding:NSASCIIStringEncoding];
        Byte *ssidBtye = (Byte *)[ssidData bytes];
        
        for(int i=0;i<ssidData.length ;i++){
            b3[i+5] = ssidBtye[i];
        }
        b3[37] = self.attest;
        b3[38] = self.encrypt;
        b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
        NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
//        [[AwiseGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
    }
}

#pragma mark -------------------------- 发送账号成功后发送密码
- (void)confirmSSIDSuccess{
    [AwiseGlobal sharedInstance].isSuccess = NO;
    [self performSelector:@selector(confirmPASSWORDSuccess) withObject:nil afterDelay:2.0];
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x18;
    b3[3] = 0x02;
    b3[4] = 0x00;
    
    if(self.pwdFeild.text.length > 0){
        
    }
    NSString * password = self.pwdFeild.text;//@"Awise2015@";
    NSLog(@"加入路由器的 密码 为：---> %@",self.pwdFeild.text);
    NSData * passwordData = [password dataUsingEncoding:NSASCIIStringEncoding];
    Byte *ssidBtye = (Byte *)[passwordData bytes];
    
    for(int i=0;i<passwordData.length ;i++){
        b3[i+5] = ssidBtye[i];
    }
    b3[63] = [[AwiseGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
//    [[AwiseGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
    [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:3.0];
}

#pragma mark - 搜索完设备后重新刷新列表
- (void)reloadTableData{
    [self.deviceTable reloadData];
}

#pragma mark -------------------------- 发送账号密码成功,刷新列表提示用户切换路由SSID，搜索设备
- (void)confirmPASSWORDSuccess{
    if([AwiseGlobal sharedInstance].isSuccess == YES){
        NSLog(@"WiFi账号密码发送成功");
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Please switch router search device";
        [self.hud hide:YES afterDelay:DISMISS_TIME];
        
        [[AwiseGlobal sharedInstance].deviceSSIDArray removeAllObjects];
        [self.deviceTable reloadData];
        [self searchMode];
    }
}

#pragma mark -------------------------- 输入账号密码时移动界面
- (IBAction)editSSIDFun:(id)sender {
    [self.backGroundView setCenter:CGPointMake(160, 150)];
}

- (IBAction)editPWDFun:(id)sender {
    [self.backGroundView setCenter:CGPointMake(160, 150)];
}
@end
