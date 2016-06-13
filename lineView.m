//
//  lineView.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "lineView.h"

#define PI 3.14159265358979323846

@implementation lineView
@synthesize activeIndex;
@synthesize delegate;
@synthesize pointArray;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing codes
    self.pointArray = [[NSMutableArray alloc] init];
    [self roverDraw];
}

#pragma mark - 按iPhone5来的宽来算，坐标轴总长300，以五分钟一个间隔，即：24*（60/5）= 288
- (void)roverDraw{
    NSMutableArray *_arr1 = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray lastObject]];
    NSMutableArray *_arr2 = [[NSMutableArray alloc] initWithArray:(NSArray *)[[AwiseGlobal sharedInstance].lineArray lastObject]];
    [_arr1 replaceObjectAtIndex:0 withObject:@"00:00"];
    [_arr2 replaceObjectAtIndex:0 withObject:@"24:00"];
    [[AwiseGlobal sharedInstance].lineArray insertObject:_arr1 atIndex:0];
    [[AwiseGlobal sharedInstance].lineArray addObject:_arr2];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    for(int i=0;i<_arr1.count - 1;i++){
        //设置连接类型
        CGContextSetLineJoin(currentContext, kCGLineJoinMiter);
        //设置线条宽度
        CGContextSetLineWidth(currentContext,1.0f);
        if(i == 0)
            CGContextSetRGBStrokeColor(currentContext, 1.0, 0.1, 0.1, 1.);
        else if (i == 1)
            CGContextSetRGBStrokeColor(currentContext, 0.1, 1.0, 0.1, 1.);
        else if (i == 2)
            CGContextSetRGBStrokeColor(currentContext, 0.1, 0.1, 1.0, 1.);
        else if (i == 3)
            CGContextSetRGBStrokeColor(currentContext, 0.5, 1.0, 0.2, 1.);
        else if (i == 4)
            CGContextSetRGBStrokeColor(currentContext, 0.1, 0.2, 0.3, 1.);
        else if (i == 5)
            CGContextSetRGBStrokeColor(currentContext, 0.3, 0.2, 0.1, 1.);
        
        for(int j = 0;j<[AwiseGlobal sharedInstance].lineArray.count;j++){
            NSMutableArray *tempArr = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:j];
            NSString *timeStr = [tempArr objectAtIndex:0];
            int time = [[[timeStr componentsSeparatedByString:@":"] objectAtIndex:0] intValue]*(60/5) +
                       [[[timeStr componentsSeparatedByString:@":"] objectAtIndex:1] intValue]/5;
            int x = (int)(((SCREEN_WIDHT-26)*time)/288.);//(int)((300*time)/288.);
            int y = 95 - [[tempArr objectAtIndex:i+1] intValue]*90/100.;
            //设置开始点位置
            if(j == 0)
                CGContextMoveToPoint(currentContext,x,y);
            //设置另一个终点
            else
                CGContextAddLineToPoint(currentContext,x,y);
        }
        //画线
        CGContextStrokePath(currentContext);
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for(int j = 1;j<[AwiseGlobal sharedInstance].lineArray.count-1;j++){
            NSMutableArray *tempArr = [[AwiseGlobal sharedInstance].lineArray objectAtIndex:j];
            NSString *timeStr = [tempArr objectAtIndex:0];
            int time = [[[timeStr componentsSeparatedByString:@":"] objectAtIndex:0] intValue]*(60/5) +
                       [[[timeStr componentsSeparatedByString:@":"] objectAtIndex:1] intValue]/5;
            int x = (int)(((SCREEN_WIDHT-26)*time)/288.);//(int)((300*time)/288.);
            int y = 95 - [[tempArr objectAtIndex:i+1] intValue]*90/100.;
            if(j == self.activeIndex){
                UIColor *color = [UIColor colorWithRed:1. green:0.1 blue:0.1 alpha:1];
                [self drawCrile:x y:y radius:4 color:color context:currentContext];
            }
            else{
                UIColor *color = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:1];
                [self drawCrile:x y:y radius:4 color:color context:currentContext];
            }
            [tempArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
        [self.pointArray addObject:tempArray];
    }
    [[AwiseGlobal sharedInstance].lineArray removeObjectAtIndex:0];
    [[AwiseGlobal sharedInstance].lineArray removeLastObject];
}

//标记一个锚点
- (void)drawCrile:(int)x y:(int)y radius:(int)r color:(UIColor *)c context:(CGContextRef)ref{
    //填充圆，无边框
    CGContextAddArc(ref, x, y, r, 0, 2*PI, 0); //添加一个圆
//    UIColor*aColor = [UIColor colorWithRed:0. green:1.0 blue:0.1 alpha:1];
    CGContextSetFillColorWithColor(ref, c.CGColor);//填充颜色
    CGContextDrawPath(ref, kCGPathFill);//绘制填充
}

//得到触摸点的坐标
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch =  [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for(int i=0;i<self.pointArray.count;i++){
        NSMutableArray *temp = [self.pointArray objectAtIndex:i];
        for(int j=0;j<temp.count;j++){
            NSValue *val = [temp objectAtIndex:j];
            CGPoint p = [val CGPointValue];
            CGFloat xDist = (point.x - p.x);
            CGFloat yDist = (point.y - p.y);
            CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
            NSLog(@"两点间的距离为 = %f",distance);
            if(distance < 20){
//                [self.delegate lineViewPointSelected:(j+1)];
                NSLog(@"相当于选中的列数为 = %d",j+1);
                goto gotoLabel;
            }
        }
    }
gotoLabel:nil;
}



@end
