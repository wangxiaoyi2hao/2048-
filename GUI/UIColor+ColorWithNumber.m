//
//  UIColor+ColorWithNumber.m
//  2048游戏
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import "UIColor+ColorWithNumber.h"

@implementation UIColor (ColorWithNumber)
+ (UIColor *)colorWithNumber:(int)numberOfColor
{
    if (numberOfColor == 2)
    {
    }
    switch (numberOfColor) {//这些颜色可以用mac自带的测色工具测
        case 0:
            return [UIColor colorWithRed:204.0/255.0 green:192.0/255.0 blue:180.0/255.0 alpha:1];
            break;
        case 2:
            return [UIColor colorWithRed:238.0/255.0 green:228.0/255.0 blue:218.0/255.0 alpha:1];
            break;
        case 4:
            return [UIColor colorWithRed:237.0/255.0 green:224.0/255.0 blue:201.0/255.0 alpha:1];
            break;
        case 8:
            return [UIColor colorWithRed:240.0/255.0 green:176.0/255.0 blue:125.0/255.0 alpha:1];
            break;
        case 16:
            return [UIColor colorWithRed:243.0/255.0 green:149.0/255.0 blue:104.0/255.0 alpha:1];
            break;
        case 32:
            return [UIColor colorWithRed:244.0/255.0 green:124.0/255.0 blue:99.0/255.0 alpha:1];
            break;
        case 64:
            return [UIColor colorWithRed:244.0/255.0 green:95.0/255.0 blue:67.0/255.0 alpha:1];
        case 128:
            return [UIColor purpleColor];
            break;
        case 256:
            return [UIColor blueColor];
            break;
        case 512:
            return [UIColor yellowColor];
            break;
        case 1024:
            return [UIColor orangeColor];
            break;
        case 2048:
            return [UIColor redColor];
            break;
        default:
            return [UIColor brownColor];
            break;
    }
    
    return nil;
}

@end
