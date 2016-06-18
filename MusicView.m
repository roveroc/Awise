//
//  MusicView.m
//  AwiseController
//
//  Created by rover on 16/6/8.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "MusicView.h"

@implementation MusicView
@synthesize musicArray;
@synthesize mPlayer;
@synthesize musicTimer;
@synthesize labelTimer;
@synthesize musicCurrentIndex;
@synthesize waveView;
@synthesize delegate;

- (void)drawRect:(CGRect)rect {
    self.musicListView.delegate   = self;
    self.musicListView.dataSource = self;
    self.musicListView.tableFooterView = [[UIView alloc] init];
    self.musicCurrentIndex = -1;
    self.music_PlayPauseBtn.enabled = NO;
    self.preBtn.enabled  = NO;
    self.nextBtn.enabled = NO;
    self.musicTimer = [NSTimer scheduledTimerWithTimeInterval:0.08
                                                       target:self
                                                     selector:@selector(getPowerValue)
                                                     userInfo:nil
                                                      repeats:YES];
    self.labelTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateTimeLabelText)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.musicTimer fire];
}

#pragma mark ------------------------------------------------ 更新播放时间值
- (void)updateTimeLabelText{
    if(self.mPlayer == nil)
        return;
    NSString *totalTimeStr;         //总时间
    NSString *currentTimeStr;       //当前播放的时间
    int totalTime = (int)self.mPlayer.duration;
    int min = totalTime/60;
    int sen = totalTime%60;
    if(min > 9 && sen > 9){
        totalTimeStr = [NSString stringWithFormat:@"%d:%d",min,sen];
    }else if(min < 10 && sen > 9){
        totalTimeStr = [NSString stringWithFormat:@"0%d:%d",min,sen];
    }else if(min >9 && sen < 10){
        totalTimeStr = [NSString stringWithFormat:@"%d:0%d",min,sen];
    }else if(min <10 && sen < 10){
        totalTimeStr = [NSString stringWithFormat:@"0%d:0%d",min,sen];
    }
    self.time2Label.text = totalTimeStr;
    
    int currentTime = (int)self.mPlayer.currentTime;
    int min_1 = currentTime/60;
    int sen_1 = currentTime%60;
    if(min_1 > 9 && sen_1 > 9){
        currentTimeStr = [NSString stringWithFormat:@"%d:%d",min_1,sen_1];
    }else if(min_1 < 10 && sen_1 > 9){
        currentTimeStr = [NSString stringWithFormat:@"0%d:%d",min_1,sen_1];
    }else if(min_1 >9 && sen_1 < 10){
        currentTimeStr = [NSString stringWithFormat:@"%d:0%d",min_1,sen_1];
    }else if(min_1 <10 && sen_1 < 10){
        currentTimeStr = [NSString stringWithFormat:@"0%d:0%d",min_1,sen_1];
    }
    self.time1Label.text = currentTimeStr;
    
    self.timeSlider.minimumValue = 0.0;
    self.timeSlider.maximumValue = self.mPlayer.duration;
    self.timeSlider.value = self.mPlayer.currentTime;
}

#pragma mark ------------------------------------------------ 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark ------------------------------------------------ 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicArray.count;
}

#pragma mark ------------------------------------------------ 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.;
}

#pragma mark ------------------------------------------------ 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSMutableArray *musicInfo = [self.musicArray objectAtIndex:indexPath.row];
    NSURL *url = [musicInfo objectAtIndex:1];
    if([self.mPlayer isPlaying]){
        if(self.musicCurrentIndex == (int)indexPath.row){
            [self.mPlayer pause];
            [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                               forState:UIControlStateNormal];
        }
        else{
            [self.mPlayer stop];
            self.mPlayer = nil;
            self.mPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            self.mPlayer.meteringEnabled = YES;
            self.mPlayer.delegate = self;
            [self.mPlayer prepareToPlay];
            [self.mPlayer play];
            self.musicCurrentIndex = (int)indexPath.row;
            [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                               forState:UIControlStateNormal];
        }
    }else{
        if(self.musicCurrentIndex == (int)indexPath.row){
            [self.mPlayer play];
            [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                               forState:UIControlStateNormal];
        }else{
            [self.mPlayer stop];
            self.mPlayer = nil;
            self.mPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            self.mPlayer.meteringEnabled = YES;
            self.mPlayer.delegate = self;
            [self.mPlayer prepareToPlay];
            [self.mPlayer play];
            self.musicCurrentIndex = (int)indexPath.row;
            [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                               forState:UIControlStateNormal];
        }
    }
    self.music_PlayPauseBtn.enabled = YES;
    self.preBtn.enabled  = YES;
    self.nextBtn.enabled = YES;
    if(indexPath.row == 0){
        self.preBtn.userInteractionEnabled  = NO;
        self.nextBtn.userInteractionEnabled = YES;
    }else if(indexPath.row == self.musicArray.count -1){
        self.preBtn.userInteractionEnabled  = YES;
        self.nextBtn.userInteractionEnabled = NO;
    }
    [self.musicListView reloadData];
}

#pragma mark ------------------------------------------------ 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    if(self.musicCurrentIndex == indexPath.row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.imageView.image=[UIImage imageNamed:@"aboutUs.png"];
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSMutableArray *temp = [self.musicArray objectAtIndex:indexPath.row];
    if(temp.count == 3){
        NSString *musicName  = [temp objectAtIndex:0];
        NSString *musicAtist = [temp objectAtIndex:2];
        cell.textLabel.text  = [musicName stringByAppendingFormat:@" -- %@",musicAtist];
    }else{
        NSString *musicName  = [temp objectAtIndex:0];
        cell.textLabel.text  = musicName;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark ----------------------------------- 获取音乐音量峰值
- (void)getPowerValue{
    if(self.mPlayer == nil)
        return;
    //添加动态View
    if(self.waveView == nil){
        self.waveView = [[UIView alloc] init];
        self.waveView.backgroundColor = [UIColor greenColor];
        [self addSubview:waveView];
    }
    
    if([self.mPlayer isPlaying]){
        [self.mPlayer updateMeters];
        //    float value1 = [self.mPlayer averagePowerForChannel:0];
        //    NSLog(@"value1 == %f",value1);
        float value2 = [self.mPlayer averagePowerForChannel:1];
        float height = (float)(10 * (30-fabsf(value2)));
        self.waveView.frame = CGRectMake(0, self.musicListView.frame.origin.x+self.musicListView.frame.size.height+50, height, 20);
        int value = 100-(int)((100*(fabsf(value2)))/30.);
        NSLog(@"value4 == %d",value);
        [self.delegate sendMusicVoiceData:value];
    }
}

#pragma mark ----------------------------------- 暂停播放
- (IBAction)playPauseBtnClicked:(id)sender {
    if([self.mPlayer isPlaying]){
        [self.mPlayer pause];
        [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                           forState:UIControlStateNormal];
    }else{
        [self.mPlayer play];
        [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                           forState:UIControlStateNormal];
    }
}

#pragma mark ----------------------------------- 上一曲
- (IBAction)preBtnClicked:(id)sender {
    [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                       forState:UIControlStateNormal];
    if(self.musicCurrentIndex == 1){
        self.musicCurrentIndex = 0;
        self.preBtn.enabled = NO;
    }else{
        self.musicCurrentIndex --;
    }
    self.nextBtn.enabled = YES;
    NSMutableArray *musicInfo = [self.musicArray objectAtIndex:self.musicCurrentIndex];
    [self.mPlayer stop];
    self.mPlayer = nil;
    self.mPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[musicInfo objectAtIndex:1]
                                                          error:nil];
    self.mPlayer.meteringEnabled = YES;
    self.mPlayer.delegate = self;
    [self.mPlayer prepareToPlay];
    [self.mPlayer play];
    [self.musicListView reloadData];
}

#pragma mark ----------------------------------- 下一曲
- (IBAction)nextBtnClicked:(id)sender {
    [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                       forState:UIControlStateNormal];
    if(self.musicCurrentIndex == self.musicArray.count-2){
        self.musicCurrentIndex = (int)self.musicArray.count-1;
        self.nextBtn.enabled = NO;
    }else{
        self.musicCurrentIndex ++;
    }
    self.preBtn.enabled = YES;
    NSMutableArray *musicInfo = [self.musicArray objectAtIndex:self.musicCurrentIndex];
    [self.mPlayer stop];
    self.mPlayer = nil;
    self.mPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[musicInfo objectAtIndex:1]
                                                          error:nil];
    self.mPlayer.meteringEnabled = YES;
    self.mPlayer.delegate = self;
    [self.mPlayer prepareToPlay];
    [self.mPlayer play];
    [self.musicListView reloadData];
}

#pragma mark ----------------------------------- 一首歌曲播放后的代理
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.music_PlayPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                       forState:UIControlStateNormal];
    self.preBtn.enabled  = YES;
    self.nextBtn.enabled = YES;
    if(self.musicCurrentIndex == self.musicArray.count-2){
        self.musicCurrentIndex = (int)self.musicArray.count-1;
        self.nextBtn.enabled = NO;
    }else if(self.musicCurrentIndex == self.musicArray.count -1){
        self.musicCurrentIndex = 0;
        self.preBtn.enabled = NO;
    }else{
        self.musicCurrentIndex ++;
    }
    NSMutableArray *musicInfo = [self.musicArray objectAtIndex:self.musicCurrentIndex];
    [self.mPlayer stop];
    self.mPlayer = nil;
    self.mPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[musicInfo objectAtIndex:1]
                                                          error:nil];
    self.mPlayer.meteringEnabled = YES;
    self.mPlayer.delegate = self;
    [self.mPlayer prepareToPlay];
    [self.mPlayer play];
    [self.musicListView reloadData];
}



@end
