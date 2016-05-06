//
//  DetailEditController.h
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lineView.h"

@interface DetailEditController : UIViewController<UIAlertViewDelegate>{
    NSString            *navTitle;
    NSMutableArray      *singleArray;
    NSMutableArray      *tempArray;
    lineView            *lineview;
    int                 index;
    BOOL                fuckFlag;
    
    UILabel             *lab1;
    UILabel             *lab2;
    UILabel             *lab3;
    UILabel             *lab4;
    
    UISlider            *slider1;
    UISlider            *slider2;
    UISlider            *slider3;
    UISlider            *slider4;
    
    UILabel             *valueLab1;
    UILabel             *valueLab2;
    UILabel             *valueLab3;
    UILabel             *valueLab4;
    
    BOOL                isChange;
    
    
}
@property (nonatomic, retain) NSString *navTitle;
@property (nonatomic, retain) NSMutableArray *singleArray;
@property (nonatomic, retain) NSMutableArray *tempArray;
@property (nonatomic, retain) lineView *lineview;
@property (assign)            int      index;
@property (assign)            BOOL     fuckFlag;
@property (assign)            BOOL     isChange;

@property (weak, nonatomic) IBOutlet UIImageView *backImgview;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;


@property (nonatomic, retain) UILabel *lab1;
@property (nonatomic, retain) UILabel *lab2;
@property (nonatomic, retain) UILabel *lab3;
@property (nonatomic, retain) UILabel *lab4;

@property (nonatomic, retain) UISlider *slider1;
@property (nonatomic, retain) UISlider *slider2;
@property (nonatomic, retain) UISlider *slider3;
@property (nonatomic, retain) UISlider *slider4;

@property (nonatomic, retain) UILabel *valueLab1;
@property (nonatomic, retain) UILabel *valueLab2;
@property (nonatomic, retain) UILabel *valueLab3;
@property (nonatomic, retain) UILabel *valueLab4;



- (IBAction)previousFrame:(id)sender;
- (IBAction)nextFrame:(id)sender;


@end
