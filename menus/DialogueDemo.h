//
//  DialogueDemo.h
//  对话框测试
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol DialogueDemoDelegate <NSObject>

- (void)restBtnClick;

- (void)saveNewScore;

@end

@interface DialogueDemo : UIView
@property (assign,nonatomic,readwrite)id  delegate;
@end
