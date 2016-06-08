//
//  MusicView.h
//  AwiseController
//
//  Created by rover on 16/6/8.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicView : UIView<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *musicListView;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *time1Label;
@property (weak, nonatomic) IBOutlet UILabel *time2Label;
@property (weak, nonatomic) IBOutlet UIButton *music_PlayPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;







@end
