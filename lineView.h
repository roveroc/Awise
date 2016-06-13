//
//  lineView.h
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"

@interface lineView : UIView{
    int             activeIndex;        //当前编辑的位置
}
@property (assign)      int     activeIndex;


- (void)roverDraw;


@end
