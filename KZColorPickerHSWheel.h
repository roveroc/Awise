//
//  KZColorPickerWheel.h
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSV.h"

@interface KZColorPickerHSWheel : UIControl
{
	UIImageView *wheelImageView;
	UIImageView *wheelKnobView;
	
	HSVType currentHSV;
    
    //by rover
    BOOL touchFlag;
    NSTimer *touchTimer;
}

@property (assign) BOOL touchFlag;
@property (nonatomic, retain) NSTimer *touchTimer;


@property (nonatomic) HSVType currentHSV;

- (id)initAtOrigin:(CGPoint)origin;
@end
