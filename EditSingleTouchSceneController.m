//
//  EditSingleTouchSceneController.m
//  AwiseController
//
//  Created by rover on 16/4/30.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "EditSingleTouchSceneController.h"

@interface EditSingleTouchSceneController ()

@end

@implementation EditSingleTouchSceneController
@synthesize index;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [[AwiseUserDefault sharedInstance].singleTouchSceneValue componentsSeparatedByString:@"&"];
    int value = (int)[arr objectAtIndex:index];
    self.valueLabel.text = [[arr objectAtIndex:index] stringByAppendingString:@"%"];
    self.slider.value = value;
}


#pragma mark ---------------------------------------- 当界面消失时，保存其修改的值
- (void)viewWillDisappear:(BOOL)animated{
    NSMutableArray *arr = (NSMutableArray *)[[AwiseUserDefault sharedInstance].singleTouchSceneValue componentsSeparatedByString:@"&"];
    int value = (int)self.slider.value;
    [arr replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",value]];
    NSString *newValue = [arr componentsJoinedByString:@"&"];
    [AwiseUserDefault sharedInstance].singleTouchSceneValue = newValue;
    [delegate needUpdateSceneView:index+1 value:value];     //代理，刷新场景view
}


#pragma mark ---------------------------------------- 改变亮度值
- (IBAction)sliderValueChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int value = (int)slider.value;
    self.valueLabel.text = [NSString stringWithFormat:@"%d%%",value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
