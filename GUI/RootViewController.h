//
//  RootViewController.h
//  2048游戏
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBackGround.h"
#import "TopThreeGarde.h"

#define GameWidht 300
#define GameHeight 300
#define ScrollHight self.view.bounds.size.height
#define SCrollWidth self.view.bounds.size.width
@interface RootViewController : UIViewController<GameBackGroundDelegate>
{
    NSMutableArray * topThreeGarde;//只记录前三名的成绩
    TopThreeGarde * topThreeView;
}
@end
