//
//  TopThreeGarde.m
//  2048游戏
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import "TopThreeGarde.h"
#import "DialogTest.h"

@implementation TopThreeGarde

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadViewWithFrame:frame];
    }
    return self;
}

- (void)loadViewWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor redColor];
    
    UILabel * rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    
    rankLabel.text = @"排行";
    
    rankLabel.backgroundColor = [UIColor orangeColor];
    
    rankLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:rankLabel];
    
    [self createCloseBtn];
    
    [self createDeleteGardeBtn];
    
    [self createTopThreeLabel];
}

- (void)createDeleteGardeBtn
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeSystem];
    
    btn.frame = CGRectMake(self.bounds.size.width/2.0+10, 160, self.bounds.size.width/2.0, 40);
    
    btn.layer.cornerRadius = 5;
    
    btn.layer.masksToBounds = YES;
    
    btn.backgroundColor = [UIColor lightGrayColor];
    
    [btn addTarget:self action:@selector(deleGardeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:@"删除记录" forState:UIControlStateNormal];
    
    [self addSubview:btn];
}

- (void)deleGardeBtnClick
{
    [_delegate deleteHistoryScroe];
}

- (void)createCloseBtn
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeSystem];
    
    btn.frame = CGRectMake(0, 160, self.bounds.size.width/2.0-10, 40);
    
    btn.layer.cornerRadius = 5;
    
    btn.layer.masksToBounds = YES;
    
    btn.backgroundColor = [UIColor lightGrayColor];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:@"关闭窗口" forState:UIControlStateNormal];
    
    [self addSubview:btn];
}

- (void)createTopThreeLabel
{
    _topOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, 40)];
    _topTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, self.bounds.size.width, 40)];
    _topThree = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, self.bounds.size.width, 40)];
    
    _topOne.textAlignment = NSTextAlignmentCenter;
    _topTwo.textAlignment = NSTextAlignmentCenter;
    _topThree.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_topOne];
    [self addSubview:_topTwo];
    [self addSubview:_topThree];
}

- (void)btnClick
{
    closeDialog(self, YES, CloseDiaolgAnimationCenter, ^(BOOL finish) {
        NSLog(@"关闭成功");
    });
}

@end
