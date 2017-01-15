//
//  DialogTest.h
//  对话框测试
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^complete)(BOOL finish);
typedef NS_ENUM(NSUInteger, ShowDiaolgAnimationStyle)
{
    ShowDiaolgAnimationNone,
    ShowDiaolgAnimationTop,
    ShowDiaolgAnimationLeft,
    ShowDiaolgAnimationCenter,
    ShowDiaolgAnimationRight,
    ShowDiaolgAnimationBotton
};

typedef NS_ENUM(NSUInteger, CloseDiaolgAnimationStyle)
{
    CloseDiaolgAnimationNone,
    CloseDiaolgAnimationTop,
    CloseDiaolgAnimationLeft,
    CloseDiaolgAnimationCenter,
    CloseDiaolgAnimationRight,
    CloseDiaolgAnimationBotton
};

void showDialog(UIView * view,BOOL model,ShowDiaolgAnimationStyle type,complete result);
void closeDialog(UIView * view,BOOL model,CloseDiaolgAnimationStyle type,complete result);
