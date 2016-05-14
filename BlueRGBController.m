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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) options:nil];
    
    self.centralManager = [[CBCentralManager alloc]
                           initWithDelegate:self queue:dispatch_get_main_queue()];
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
    
    if([peripheral.name  isEqualToString:BLE_SERVICE_NAME]){
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
    NSLog(@"收到的数据------> %@",characteristic.value);
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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 450, 80, 80)];
    [btn setTitle:@"发送数据" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)sendData{
    Byte by[4];
    by[0] = 1;
    by[1] = 2;
    by[2] = 3;
    by[3] = 4;
    NSData *da = [[NSData alloc] initWithBytes:by length:4];
    [self.connectPeripheral writeValue:da forCharacteristic:self.character type:CBCharacteristicWriteWithResponse];
}

#pragma mark ----------------------------------- 颜色改变
- (void)pickerChanged:(KZColorPicker *)cp{
    self.selectedColor = cp.selectedColor;
//    NSString *RGBValue = [NSString stringWithFormat:@"%@",self.selectedColor];
    [self.connectPeripheral readValueForCharacteristic:self.character];
    
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
