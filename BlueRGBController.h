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
#import "ASValueTrackingSlider.h"

@interface BlueRGBController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    KZColorPicker           *colorPicker;
    UIColor                 *selectedColor;
    CBCentralManager        *centralManager;
    CBPeripheral            *connectPeripheral;
    CBCharacteristic        *character;
    NSMutableArray          *dataArray;
    
    UIPickerView            *modePicker;
    ASValueTrackingSlider   *lightSlider;
    ASValueTrackingSlider   *modeSlider;
    NSMutableArray          *modeArray;
    
    int                     lightValue;
    int                     speedValue;
    int                     modeValue;
    
    UIButton                *onButton;
    UIButton                *offButton;
}

@property (nonatomic, retain) KZColorPicker         *colorPicker;            //颜色选择器
@property (nonatomic, retain) UIColor               *selectedColor;          //选中的颜色
@property (nonatomic, retain) CBCentralManager      *centralManager;         //蓝牙Manager
@property (nonatomic, strong) CBPeripheral          *connectPeripheral;      //连接成功后的外围设备
@property (nonatomic, strong) CBCharacteristic      *character;              //外围设备提供的特征
@property (nonatomic, retain) NSMutableArray        *dataArray;              //带发送数据
@property (nonatomic, retain) UIPickerView          *modePicker;             //模式选择器
@property (nonatomic, retain) NSMutableArray        *modeArray;              //模式
@property (nonatomic, retain) ASValueTrackingSlider *lightSlider;            //亮度值指示条
@property (nonatomic, retain) ASValueTrackingSlider *modeSlider;             //速度值指示条
@property (assign)            int                   lightValue;              //亮度值
@property (assign)            int                   speedValue;              //速度值
@property (assign)            int                   modeValue;               //速度值
@property (nonatomic, retain) UIButton              *onButton;               //选中的颜色
@property (nonatomic, retain) UIButton              *offButton;              //选中的颜色

@end
