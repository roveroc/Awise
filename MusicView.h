//
//  MusicView.h
//  AwiseController
//
//  Created by rover on 16/6/8.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicView : UIView<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>{
    NSMutableArray              *musicArray;
    int                         musicLength;
    int                         musicCurrentIndex;
    AVAudioPlayer               *mPlayer;
    NSTimer                     *musicTimer;
    NSTimer                     *labelTimer;
    UIView                      *waveView;
}

@property (nonatomic, retain) NSMutableArray            *musicArray;   //音乐数据源数组
@property (assign)            int                       musicLength;   //音乐时间长度
@property (assign)            int                       musicCurrentIndex;   //当前播放的音乐索引
@property (nonatomic, retain) AVAudioPlayer             *mPlayer;      //播放器
@property (nonatomic, retain) NSTimer                   *musicTimer;   //获取音乐声音大小的定时器
@property (nonatomic, retain) NSTimer                   *labelTimer;   //计算播放时间
@property (nonatomic, retain) UIView                    *waveView;     //显示音量大小的动态View

@property (weak, nonatomic) IBOutlet UITableView *musicListView;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *time1Label;
@property (weak, nonatomic) IBOutlet UILabel *time2Label;
@property (weak, nonatomic) IBOutlet UIButton *music_PlayPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


- (IBAction)playPauseBtnClicked:(id)sender;
- (IBAction)preBtnClicked:(id)sender;
- (IBAction)nextBtnClicked:(id)sender;





@end
