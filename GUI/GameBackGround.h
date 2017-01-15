//
//  GameBackGround.h
//  2048游戏
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <stdio.h>

#define LENTHOFINTERVAL 10
#define LENTHOFBLOCK 62.5
#define ROW 4
#define COLUMNN 4

#define MOVEINTERVAL 72.5//即(LENTHOFINTERVAL+LENTHOFBLOCK)

@protocol GameBackGroundDelegate <NSObject>

- (void)setNewScroe:(int)garde;

@end

static  int currentEmptyBlock = 16;

@interface GameBackGround : UIView
{
    
    int numberValueDistribution[ROW][COLUMNN];
    int combineNumberValueDistribution[ROW][COLUMNN];
    
    int currentNumberDistribution[ROW][COLUMNN];
    
    int emptyRow[ROW];
    int emptyColumnn[COLUMNN];
    //分别获取i,j下标下对应方块的中心点位置
    float blockCenterLocationX[ROW][COLUMNN];
    float blockCenterLocationY[ROW][COLUMNN];
    id _delegate;
}
@property (assign,nonatomic,readwrite)id <GameBackGroundDelegate>delegate;
@property (retain,nonatomic,readwrite)NSMutableArray * noNumberBlockLocation;
@end


