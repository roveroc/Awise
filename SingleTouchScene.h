//
//  SingleTouchScene.h
//  AwiseController
//
//  Created by rover on 16/4/23.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwiseGlobal.h"
#import "EditSingleTouchSceneController.h"

@interface SingleTouchScene : UIView



- (IBAction)sceneClicked:(id)sender;
- (IBAction)editScene:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *sceneBtn1;
@property (weak, nonatomic) IBOutlet UIButton *sceneBtn2;
@property (weak, nonatomic) IBOutlet UIButton *sceneBtn3;
@property (weak, nonatomic) IBOutlet UIButton *sceneBtn4;

@property (weak, nonatomic) IBOutlet UIButton *editBtn1;
@property (weak, nonatomic) IBOutlet UIButton *editBtn2;
@property (weak, nonatomic) IBOutlet UIButton *editBtn3;
@property (weak, nonatomic) IBOutlet UIButton *editBtn4;




@end
