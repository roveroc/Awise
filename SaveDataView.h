//
//  SaveDataView.h
//  AwiseController
//
//  Created by rover on 16/6/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveDataDelegate <NSObject>

- (void)cancelSave;
- (void)okSave:(NSMutableArray *)arr;

@end

@interface SaveDataView : UIView<SaveDataDelegate>{
    id<SaveDataDelegate>        delegate;
    NSMutableArray              *weekArray;
}
@property (nonatomic, retain) id<SaveDataDelegate>      delegate;
@property (nonatomic, retain) NSMutableArray            *weekArray;

@property (weak, nonatomic) IBOutlet UILabel *tilteLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

- (IBAction)weekBtnClicked:(id)sender;

- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)okBtnClicked:(id)sender;

- (void)loadWeekData:(NSMutableArray *)arr;

@end
