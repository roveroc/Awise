//
//  EditSingleTouchSceneController.h
//  AwiseController
//
//  Created by rover on 16/4/30.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"


@protocol EditSceneDelegate <NSObject>

- (void)needUpdateSceneView:(int)index value:(int)v;        //返回需刷新场景界面

@end

@interface EditSingleTouchSceneController : UIViewController<EditSceneDelegate>{
    int                         index;
    id<EditSceneDelegate>       delegate;
}
@property (assign) int                                      index;
@property (nonatomic, retain) id<EditSceneDelegate>         delegate;



@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;


- (IBAction)sliderValueChange:(id)sender;



@end
