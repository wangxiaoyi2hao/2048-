//
//  DialogueDemo.m
//  对话框测试
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import "DialogueDemo.h"
#import "DialogTest.h"

@implementation DialogueDemo

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self createCloseBtn];
        [self createGameEndLabel];
        [self createRestartBtn];
        self.backgroundColor = [UIColor darkGrayColor];
        
    }
    return self;
}

- (void)createGameEndLabel
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    
    label.center = CGPointMake(self.bounds.size.width/2.0, 10);
    
    label.layer.cornerRadius = 5;
    
    [label setText:@"游戏菜单"];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor lightTextColor];
    
    label.alpha = 0.6;
    
    [self addSubview:label];
}

- (void)createCloseBtn
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.layer.cornerRadius = 10;
    
    button.frame =CGRectMake(0, 110, 80, 40);
    
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"保存并结束" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self addSubview:button];
}

- (void)buttonClick
{
    closeDialog(self, YES, CloseDiaolgAnimationCenter, ^(BOOL finish) {
        NSLog(@"关闭成功");
        //在这里设置保存文件操作
        [_delegate saveNewScore];
    });
}

- (void)createRestartBtn
{
    UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    resetButton.layer.cornerRadius = 10;
    
    resetButton.frame =CGRectMake(120, 110, 80, 40);
    
    [resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    resetButton.backgroundColor = [UIColor grayColor];
    [resetButton setTitle:@"重新开始" forState:UIControlStateNormal];
    
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self addSubview:resetButton];
}

- (void)resetButtonClick
{
    //在这里调用重玩游戏的选项
    [_delegate restBtnClick];
    
    [self buttonClick];
}

@end
