//
//  BlueRGBCutomView.h
//  AwiseController
//
//  Created by rover on 16/6/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZColorPicker.h"
#import "D3View.h"
#import "AwiseUserDefault.h"

@protocol CustomRGBDelegate <NSObject>

- (void)rgbColorChange:(int)r g:(int)g b:(int)b;
- (void)customSceneValue:(int)r g:(int)g b:(int)b;

@end

@interface BlueRGBCutomView : UIView<UIGestureRecognizerDelegate,CustomRGBDelegate>{
    KZColorPicker           *colorPicker;
    UILabel                 *R_lbale;
    UILabel                 *G_lbale;
    UILabel                 *B_lbale;
    
    UISlider                *R_slider;
    UISlider                *G_slider;
    UISlider                *B_slider;
    
    UILabel                 *R_valueLabel;
    UILabel                 *G_valueLabel;
    UILabel                 *B_valueLabel;
    
    int                     R_value;
    int                     G_value;
    int                     B_value;
    
    NSTimer                 *editTimer;
    
    int                     editIndex;
    NSMutableArray          *sceneArray;
    id<CustomRGBDelegate>   delegate;
    
    UIScrollView            *backScrollView;
}
@property (nonatomic, retain) KZColorPicker           *colorPicker;
@property (nonatomic, retain) UILabel                 *R_lbale;
@property (nonatomic, retain) UILabel                 *G_lbale;
@property (nonatomic, retain) UILabel                 *B_lbale;

@property (nonatomic, retain) UISlider                *R_slider;
@property (nonatomic, retain) UISlider                *G_slider;
@property (nonatomic, retain) UISlider                *B_slider;

@property (nonatomic, retain) UILabel                 *R_valueLabel;
@property (nonatomic, retain) UILabel                 *G_valueLabel;
@property (nonatomic, retain) UILabel                 *B_valueLabel;

@property (assign)            int                     R_value;
@property (assign)            int                     G_value;
@property (assign)            int                     B_value;

@property (nonatomic, retain) NSTimer                 *editTimer;
@property (assign)            int                     editIndex;        //当前正在编辑的UIbutton序号
@property (nonatomic, retain) NSMutableArray          *sceneArray;      //自定义的场景值
@property (nonatomic, retain) id<CustomRGBDelegate>   delegate;
@property (nonatomic, retain) UIScrollView          *backScrollView;         //用来适配不同布局

@end
