//
//  lineView.h
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"

@protocol LineViewDelegate <NSObject>

- (void)lineViewPointSelected:(int)index;

@end

@interface lineView : UIView<LineViewDelegate>{
    int                         activeIndex;
    id<LineViewDelegate>        delegate;
    NSMutableArray              *pointArray;
}
@property (assign)                  int                  activeIndex;       //当前编辑的位置
@property (nonatomic, retain)       id<LineViewDelegate> delegate;
@property (nonatomic, retain)       NSMutableArray       *pointArray;       //得到所有的坐标点集合


- (void)roverDraw;


@end
