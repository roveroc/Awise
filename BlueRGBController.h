//
//  BlueRGBController.h
//  AwiseController
//
//  Created by rover on 16/5/9.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "KZColorPicker.h"
#import "AwiseGlobal.h"
#import "ASValueTrackingSlider.h"
#import "MusicView.h"
#import "BlueRGBCutomView.h"

@interface BlueRGBController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UIPickerViewDataSource,UIPickerViewDelegate,AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource,MusicDelegate,CustomRGBDelegate>{
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
    
    NSMutableArray          *BLE_DeviceArray;
    UITableView             *deviceTable;
    int                     selectDeviceIndex;
    
    //by rover
    BOOL touchFlag;
    NSTimer *touchTimer;
    
    int                     lightValue;
    int                     speedValue;
    int                     modeValue;
    
    UIButton                *onOffButton;
    UIButton                *PlayPauseButton;
    UIButton                *musicButton;
    UIButton                *customButton;
    BOOL                    offFlag;
    BOOL                    palyFlag;
    
    UIScrollView            *backScrollView;
    
    //music part
    NSMutableArray          *ipodMusicArray;
    MusicView               *mview;
    
    BOOL                    isTouchPicker;
    int                     rValue;
    int                     gValue;
    int                     bValue;
    
    //custom part
    BlueRGBCutomView        *cusotmView;
    
    //scanner timer
    NSTimer                 *scanTimer;
    
    //编辑设备名时用到
    UIButton                *tempButton;
    //数据库中的蓝牙设备集合
    NSMutableArray          *sql_BLEArray;
    //判断设备是否在线
    NSMutableArray          *BLE_onLineArray;
    NSMutableArray          *tempArray;
    int                     tempCount;
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
@property (assign) BOOL touchFlag;
@property (nonatomic, retain) NSTimer *touchTimer;
@property (assign)            int                   lightValue;              //亮度值
@property (assign)            int                   speedValue;              //速度值
@property (assign)            int                   modeValue;               //速度值
@property (assign)            BOOL                  offFlag;                 //开关标识
@property (assign)            BOOL                  palyFlag;                //播放标识
@property (nonatomic, retain) UIButton              *onOffButton;            //开关
@property (nonatomic, retain) UIButton              *PlayPauseButton;        //播放、暂停
@property (nonatomic, retain) UIButton              *musicButton;            //调到音乐播放界面
@property (nonatomic, retain) UIButton              *customButton;           //自定义

@property (nonatomic, retain) UIScrollView          *backScrollView;         //用来适配不同布局

@property (nonatomic, retain) NSMutableArray        *ipodMusicArray;         //music数组
@property (nonatomic, retain) MusicView             *mview;                  //播放音乐时的定时器

@property (nonatomic, retain) NSMutableArray        *BLE_DeviceArray;        //周围设备集合
@property (nonatomic, retain) UITableView           *deviceTable;            //设备列表
@property (assign)            int                   selectDeviceIndex;       //控制的设备序号
@property (assign)            BOOL                  isTouchPicker;           //调光？模式
@property (assign)            int                   rValue;
@property (assign)            int                   gValue;
@property (assign)            int                   bValue;

@property (nonatomic, retain) BlueRGBCutomView      *cusotmView;
@property (nonatomic, retain) NSTimer               *scanTimer;
@property (nonatomic, retain) UITableViewCell       *tempCell;
@property (nonatomic, retain) NSMutableArray        *sql_BLEArray;
@property (nonatomic, retain) NSMutableArray        *BLE_onLineArray;
@property (nonatomic, retain) NSMutableArray        *tempArray;
@property (assign)            int                   tempCount;
@end
