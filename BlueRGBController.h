//
//  BlueRGBController.h
//  AwiseController
//
//  Created by rover on 16/5/9.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "KZColorPicker.h"
#import "AwiseGlobal.h"

@interface BlueRGBController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>{
    KZColorPicker           *colorPicker;
    UIColor                 *selectedColor;
    CBCentralManager        *centralManager;
    CBPeripheral            *connectPeripheral;
    CBCharacteristic        *character;
    NSMutableArray          *dataArray;
    NSTimer                 *sendTimer;
    
    int                     rValue;
    int                     gValue;
    int                     bValue;
}


@property (nonatomic, retain) KZColorPicker             *colorPicker;            //颜色选择器
@property (nonatomic, retain) UIColor                   *selectedColor;          //选中的颜色
@property (nonatomic, retain) CBCentralManager          *centralManager;         //蓝牙Manager
@property (nonatomic, strong) CBPeripheral              *connectPeripheral;      //连接成功后的外围设备
@property (nonatomic, strong) CBCharacteristic          *character;              //外围设备提供的特征
@property (nonatomic, retain) NSMutableArray            *dataArray;              //带发送数据
@property (nonatomic, retain) NSTimer                   *sendTimer;              //定时轮询数据

@property (assign) int rValue;
@property (assign) int gValue;
@property (assign) int bValue;

@end
