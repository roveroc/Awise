//
//  BlueRGBController.m
//  AwiseController
//
//  Created by rover on 16/5/9.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "BlueRGBController.h"

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
@synthesize offFlag;
@synthesize palyFlag;
@synthesize backScrollView;

#pragma mark ----------------------------------------------- 返回时断开蓝牙连接
- (void)viewWillDisappear:(BOOL)animated{
    if(self.connectPeripheral != nil){
        [self.centralManager cancelPeripheralConnection:self.connectPeripheral];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.speedValue = 100;
    self.lightValue = 100;
    self.modeValue  = 10;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.centralManager = [[CBCentralManager alloc]
                           initWithDelegate:self queue:dispatch_get_main_queue()];
    self.modeArray = [[NSMutableArray alloc] initWithObjects:
                      @"黑 色 输 出",
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
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"CBCentralManager             = %@",central);
    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerRestoredStateScanOptionsKey:@(YES)}];
}

#pragma mark ----------------------------------------------- 扫描周围可用的蓝牙设备
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"central             = %@",central);
    NSLog(@"CBPeripheral        = %@",peripheral);
    NSLog(@"advertisementData   = %@",advertisementData);
    NSLog(@"RSSI RSSI           = %@",RSSI);
    
//    if([peripheral.name  isEqualToString:BLE_SERVICE_NAME])
    if([advertisementData[@"kCBAdvDataLocalName"]  isEqualToString:BLE_SERVICE_NAME])
    {
        self.connectPeripheral = peripheral;
        self.connectPeripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral
                                       options:nil];
    }
}

#pragma mark ------------------------------------------------ 连接设备成功后调用
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接外设成功-----> %@", peripheral);
    [peripheral setDelegate:self];          //查找服务
    [peripheral discoverServices:nil];      //可以指定服务号（数组）
}

#pragma mark ------------------------------------------------ 设备连接成功后，发现在设备上可用的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error){
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services){
        NSLog(@"发现外设的服务号为------> %@",service.UUID);
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
            [self.connectPeripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

#pragma mark ------------------------------------------------ 从连接的设备上收到的数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error){
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    NSLog(@"收到的数据----------------------------> %@",characteristic.value);
}

#pragma mark ------------------------------------------------ 设备断开连接时调用
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"设备断开连接");
}

#pragma mark ------------------------------------------------ 布局界面
- (void)viewWillLayoutSubviews{
    if(colorPicker != nil)
        return;
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT)];
    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDHT, 667);
    [self.view addSubview:self.backScrollView];
    
    colorPicker = [[KZColorPicker alloc] initWithFrame:self.view.bounds];
    colorPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
    [self.backScrollView addSubview:self.modePicker];
//开关、暂停播放
    self.offFlag = NO;
    self.palyFlag = NO;
    
    self.onOffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.PlayPauseButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.onOffButton setBackgroundImage:[UIImage imageNamed:@"btnBackimg.png"]
                              forState:UIControlStateNormal];
    [self.PlayPauseButton setBackgroundImage:[UIImage imageNamed:@"btnBackimg.png"]
                              forState:UIControlStateNormal];
    [self.onOffButton setTitle:@"开"  forState:UIControlStateNormal];
    [self.PlayPauseButton setTitle:@"播放" forState:UIControlStateNormal];
//    if(iPhone6)
    {
        self.PlayPauseButton.frame = CGRectMake(10, 78, 60, 60);
        self.onOffButton.frame = CGRectMake(SCREEN_WIDHT-10-60, 78, 60, 60);
    }
    [self.PlayPauseButton addTarget:self
                       action:@selector(PlayPauseMode)
             forControlEvents:UIControlEventTouchUpInside];
    [self.onOffButton addTarget:self
                       action:@selector(onOffLight)
             forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:self.onOffButton];
    [self.backScrollView addSubview:self.PlayPauseButton];
    
//亮度值滑条
    self.lightSlider = [[ASValueTrackingSlider alloc] init];
    self.lightSlider.minimumValue = 0;
    self.lightSlider.maximumValue = 100;
    self.lightSlider.popUpViewCornerRadius = 12.0;
    [self.lightSlider setMaxFractionDigitsDisplayed:0];
    self.lightSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.lightSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.lightSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    self.lightSlider.minimumValueImage = [UIImage imageNamed:@"single.png"];
    self.lightSlider.maximumValueImage = [UIImage imageNamed:@"single.png"];
//速度值滑条
    self.modeSlider  = [[ASValueTrackingSlider alloc] init];
    self.modeSlider.minimumValue = 0;
    self.modeSlider.maximumValue = 20;
    self.modeSlider.popUpViewCornerRadius = 12.0;
    [self.modeSlider setMaxFractionDigitsDisplayed:0];
    self.modeSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.modeSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.modeSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    self.modeSlider.minimumValueImage = [UIImage imageNamed:@"single.png"];
    self.modeSlider.maximumValueImage = [UIImage imageNamed:@"single.png"];
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
            [self.PlayPauseButton setTitle:@"暂停" forState:UIControlStateNormal];
        }else{
            self.palyFlag = NO;
            Byte by[4];
            by[0] = 3;
            by[1] = 2;
            by[2] = 0;
            by[3] = 0;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
            [self.PlayPauseButton setTitle:@"播放" forState:UIControlStateNormal];
        }
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
            [self.onOffButton setTitle:@"开" forState:UIControlStateNormal];
        }else{
            self.offFlag = NO;
            Byte by[4];
            by[0] = 4;
            by[1] = 2;
            by[2] = 0;
            by[3] = 0;
            NSData *da = [[NSData alloc] initWithBytes:by length:4];
            [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
            [self.onOffButton setTitle:@"关" forState:UIControlStateNormal];
        }
    }
}

#pragma mark ----------------------------------- 亮度值改变
- (void)lightSliderValueChange:(UISlider *)slider{
    self.lightValue = (int)slider.value;
    [self sendModeData];
}

#pragma mark ----------------------------------- 模式速度改变
- (void)modeSliderValueChange:(UISlider *)slider{
    self.speedValue = (int)slider.value;
    [self sendModeData];
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
    self.modeValue = (int)row;
    [self sendModeData];
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
    self.selectedColor = cp.selectedColor;
    if(self.character != nil){
        NSString *RGBValue = [NSString stringWithFormat:@"%@",self.selectedColor];
        NSArray *arr = [RGBValue componentsSeparatedByString:@" "];
        int r = [[arr objectAtIndex:1] floatValue]*100;
        int g = [[arr objectAtIndex:2] floatValue]*100;
        int b = [[arr objectAtIndex:3] floatValue]*100;
        Byte by[4];
        by[0] = 1;
        by[1] = r;
        by[2] = g;
        by[3] = b;
        NSData *da = [[NSData alloc] initWithBytes:by length:4];
        [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
        
    }
}

#pragma mark ----------------------------------- 发送模式数据
- (void)sendModeData{
    if(self.character != nil){
        Byte by[4];
        by[0] = 2;
        by[1] = self.modeValue;
        by[2] = self.lightValue;
        by[3] = self.speedValue;
        NSData *da = [[NSData alloc] initWithBytes:by length:4];
        [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
        
    }
}


- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    NSLog(@"characteristic  characteristic  = %@",characteristic);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
