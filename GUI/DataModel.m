//
//  DataModel.c
//  2048游戏
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#include "DataModel.h"

void moveAndCombineArrayMethod(int moveArray[][4],UISwipeGestureRecognizerDirection dir)
{
    
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            moveandCombineArray[i][j] = 0;
        }
    }
    
    if (dir == UISwipeGestureRecognizerDirectionUp)
    {
        for (int i = 0; i<4; i++)//向上合并数据模型
        {
            int hasCombinCount = 0;
            for (int j = 0; j<4; j++)
            {
                if (j+1<4&&moveArray[j][i] == moveArray[j+1][i])
                {
                    moveandCombineArray[j-hasCombinCount][i] = 2*moveArray[j][i];
                    hasCombinCount = 1;//这个值最多为1
                    j++;
                }
                else
                {
                    moveandCombineArray[j-hasCombinCount][i] = moveArray[j][i];
                }
            }
        }

    }
    else if (dir == UISwipeGestureRecognizerDirectionDown)
    {
        for (int i = 0; i<4; i++)//向下合并数据模型
        {
            int hasCombinCount = 0;
            for (int j = 4-1; j>=0; j--)
            {
                if (j-1>=0&&moveArray[j][i] == moveArray[j-1][i])
                {
                    moveandCombineArray[j+hasCombinCount][i] = 2*moveArray[j][i];
                    hasCombinCount = 1;//这个值最多为1
                    j--;
                }
                else
                {
                    moveandCombineArray[j+hasCombinCount][i] = moveArray[j][i];
                }
            }
        }
    }
    else if (dir == UISwipeGestureRecognizerDirectionLeft)
    {
        for (int i = 0; i<4; i++)//向左合并数据模型
        {
            int hasCombinCount = 0;
            
            for (int j = 0; j<4; j++)
            {
                if (j+1<4&&moveArray[i][j] == moveArray[i][j+1])//数组均是越界等待进一步处理
                {
                    
                    moveandCombineArray[i][j-hasCombinCount] = 2*moveArray[i][j];
                    hasCombinCount = 1;//这个值最多为1
                    j++;
                    
                }
                else
                {
                    moveandCombineArray[i][j-hasCombinCount] = moveArray[i][j];
                }
            }
            
        }
    }
    else
    {
        for (int i = 0; i<4; i++)//向右合并数据模型
        {
            int hasCombinCount = 0;
            for (int j = 3; j>=0; j--)
            {
                if (j-1>=0&&moveArray[i][j] == moveArray[i][j-1])//数组均是越界等待进一步处理,数组只是取值,不会破坏内部数据
                {
                    moveandCombineArray[i][j+hasCombinCount] = 2*moveArray[i][j];
                    hasCombinCount = 1;//这个值最多为1
                    j--;
                }
                else
                {
                    moveandCombineArray[i][j+hasCombinCount] = moveArray[i][j];
                }
            }
            
        }
    }
}