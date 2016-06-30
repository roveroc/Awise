//
//  BlueRGBController.m
//  AwiseController
//
//  Created by rover on 16/5/9.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "BlueRGBController.h"
#import "RoverSqlite.h"

@interface BlueRGBController ()

@end

@implementation BlueRGBController
@synthesize colorPicker;
@synthesize selectedColor;
@synthesize centralManager;
@synthesize connectPeripheral;
@synthesize character;
@synthesize dataArray;
@synthesize modePicker;
@synthesize modeArray;
@synthesize lightSlider;
@synthesize modeSlider;
@synthesize lightValue;
@synthesize speedValue;
@synthesize modeValue;
@synthesize onOffButton;
@synthesize PlayPauseButton;
@synthesize musicButton;
@synthesize customButton;
@synthesize offFlag;
@synthesize palyFlag;
@synthesize backScrollView;
@synthesize touchFlag;
@synthesize touchTimer;
@synthesize ipodMusicArray;
@synthesize mview;
@synthesize BLE_DeviceArray;
@synthesize deviceTable;
@synthesize selectDeviceIndex;
@synthesize isTouchPicker;
@synthesize rValue,gValue,bValue;
@synthesize cusotmView;
@synthesize scanTimer;
@synthesize tempCell;
@synthesize sql_BLEArray;
@synthesize BLE_onLineArray;
@synthesize tempArray;
@synthesize tempCount;

#pragma mark ----------------------------------------------- 返回时断开蓝牙连接
- (void)viewWillDisappear:(BOOL)animated{
    if(self.connectPeripheral != nil){
        [self.centralManager cancelPeripheralConnection:self.connectPeripheral];
    }
    [self.touchTimer invalidate];
    self.touchTimer = nil;
    [self.scanTimer invalidate];
    self.scanTimer = nil;
    [[AwiseGlobal sharedInstance] showTabBar:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bule";
    self.selectDeviceIndex = -1;
    // Do any additional setup after loading the view from its nib.
    self.speedValue = 1;
    self.lightValue = 100;
    self.modeValue  = 10;
    self.modeValue  = 1;
    self.tempCount = 0;
    //间隔取值
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(changeFlag) userInfo:nil repeats:YES];
    [self.touchTimer fire];
    
    UIBarButtonItem	*leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigatorBackImg.png"]
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(goBack)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"设备列表" style:UIBarButtonItemStyleDone target:self action:@selector(initDeviceTable)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundColor:[UIColor greenColor]];
//    [button setImage:[UIImage imageNamed:@"fastSpeed.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(goBack)forControlEvents:UIControlEventTouchUpInside];
//    [button setFrame:CGRectMake(0, 0, 53, 31)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(23, 5, 50, 20)];
//    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
//    [label setText:@"返回"];
//    label.textAlignment = NSTextAlignmentRight;
//    [label setTextColor:[UIColor blueColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [button addSubview:label];
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = barButton;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.BLE_DeviceArray = [[NSMutableArray alloc] init];
    self.centralManager = [[CBCentralManager alloc]
                           initWithDelegate:self queue:dispatch_get_main_queue()];
    self.modeArray = [[NSMutableArray alloc] initWithObjects:
                      @"红 色 输 出",
                      @"绿 色 输 出",
                      @"蓝 色 输 出",
                      @"黄 色 输 出",
                      @"紫 色 输 出",
                      @"青 色 输 出",
                      @"白 色 输 出",
                      @"三 色 跳 变",
                      @"七 色 跳 变",
                      @"三 色 渐 变",
                      @"七 色 渐 变",
                      @"红 色 频 闪",
                      @"绿 色 频 闪",
                      @"蓝 色 频 闪",
                      @"黄 色 频 闪",
                      @"紫 色 频 闪",
                      @"青 色 频 闪",
                      @"白 色 频 闪",
                      @"红 蓝 交 替 渐 变",
                      @"蓝 绿 交 替 渐 变",
                      @"红 绿 交 替 渐 变",
                      @"红 色 爆 闪",
                      @"绿 色 爆 闪",
                      @"蓝 色 爆 闪",
                      @"黄 色 爆 闪",
                      @"紫 色 爆 闪",
                      @"青 色 爆 闪",
                      @"白 色 爆 闪",
                      @"三 色 爆 闪",
                      @"七 色 爆 闪",
                      @"三 色 闪 变",
                      @"七 色 闪 变",
                      @"红 色 呼 吸 渐 变",
                      @"绿 色 呼 吸 渐 变",
                      @"蓝 色 呼 吸 渐 变",
                      @"黄 色 呼 吸 渐 变",
                      @"紫 色 呼 吸 渐 变",
                      @"青 色 呼 吸 渐 变",
                      @"白 色 呼 吸 渐 变",
                      @"三 色 呼 吸 渐 变",
    nil];
    [[AwiseGlobal sharedInstance] hideTabBar:self];
//读取iTunes中的音乐
    [self importMusicFormItunes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    //取数据库中蓝牙设备数据
    RoverSqlite *sql = [[RoverSqlite alloc] init];
    self.sql_BLEArray = [[NSMutableArray alloc] init];
    self.sql_BLEArray = [sql getAllDeviceInfomation_BLE];
    //默认取出来时全部不在线
    self.BLE_onLineArray = [[NSMutableArray alloc] init];
    for(int i=0;i<self.sql_BLEArray.count;i++){
        [self.BLE_onLineArray addObject:@"0"];      //0表示不在线
    }
    self.tempArray = [[NSMutableArray alloc] init];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    NSLog(@"did become active notification  %f ",self.backScrollView.frame.origin.x);
//    if(self.backScrollView.frame.origin.x != 0.0)
    {
        self.backScrollView.frame = CGRectMake(0, -64, SCREEN_WIDHT, SCREEN_HEIGHT+64);
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDHT, 667+64);
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"CBCentralManager             = %@",central);
//    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerRestoredStateScanOptionsKey:@(YES)}];
    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];

    
    if(self.scanTimer == nil){
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scanDevice) userInfo:nil repeats:YES];
        [self.scanTimer fire];
    }
}

#pragma mark ---------------------------------- 定时发现周围设备
- (void)scanDevice{
    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];

    
}

- (void)dissMissHUD{
    [[AwiseGlobal sharedInstance] disMissHUD];
    self.selectDeviceIndex = -1;
    [self.deviceTable reloadData];
    [[AwiseGlobal sharedInstance] showRemindMsg:@"连接失败" withTime:0.8];
}

#pragma mark ----------------------------------------------- 自定义返回按钮事件
- (void)goBack{
    if(mview == nil && self.cusotmView == nil){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.mview != nil){
        [UIView beginAnimations:@"animation" context:nil];
        //动画时长
        [UIView setAnimationDuration:0.3];
        mview.alpha = 0.0;
        //动画结束
        [UIView commitAnimations];
        [self performSelector:@selector(removeMview) withObject:nil afterDelay:0.3];
        if([self.mview.mPlayer isPlaying]){
            [self.mview.mPlayer stop];
        }
        self.mview.mPlayer.delegate = nil;
        self.mview.mPlayer = nil;
        
    }else if(self.cusotmView != nil){
        [UIView beginAnimations:@"animation" context:nil];
        //动画时长
        [UIView setAnimationDuration:0.3];
        self.cusotmView.alpha = 0.0;
        //动画结束
        [UIView commitAnimations];
        [self.cusotmView removeFromSuperview];
        self.cusotmView.delegate = nil;
        self.cusotmView = nil;
    }
}

- (void)removeMview{
    [self.view addSubview:mview];
    [mview removeFromSuperview];
    mview.delegate = nil;
    mview = nil;
}

#pragma mark ----------------------------------------------- 扫描周围可用的蓝牙设备
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@" 搜索到的设备 = %@",peripheral);
    if([advertisementData[@"kCBAdvDataLocalName"]  isEqualToString:BLE_SERVICE_NAME])
    {
        int k=0;
        for(k=0;k<self.tempArray.count;k++){
            NSString *temp = [self.tempArray objectAtIndex:k];
            if([temp isEqualToString:[peripheral.identifier UUIDString]]){
                k = -1;
                break;
            }
        }
        if(k == self.tempArray.count || self.tempArray.count == 0){
            [self.tempArray addObject:[peripheral.identifier UUIDString]];
        }
        //添加默认连接的
        if(self.connectPeripheral != nil){
            NSString *s = [self.connectPeripheral.identifier UUIDString];
            if(![self.tempArray containsObject:s]){
                [self.tempArray addObject:s];
            }
        }
        
        NSLog(@"CBPeripheral        = %@",peripheral.identifier);
        
        
        
        BOOL flag = NO;
        for(int i=0;i<self.BLE_DeviceArray.count;i++){
            CBPeripheral *temp = [self.BLE_DeviceArray objectAtIndex:i];
            if([peripheral.identifier isEqual:temp.identifier]){
                flag = YES;
            }
        }
        if(flag == NO){
            [self.BLE_DeviceArray addObject:peripheral];
        }
        int j=0;
        for(j=0;j<self.sql_BLEArray.count;j++){
            NSMutableArray *temp = [self.sql_BLEArray objectAtIndex:j];
            if([temp[1] isEqualToString:[peripheral.identifier UUIDString]]){
                [self.BLE_onLineArray replaceObjectAtIndex:j withObject:@"1"];
                j = -1;
                break;
            }
        }
        if(j == self.sql_BLEArray.count || self.sql_BLEArray.count == 0){
            NSMutableArray *info = [[NSMutableArray alloc] initWithObjects:BLE_SERVICE_NAME,[peripheral.identifier UUIDString],@"Awise_BLE",@"Awise_BLE",@"Awise_BLE",@"Awise_BLE",@"Awise_BLE", nil];
            [self.sql_BLEArray addObject:info];
            [self.BLE_onLineArray addObject:@"1"];
            RoverSqlite *sql = [[RoverSqlite alloc] init];
            [sql insertDeivceInfo:info];
            
        }
        
        //如果连续两次间隔没有扫描到设备，说明不在线
        self.tempCount++;
        if(self.tempCount == self.sql_BLEArray.count*2){
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchFinish) object:nil];
            [[AwiseGlobal sharedInstance] disMissHUD];
            self.tempCount = 0;
            for(int i=0;i<self.sql_BLEArray.count;i++){
                NSString *ide = [[self.sql_BLEArray objectAtIndex:i] objectAtIndex:1];
                
                NSLog(@"数据库中的记录  的ID    = %@",ide);
                
                BOOL flag = NO;
                for(int n=0;n<self.tempArray.count;n++){
                    NSString *str = [self.tempArray objectAtIndex:n];
                    
                    NSLog(@"最新搜索到  的ID    = %@",str);
                    
                    if([ide isEqualToString:str]){
                        NSLog(@"扫描到匹配  在线！");
                        flag = YES;
                        break;
                    }
                }
                if(flag == NO){
                    NSLog(@"不在线！NO ");
                    [self.BLE_onLineArray replaceObjectAtIndex:i withObject:@"0"];
                }
            }
            [self.deviceTable reloadData];
            [self.tempArray removeAllObjects];
        }
    }
}

#pragma mark ------------------------------------------------ 连接设备成功后调用
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接外设成功-----> %@", peripheral);
    [peripheral setDelegate:self];          //查找服务
    [peripheral discoverServices:nil];      //可以指定服务号（数组）
}

#pragma mark ------------------------------------------------ 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"设备断开连接");
//    [[AwiseGlobal sharedInstance] showRemindMsg:@"断开连接" withTime:1.0];
    if(self.selectDeviceIndex > 0){
        [self.BLE_onLineArray replaceObjectAtIndex:self.selectDeviceIndex withObject:@"0"];
    }
    self.selectDeviceIndex = -1;
    if(self.connectPeripheral != nil){
        [self.centralManager cancelPeripheralConnection:self.connectPeripheral];
    }
    [self.deviceTable reloadData];
}

#pragma mark ------------------------------------------------ 设备连接成功后，发现在设备上可用的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dissMissHUD) object:nil];
    [[AwiseGlobal sharedInstance] disMissHUD];
    [[AwiseGlobal sharedInstance] showRemindMsg:@"连接成功" withTime:0.8];
    if([self.scanTimer isValid]){
        [self.scanTimer invalidate];
    }
    if(self.selectDeviceIndex > 0){
        NSMutableArray *info = [self.sql_BLEArray objectAtIndex:self.selectDeviceIndex];
        self.title = [info objectAtIndex:0];
    }
    if (error){
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services){
        NSLog(@"发现外设的服务号为 ------> %@",service.UUID);
        //发现服务
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]]){
            [self.connectPeripheral discoverCharacteristics:nil forService:service];     //读取服务上的特征
            break;
        }
    } 
}

#pragma mark ------------------------------------------------ 发现服务成功后，读取服务上面的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error){
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics){
        NSLog(@"服务号上对应的特征为------> %@",characteristic);
        //发现特征
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFFA"]]) {
            self.character = characteristic;
            self.connectPeripheral.delegate = self;
            [self.connectPeripheral setNotifyValue:YES forCharacteristic:self.character];
            [[AwiseGlobal sharedInstance] disMissHUD];
            if(self.deviceTable != nil){
                [UIView beginAnimations:@"animation" context:nil];
                //动画时长
                [UIView setAnimationDuration:0.2];
                self.deviceTable.alpha = 0.0;
                //动画结束
                [UIView commitAnimations];
            }
            //读取连接设备的状态值
            Byte by[4];
            by[0] = 4;
            by[1] = 4;
            by[2] = 0;
            by[3] = 0;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
//            [self performSelector:@selector(readDeviceValue) withObject:nil afterDelay:1.0];
            break;
        }
    }
}

- (void)readDeviceValue{
    [self.connectPeripheral setNotifyValue:YES forCharacteristic:self.character];
}

#pragma mark ------------------------------------------------ 从连接的设备上收到的数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error){
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    NSLog(@"收到的数据----------------------------> %@",characteristic.value);
}

- (void)viewWillAppear:(BOOL)animated{
    
}

#pragma mark ------------------------------------------------ 布局界面
- (void)viewWillLayoutSubviews{
    if(colorPicker != nil)
        return;
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT)];
    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDHT, 667);
    [self.view addSubview:self.backScrollView];
    
    colorPicker = [[KZColorPicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT)];
//    colorPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    colorPicker.selectedColor = self.selectedColor;
    colorPicker.oldColor = self.selectedColor;
    [colorPicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:colorPicker];
    [self.backScrollView addSubview:colorPicker];
    
    self.modePicker = [[UIPickerView alloc] init];
    self.modePicker.dataSource = self;
    self.modePicker.delegate = self;
    if(iPhone6P){
        self.modePicker.frame = CGRectMake(0, 390, SCREEN_WIDHT, 160);
    }
    else{
        self.modePicker.frame = CGRectMake(0, 390, SCREEN_WIDHT, 130);
    }
    if(iPhone4 || iPhone5){
        self.backScrollView.scrollEnabled = YES;
    }
    else{
        self.backScrollView.scrollEnabled = NO;
    }
    [self.backScrollView addSubview:self.modePicker];
//开关、暂停播放
    self.offFlag = NO;
    self.palyFlag = NO;
    
    self.onOffButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    self.PlayPauseButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.musicButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    self.customButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.onOffButton     setBackgroundImage:[UIImage imageNamed:@"off.png"]
                                forState:UIControlStateNormal];
    [self.PlayPauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                forState:UIControlStateNormal];
//    if(iPhone6)
    {
        self.PlayPauseButton.frame = CGRectMake(10, 78, 60, 60);
        self.onOffButton.frame     = CGRectMake(SCREEN_WIDHT-10-60, 78, 60, 60);
        self.musicButton.frame     = CGRectMake(SCREEN_WIDHT-10-60, 265, 60, 60);
        self.customButton.frame    = CGRectMake(10, 265, 60, 60);
        self.musicButton.layer.cornerRadius = self.musicButton.frame.size.width/2;
        self.musicButton.layer.masksToBounds = true;
        self.customButton.layer.cornerRadius = self.customButton.frame.size.width/2;
        self.customButton.layer.masksToBounds = true;
        self.musicButton.backgroundColor = [UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.];
        self.customButton.backgroundColor = [UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.];
        [self.musicButton setTitle:@"音乐" forState:UIControlStateNormal];
        [self.customButton setTitle:@"自定义" forState:UIControlStateNormal];
        self.musicButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
        self.customButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    }
    [self.PlayPauseButton addTarget:self
                       action:@selector(PlayPauseMode)
             forControlEvents:UIControlEventTouchUpInside];
    [self.onOffButton addTarget:self
                       action:@selector(onOffLight)
             forControlEvents:UIControlEventTouchUpInside];
    [self.musicButton addTarget:self
                         action:@selector(showMusicView)
               forControlEvents:UIControlEventTouchUpInside];
    [self.customButton addTarget:self
                         action:@selector(showCustomView)
               forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:self.onOffButton];
    [self.backScrollView addSubview:self.PlayPauseButton];
//    [self.backScrollView addSubview:self.musicButton];
    [self.backScrollView addSubview:self.customButton];
    
//亮度值滑条
    self.lightSlider = [[ASValueTrackingSlider alloc] init];
    self.lightSlider.minimumValue = 0;
    self.lightSlider.maximumValue = 100;
    self.lightSlider.popUpViewCornerRadius = 12.0;
    [self.lightSlider setMaxFractionDigitsDisplayed:0];
    self.lightSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.lightSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.lightSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    self.lightSlider.minimumValueImage = [UIImage imageNamed:@"samllLight.png"];
    self.lightSlider.maximumValueImage = [UIImage imageNamed:@"bigLight.png"];
//速度值滑条
    self.modeSlider = [[ASValueTrackingSlider alloc] init];
    self.modeSlider.minimumValue = 0;
    self.modeSlider.maximumValue = 20;
    self.modeSlider.value = 0;
    self.modeSlider.popUpViewCornerRadius = 12.0;
    [self.modeSlider setMaxFractionDigitsDisplayed:0];
    self.modeSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.modeSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.modeSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    self.modeSlider.minimumValueImage = [UIImage imageNamed:@"lowSpeed.png"];
    self.modeSlider.maximumValueImage = [UIImage imageNamed:@"fastSpeed.png"];
    if(iPhone6P){
        self.lightSlider.frame = CGRectMake(20, 400+130+30, SCREEN_WIDHT-40, 20);
        self.modeSlider.frame  = CGRectMake(20, 400+130+40+15+30, SCREEN_WIDHT-40, 20);
    }
    else{
        self.lightSlider.frame = CGRectMake(20, 400+130, SCREEN_WIDHT-40, 20);
        self.modeSlider.frame  = CGRectMake(20, 400+130+40+5, SCREEN_WIDHT-40, 20);
    }
    [self.backScrollView addSubview:self.lightSlider];
    [self.backScrollView addSubview:self.modeSlider];
    [self.backScrollView bringSubviewToFront:self.lightSlider];
    [self.backScrollView bringSubviewToFront:self.modeSlider];
    [self.lightSlider addTarget:self action:@selector(lightSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.modeSlider addTarget:self action:@selector(modeSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self initDeviceTable];
    [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:@"搜索设备中"];
    [self performSelector:@selector(searchFinish) withObject:nil afterDelay:5.5];
}

- (void)searchFinish{
    [[AwiseGlobal sharedInstance] disMissHUD];
    [[AwiseGlobal sharedInstance] showRemindMsg:@"无设备" withTime:0.8];
}

#pragma mark ----------------------------------- 发送音乐播放时的值
- (void)sendMusicVoiceData:(int)value{
    Byte by[4];
    by[0] = 2;
    if(self.modeValue > 7){
        by[1] = self.modeValue;
        by[2] = self.lightValue;
        by[3] = 10+value/(100/20);
    }else{
        by[1] = self.modeValue;
        by[2] = value;
        by[3] = self.speedValue;
    }
    NSData *da = [[NSData alloc] initWithBytes:by length:4];
    [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
}

#pragma mark ----------------------------------- 关闭
- (void)PlayPauseMode{
    if(self.character != nil){
        if(self.palyFlag == NO){
            self.palyFlag = YES;
            Byte by[4];
            by[0] = 3;
            by[1] = 3;
            by[2] = 0;
            by[3] = 0;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
            [self.PlayPauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                            forState:UIControlStateNormal];
        }else{
            self.palyFlag = NO;
            Byte by[4];
            by[0] = 3;
            by[1] = 2;
            by[2] = 0;
            by[3] = 0;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
            [self.PlayPauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                            forState:UIControlStateNormal];
        }
    }
}



#pragma mark ----------------------------------- 跳到自定义颜色界面
- (void)showCustomView{
    self.cusotmView = [[BlueRGBCutomView alloc] init];
    self.cusotmView.frame = self.view.bounds;
    self.cusotmView.delegate = self;
    [self.view addSubview:self.cusotmView];
}

#pragma mark ----------------------------------- 跳到音乐播放界面
- (void)showMusicView{
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"MusicView" owner:nil options:nil];
    mview = [nibView objectAtIndex:0];
    mview.delegate = self;
    mview.frame = self.view.frame;
    mview.alpha = 0.0;
    mview.musicArray = self.ipodMusicArray;
    [UIView beginAnimations:@"animation" context:nil];
    //动画时长
    [UIView setAnimationDuration:0.3];
    mview.alpha = 1.0;
    //动画结束
    [UIView commitAnimations];
    [self.view addSubview:mview];
    
}

#pragma mark ----------------------------------- 导入iTunes中的音乐
- (void)importMusicFormItunes{
    MPMediaQuery *allMp3 = [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *albumNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
    [allMp3 addFilterPredicate:albumNamePredicate];
    self.ipodMusicArray = [[NSMutableArray alloc] init];
    NSArray *musicArr = [allMp3 items];
    for (MPMediaItem *song in musicArr) {
        NSString *songTitle = song.title;
        NSLog (@"%@, %@, %@", songTitle, song.assetURL,song.artist);
        NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:songTitle,song.assetURL,song.artist, nil];
        [self.ipodMusicArray addObject:temp];
    }
}

#pragma mark ----------------------------------- 打开
- (void)onOffLight{
    if(self.character != nil){
        if(self.offFlag == NO){
            self.offFlag = YES;
            Byte by[4];
            by[0] = 4;
            by[1] = 3;
            by[2] = 0;
            by[3] = 0;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
            [self.onOffButton setBackgroundImage:[UIImage imageNamed:@"off.png"]
                                        forState:UIControlStateNormal];
        }else{
            self.offFlag = NO;
            Byte by[4];
            by[0] = 4;
            by[1] = 2;
            by[2] = 0;
            by[3] = 0;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
            [self.onOffButton setBackgroundImage:[UIImage imageNamed:@"on.png"]
                                        forState:UIControlStateNormal];
        }
    }
}

#pragma mark ----------------------------------- 亮度值改变
- (void)lightSliderValueChange:(UISlider *)slider{
    if(self.touchFlag == YES){
        self.touchFlag = NO;
        self.lightValue = (int)slider.value;
        [self sendModeData];
    }
}

#pragma mark ----------------------------------- 模式速度改变
- (void)modeSliderValueChange:(UISlider *)slider{
    if(self.touchFlag == YES){
        self.touchFlag = NO;
        self.speedValue = 20-(int)slider.value;
        [self sendModeData];
    }
}

#pragma mark ----------------------------------- 多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

#pragma mark ----------------------------------- 每组多少个
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.modeArray.count;
}

#pragma mark ----------------------------------- 选中某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.isTouchPicker = NO;
    self.modeValue = (int)row+1;
    [self sendModeData];
    if((int)row > 6){
        self.PlayPauseButton.enabled = YES;
        self.modeSlider.enabled = YES;
    }
    else{
        self.PlayPauseButton.enabled = NO;
        self.modeSlider.enabled = NO;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}

#pragma mark ----------------------------------- 每行标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.modeArray[row];
}

#pragma mark ----------------------------------- 颜色改变
- (void)pickerChanged:(KZColorPicker *)cp{
    self.isTouchPicker = YES;
    self.PlayPauseButton.enabled = NO;
    self.modeSlider.enabled = NO;
    self.selectedColor = cp.selectedColor;
    if(self.character != nil){
        if(self.touchFlag == YES){
            self.touchFlag = NO;
            NSString *RGBValue = [NSString stringWithFormat:@"%@",self.selectedColor];
            NSArray *arr = [RGBValue componentsSeparatedByString:@" "];
            self.rValue = [[arr objectAtIndex:1] floatValue]*100;
            self.gValue = [[arr objectAtIndex:2] floatValue]*100;
            self.bValue = [[arr objectAtIndex:3] floatValue]*100;
            Byte by[4];
            by[0] = 1;
            by[1] = self.rValue;
            by[2] = self.gValue;
            by[3] = self.bValue;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
            [self.connectPeripheral setNotifyValue:YES forCharacteristic:self.character];
        }
    }
}

//by rover 用于间隔取值
- (void)changeFlag{
    self.touchFlag = YES;
}

#pragma mark ----------------------------------- 发送模式数据
- (void)sendModeData{
    if(self.character != nil){
        if(self.isTouchPicker == NO){
            Byte by[4];
            by[0] = 2;
            by[1] = self.modeValue;
            by[2] = self.lightValue;
            by[3] = self.speedValue;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
        }else{
            Byte by[4];
            by[0] = 1;
            by[1] = (self.rValue/100.)*self.lightValue;
            by[2] = (self.gValue/100.)*self.lightValue;
            by[3] = (self.bValue/100.)*self.lightValue;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    NSLog(@"characteristic  characteristic  通知返回的值  = %@",characteristic);
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***********************************************************************/
/***************************搜索到的设备列表*******************************/
/***********************************************************************/
#pragma mark ----------------------------------------------- 显示设备列表，切换设备
- (void)initDeviceTable{
    if(self.deviceTable == nil){
        self.deviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 58, SCREEN_WIDHT, SCREEN_HEIGHT-58)];
        self.deviceTable.delegate   = self;
        self.deviceTable.dataSource = self;
//        self.deviceTable.alpha = 0.0;
//        [UIView beginAnimations:@"animation" context:nil];
//        //动画时长
//        [UIView setAnimationDuration:0.2];
//        self.deviceTable.alpha = 1.0;
//        //动画结束
//        [UIView commitAnimations];
        [self.view addSubview:self.deviceTable];
    }else{
        if(self.deviceTable.alpha == 0.0){
            [UIView beginAnimations:@"animation" context:nil];
            //动画时长
            [UIView setAnimationDuration:0.2];
            self.deviceTable.alpha = 1.0;
            //动画结束
            [UIView commitAnimations];
            [self.view bringSubviewToFront:self.deviceTable];
            
            if([self.scanTimer isValid]){
                [self.scanTimer invalidate];
            }
            self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scanDevice) userInfo:nil repeats:YES];
            [self.scanTimer fire];
        }else{
            [UIView beginAnimations:@"animation" context:nil];
            //动画时长
            [UIView setAnimationDuration:0.2];
            self.deviceTable.alpha = 0.0;
            //动画结束
            [UIView commitAnimations];
            if([self.scanTimer isValid]){
                [self.scanTimer invalidate];
            }
        }
    }
}

#pragma mark ------------------------------------------------ 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark ------------------------------------------------ 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sql_BLEArray.count;
}

#pragma mark ------------------------------------------------ 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.;
}

#pragma mark ------------------------------------------------ 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectDeviceIndex == indexPath.row){
        [self initDeviceTable];
        return ;
    }
    self.selectDeviceIndex = (int)indexPath.row;
    NSString *uuid = [self.sql_BLEArray objectAtIndex:indexPath.row][1];
    CBPeripheral *heral;
    BOOL flag = NO;
    for(int i=0;i<self.BLE_DeviceArray.count;i++){      //可能导致控制对象不准确
        heral = [self.BLE_DeviceArray objectAtIndex:i];
        if([[heral.identifier UUIDString] isEqualToString:uuid]){
            flag = YES;
            break;
        }
    }
    if(flag == YES){
        if(self.connectPeripheral != nil){
            self.connectPeripheral.delegate = nil;
            [self.centralManager cancelPeripheralConnection:self.connectPeripheral];
        }
        self.connectPeripheral = heral;
        [self performSelector:@selector(reConnectDevice) withObject:nil afterDelay:0.5];
        [self performSelector:@selector(dissMissHUD) withObject:nil afterDelay:4.0];
    }else{
        if(self.connectPeripheral != nil){
            [self.centralManager cancelPeripheralConnection:self.connectPeripheral];
        }
        [[AwiseGlobal sharedInstance] showRemindMsg:@"设备不在线" withTime:0.8];
        self.selectDeviceIndex = -1;
        [self.deviceTable reloadData];
    }
}

- (void)reConnectDevice{
    [self.centralManager connectPeripheral:self.connectPeripheral
                                   options:nil];
    [[AwiseGlobal sharedInstance] showWaitingViewWithMsg:@"链接设备中..."];
    [self.deviceTable reloadData];
}

#pragma mark ------------------------------------------------ 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
        //重命名
        UIButton *namebtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 80, 30)];
        [namebtn setTitle:@"重命名" forState:UIControlStateNormal];
        namebtn.layer.cornerRadius = 5;
        namebtn.layer.masksToBounds = true;
        namebtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [namebtn addTarget:self action:@selector(changeDeviceName:) forControlEvents:UIControlEventTouchUpInside];
        [namebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [namebtn setBackgroundColor:[UIColor colorWithRed:0x71/255. green:0xc6/255. blue:0x71/255. alpha:1.]];
        [cell addSubview:namebtn];
        
    }
    if(self.selectDeviceIndex == indexPath.row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if([[self.BLE_onLineArray objectAtIndex:indexPath.row] intValue] == 0){
        cell.imageView.image=[UIImage imageNamed:@"turnOffLight@3x.png"];
    }else{
        cell.imageView.image=[UIImage imageNamed:@"turnOnLight@3x.png"];
    }
    cell.tag = indexPath.row;
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSMutableArray *arr = [self.sql_BLEArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [arr objectAtIndex:0];;
    
    return cell;
}

#pragma mark ------------------------------------------------ 重命名设备名字
- (void)changeDeviceName:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell;
    if([[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        cell = (UITableViewCell *)btn.superview;
    }
    else{
        cell = (UITableViewCell *)btn.superview.superview.superview;
    }
    self.tempCell = cell;
    NSMutableArray *deviceInfo = [self.sql_BLEArray objectAtIndex:cell.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[AwiseGlobal sharedInstance] DPLocalizedString:@"manager_newName"] delegate:nil cancelButtonTitle:[[AwiseGlobal sharedInstance] DPLocalizedString:@"cancel"] otherButtonTitles:[[AwiseGlobal sharedInstance] DPLocalizedString:@"ok"], nil];
    alert.tag = 1;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *text = [alert textFieldAtIndex:0];
    text.placeholder = [deviceInfo objectAtIndex:0];
    alert.delegate = self;
    [alert show];
}

#pragma mark --------------------------------- 弹出框代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSMutableArray *deviceInfo = [self.sql_BLEArray objectAtIndex:self.tempCell.tag];
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
                self.sql_BLEArray = [sql getAllDeviceInfomation_BLE];
                [self.deviceTable reloadData];
            }
        }
    }
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

#pragma mark ------------------------------------------------ 自定义模式的两个代理
- (void)rgbColorChange:(int)r g:(int)g b:(int)b{
    if(self.touchFlag == NO)
        return;
    self.touchFlag = NO;
    NSLog(@"r === %d,g === %d b === %d",r,g,b);
    if(self.character != nil){
        Byte by[4];
        by[0] = 1;
        by[1] = r;
        by[2] = g;
        by[3] = b;
        NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
    }
}

- (void)customSceneValue:(int)r g:(int)g b:(int)b{
    if(self.touchFlag == NO)
        return;
    self.touchFlag = NO;
    if(self.character != nil){
        Byte by[4];
        by[0] = 1;
        by[1] = r;
        by[2] = g;
        by[3] = b;
        NSData *da = [[NSData alloc] initWithBytes:by length:4];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
        });
    }
}


@end
