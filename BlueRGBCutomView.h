//
//  BlueRGBCutomView.h
//  AwiseController
//
//  Created by rover on 16/6/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZColorPicker.h"

@interface BlueRGBCutomView : UIView{
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

@end
