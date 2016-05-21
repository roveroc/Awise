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
@synthesize sendTimer;
@synthesize rValue,gValue,bValue;

#pragma mark ----------------------------------------------- 返回时断开蓝牙连接
- (void)viewWillDisappear:(BOOL)animated{
    if(self.connectPeripheral != nil){
        [self.centralManager cancelPeripheralConnection:self.connectPeripheral];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.rValue = 0;
    self.gValue = 0;
    self.bValue = 0;
    
    // Do any additional setup after loading the view from its nib.
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.centralManager = [[CBCentralManager alloc]
                           initWithDelegate:self queue:dispatch_get_main_queue()];
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(sendDataToBLEDevice) userInfo:nil repeats:YES];
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

- (void)viewWillLayoutSubviews{
    if(colorPicker != nil)
        return;
    colorPicker = [[KZColorPicker alloc] initWithFrame:self.view.bounds];
    colorPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    colorPicker.selectedColor = self.selectedColor;
    colorPicker.oldColor = self.selectedColor;
    [colorPicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorPicker];
    
//    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 50, 80, 80)];
//    [btn1 setTitle:@"红++" forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(sendData1) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];
//    
//    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(5, 150, 80, 80)];
//    [btn2 setTitle:@"绿++" forState:UIControlStateNormal];
//    [btn2 addTarget:self action:@selector(sendData2) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn2];
//    
//    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(5, 250, 80, 80)];
//    [btn3 setTitle:@"蓝++" forState:UIControlStateNormal];
//    [btn3 addTarget:self action:@selector(sendData3) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn3];
//    
//    UIButton *btn1_1 = [[UIButton alloc] initWithFrame:CGRectMake(230, 50, 80, 80)];
//    [btn1_1 setTitle:@"红--" forState:UIControlStateNormal];
//    [btn1_1 addTarget:self action:@selector(sendData1_1) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1_1];
//    
//    UIButton *btn2_1 = [[UIButton alloc] initWithFrame:CGRectMake(230, 150, 80, 80)];
//    [btn2_1 setTitle:@"绿--" forState:UIControlStateNormal];
//    [btn2_1 addTarget:self action:@selector(sendData2_1) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn2_1];
//    
//    UIButton *btn3_1 = [[UIButton alloc] initWithFrame:CGRectMake(230, 250, 80, 80)];
//    [btn3_1 setTitle:@"蓝--" forState:UIControlStateNormal];
//    [btn3_1 addTarget:self action:@selector(sendData3_1) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn3_1];
    
//    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(280, 50, 80, 80)];
//    [btn4 setTitle:@"归零" forState:UIControlStateNormal];
//    [btn4 addTarget:self action:@selector(sendData4) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn4];
}

- (void)sendData1{
    Byte by[4];
    by[0] = 1;
    by[1] = rValue++;
    by[2] = gValue;
    by[3] = bValue;
    NSData *da = [[NSData alloc] initWithBytes:by length:4];
    [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
    NSLog(@"发送的数据为 ====  %d   %d  %d",rValue,gValue,bValue);
}

- (void)sendData2{
    Byte by[4];
    by[0] = 1;
    by[1] = rValue;
    by[2] = gValue++;
    by[3] = bValue;
    NSData *da = [[NSData alloc] initWithBytes:by length:4];
    [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
    NSLog(@"发送的数据为 ====  %d   %d  %d",rValue,gValue,bValue);
}

- (void)sendData3{
    Byte by[4];
    by[0] = 1;
    by[1] = rValue;
    by[2] = gValue;
    by[3] = bValue++;
    NSData *da = [[NSData alloc] initWithBytes:by length:4];
    [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
    NSLog(@"发送的数据为 ====  %d   %d  %d",rValue,gValue,bValue);
}

- (void)sendData1_1{
    Byte by[4];
    by[0] = 1;
    by[1] = rValue--;
    by[2] = gValue;
    by[3] = bValue;
    NSData *da = [[NSData alloc] initWithBytes:by length:4];
    [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
    NSLog(@"发送的数据为 ====  %d   %d  %d",rValue,gValue,bValue);
}

- (void)sendData2_1{
    Byte by[4];
    by[0] = 1;
    by[1] = rValue;
    by[2] = gValue--;
    by[3] = bValue;
    NSData *da = [[NSData alloc] initWithBytes:by length:4];
    [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
    NSLog(@"发送的数据为 ====  %d   %d  %d",rValue,gValue,bValue);
}

- (void)sendData3_1{
    Byte by[4];
    by[0] = 1;
    by[1] = rValue;
    by[2] = gValue;
    by[3] = bValue--;
    NSData *da = [[NSData alloc] initWithBytes:by length:4];
    [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
    NSLog(@"发送的数据为 ====  %d   %d  %d",rValue,gValue,bValue);
}

- (void)sendData4{
    rValue = 0;
    gValue = 0;
    bValue = 0;
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
        [self.dataArray addObject:da];
//        [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
        
    }
}

#pragma mark ------------------------------------ 定时器轮询发送数据
- (void)sendDataToBLEDevice{
    if(self.dataArray.count > 0){
        NSData *da = [self.dataArray objectAtIndex:0];
        NSLog(@"发送的数据为 ====   %@",da);
        [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
        [self.dataArray removeObjectAtIndex:0];
//        [self.connectPeripheral readValueForCharacteristic:self.character];
        
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
