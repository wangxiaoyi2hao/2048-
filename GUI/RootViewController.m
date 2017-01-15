//
//  RootViewController.m
//  2048游戏
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//


/**

 2048编程思想:
 
    2048是一个4*4的方块,我们定义一个4*4的二维数组,i,j表示下标,值0表示该方块内当前没有数值,其他值则表示这个方块有数字相对应的方块,在用NSMutableArray记录那些值为0的下标(用CGPoint存取),以后我们随机产生一个新的方块,位置就从这里面取,但是如果该下标对应的Label被移除,我们需要立即将该下标存放到数组中,这就是随机产生方块的方法
 
    2.我们对4*4的二维数组进行处理,例如,屏幕收到向上移动的手势时,这个数组都会向上填充,而原本的位置需要置为0
 {2,2,0,4}          {2,2,8,4}                                                       {4,2,8,4}
 {2,4,8,0}------>   {2,4,2,2}                                               ---->   {2,4,4,2}
 {0,0,2,0}          {2,2,2,0}                                                       {0,2,0,0}
 {2,2,2,2}          {0,0,0,0},其他方向依次类推,让后我们需要产生数字合并规则后的数组          {0,0,0,0}(关于它的合并规则我也是从游戏当中获取的,大家也可以这样), 我们将第二个与第三个数组元素进行对比一个一个对比,相同这个Label,不处理,值不同的就移动
 
 这里注意一点,就是我们在移动时候需要修改label的tag值,这个值一定要在动画结束后在修改,否则很可能和要移除label的tag值相等,导致被移除,处理这个有两种方法,一是移动时标签给它乘以100,结束后,遍历*100的label,将值再除以100,亦可以添加延迟赋值,这个是最简单的
 
 */

#import "RootViewController.h"
#import "DialogTest.h"
#import "DialogueDemo.h"
#define HISTORYGARDE @"history"
static int newGarde = 0;
@interface RootViewController ()
{
    GameBackGround * game;
    UILabel * scroe;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    topThreeGarde = [[NSMutableArray alloc]init];
    
    [self createBackGroundImage];
    
    [self createHistoryBtn];
    
    [self createScroeLabel];
    
    [self createMenus];
    
}

- (void)createBackGroundImage
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    
    imageView.image = [UIImage imageNamed:@"IMG_0259.JPG"];
    
    [self.view addSubview:imageView];
    [self loadGame];
    [imageView release];
}


#pragma mark - 显示历史记录排行版
- (void)createHistoryBtn
{
    UIButton * historyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    CGFloat x = (SCrollWidth + 200)/2.0;
    
    historyBtn.frame = CGRectMake(x, ScrollHight - GameHeight-100, 50, 40);
    
    [historyBtn setTitle:@"历史" forState:UIControlStateNormal];
    
    historyBtn.backgroundColor = [UIColor redColor];
    
    [historyBtn setAlpha:0.5];
    
    [historyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    historyBtn.layer.cornerRadius = 10;
    
    [self.view addSubview:historyBtn];
    
    [historyBtn addTarget:self action:@selector(showHistory) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showHistory
{
    NSMutableArray * oldGardeArray = [[NSUserDefaults standardUserDefaults] objectForKey:HISTORYGARDE];
    

    NSMutableArray * gardeArray = [self gardeArrayMethod];
    
    if (oldGardeArray)
    {
        for (NSString * garde in oldGardeArray)
        {
            if (![gardeArray containsObject:garde]&&![garde isEqualToString:@"0"])
            {
                [gardeArray addObject:garde];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:HISTORYGARDE];
    
    [[NSUserDefaults standardUserDefaults] setObject:gardeArray forKey:HISTORYGARDE];
    
    [self setTopThreeGarde:gardeArray];
    
    NSLog(@"topThreeGarde%@",topThreeGarde);
    
    [self showHistoryDialogView];
}

- (void)showHistoryDialogView
{
    topThreeView = [[TopThreeGarde alloc]initWithFrame:CGRectMake(0, 0, 250, 200)];
    
    topThreeView.delegate = self;
    
    topThreeView.layer.cornerRadius = 10;
    
    topThreeView.layer.masksToBounds = YES;
    //以下是防止数组越界,写的有点笨,你可以放到数组里面去,不过我太懒了.....so...
    if (topThreeGarde.count>=1)
    {
        topThreeView.topOne.text = [NSString stringWithFormat:@"第一名:%@",topThreeGarde[0]];
    }
    else
    {
        topThreeView.topOne.text = [NSString stringWithFormat:@"第一名:0"];
    }
    
    if (topThreeGarde.count>=2) {
        topThreeView.topTwo.text = [NSString stringWithFormat:@"第二名:%@",topThreeGarde[1]];
    }
    else
    {
        topThreeView.topTwo.text = [NSString stringWithFormat:@"第二名:0"];
    }
    
    if (topThreeGarde.count>=3)
    {
        topThreeView.topThree.text = [NSString stringWithFormat:@"第三名:%@",topThreeGarde[2]];
    }
    else
    {
        topThreeView.topThree.text = [NSString stringWithFormat:@"第三名:0"];
    }
    
    showDialog(topThreeView, NO, ShowDiaolgAnimationCenter, ^(BOOL finish)
               {
                   NSLog(@"打开成功");
               });
    [TopThreeGarde release];
}
#pragma mark - 重玩游戏按钮设置
- (void)restBtnClick
{
    [game removeFromSuperview];
    scroe.text = @"0";
    newGarde = 0;
    [self loadGame];
}

#pragma mark - 游戏分数标签
- (void)createScroeLabel
{
    scroe = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 80, 40)];
    
    scroe.backgroundColor = [UIColor whiteColor];
    
    scroe.alpha = 0.7;
    
    scroe.layer.cornerRadius = 10;
    
    scroe.layer.masksToBounds = YES;
    
    [scroe setTextColor:[UIColor lightGrayColor]];
    
    scroe.font = [UIFont systemFontOfSize:20];
    
    scroe.text = @"0";
    
    scroe.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:scroe];
}

#pragma mark - 刷新游戏分数
- (void)setNewScroe:(int)garde
{
    newGarde += garde*2;
    scroe.text = [NSString stringWithFormat:@"%d",newGarde];
}

#pragma mark - 加载游戏视图
- (void)loadGame
{
    float space = (SCrollWidth - GameWidht)/2.0;
    
    float height = (ScrollHight - GameHeight)-50;
    
    game = [[GameBackGround alloc]initWithFrame:CGRectMake(space, height, GameWidht, GameHeight)];
    game.delegate = self;
    [self.view addSubview:game];
    
    [game release];
}
#pragma mark - 创建游戏菜单项
- (void)createMenus
{
    CGFloat x = (SCrollWidth + 80)/2.0;
    UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    menuBtn.frame = CGRectMake(x, ScrollHight - GameHeight-100, 50, 40);
    
    menuBtn.layer.cornerRadius = 10;
    
    menuBtn.layer.cornerRadius = 10;
    
    menuBtn.layer.masksToBounds = YES;
    
    [menuBtn setTitle:@"菜单" forState:UIControlStateNormal];
    
    menuBtn.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:menuBtn];
    
    [menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)menuBtnClick
{
    DialogueDemo * dia = [[DialogueDemo alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
    
    dia.delegate = self;
    
    dia.layer.cornerRadius = 10;
    
    dia.layer.masksToBounds = YES;
    
    NSLog(@"%p",dia);
    showDialog(dia, NO, ShowDiaolgAnimationCenter, ^(BOOL finish)
               {
                   NSLog(@"打开成功");
               });
    [dia release];
}

#pragma mark - 保存新成绩
- (void)saveNewScore
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * oldGardeArray = [[NSUserDefaults standardUserDefaults] objectForKey:HISTORYGARDE];
    
    NSMutableArray * gardeArray = [self gardeArrayMethod];
    
    if (oldGardeArray)
    {
        for (NSString * garde in oldGardeArray)
        {
            if (![gardeArray containsObject:garde])
            {
                [gardeArray addObject:garde];
            }
        }
    }
    
    [gardeArray addObject:scroe.text];
    
    [defaults setObject:gardeArray forKey:HISTORYGARDE];
    
    [defaults synchronize];
}
#pragma mark - 创建保存历史分数的数组
- (NSMutableArray *)gardeArrayMethod
{
    static NSMutableArray * gardeArray = nil;
    
    if (!gardeArray)
    {
        gardeArray = [[NSMutableArray alloc]init];
    }
    return gardeArray;
}

#pragma mark - 取得前三名的排行
- (void)setTopThreeGarde:(NSMutableArray *)gardeArray
{
    
    [topThreeGarde removeAllObjects];
    

    
    NSLog(@"%@",gardeArray);

    for (int i = 0; i < 3; i++)
    {
        if (gardeArray.count == 0)//移除分数记录可能导致数组越界,下面的比较语句是建立在gardeArray有分数的前提之下,所以为了确保数组不是没有数据,添加了该语句,感觉有点笨..
        {
            [gardeArray addObject:@"0"];
            [gardeArray addObject:@"0"];
        }
        NSString * temp = [gardeArray objectAtIndex:0];
        
        for(int j = 1;j < gardeArray.count; j++)
        {
            if ([self comapreNumber:temp withString:[gardeArray objectAtIndex:j]])
            {
                temp = [gardeArray objectAtIndex:j];
            }
        }
        [topThreeGarde addObject:temp];
        [gardeArray removeObject:temp];
    }
    //只记录前三名的成绩
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HISTORYGARDE];
    
    [[NSUserDefaults standardUserDefaults] setObject:topThreeGarde forKey:HISTORYGARDE];
}
#pragma mark - 数字字符串比较函数(不可使用系统自带的字符串比较函数)
- (NSComparisonResult)comapreNumber:(NSString *)number1 withString:(NSString *)number2
{
    if ([number1 length]<[number2 length]) {
        return NSOrderedDescending;//交换排序
    }
    else if ([number1 length]>[number2 length])
    {
        return NSOrderedSame;//不采取交换
    }
    if ([number2 compare:number1] == NSOrderedDescending) {//如果两字符串数字长度相同,且number2比number1大,则排序
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

#pragma mark - 删除历史记录
- (void)deleteHistoryScroe
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HISTORYGARDE];
    
    topThreeView.topOne.text = [NSString stringWithFormat:@"第一名:0"];
    topThreeView.topTwo.text = [NSString stringWithFormat:@"第二名:0"];
    topThreeView.topThree.text = [NSString stringWithFormat:@"第三名:0"];
}
@end
