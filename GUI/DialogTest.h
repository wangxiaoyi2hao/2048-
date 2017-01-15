//
//  DialogTest.h
//  对话框测试
//
//  Created by QzydeMac on 14/11/25.
//  Copyright (c) 2014年 Qzy. All rights reserved.
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
