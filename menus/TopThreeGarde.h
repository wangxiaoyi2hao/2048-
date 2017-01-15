//
//  TopThreeGarde.h
//  2048游戏
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopThreeGardeDelegate <NSObject>

- (void)deleteHistoryScroe;

@end

@interface TopThreeGarde : UIView
@property (retain,readwrite,nonatomic)UILabel * topOne;
@property (retain,readwrite,nonatomic)UILabel * topTwo;
@property (retain,readwrite,nonatomic)UILabel * topThree;
@property (assign,nonatomic,readwrite)id delegate;
@end
