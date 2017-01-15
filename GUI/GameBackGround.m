//
//  GameBackGround.m
//  2048游戏
//
//  Created by ZH on 16/1/27.
//  Copyright © 2016年 ZKW. All rights reserved.
//

#import "GameBackGround.h"
#import "DataModel.h"
#import "UIColor+ColorWithNumber.h"

@implementation GameBackGround


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadGameView:frame];
        _noNumberBlockLocation = [[NSMutableArray alloc]init];
        [self initNumberValueDistribution];
        self.backgroundColor = [UIColor lightGrayColor];
        //第一次需要出现两个方块
        [self loadNumberOnTheGameBoard];
        [self loadNumberOnTheGameBoard];
    }
    return self;
}

#pragma mark - 加载游戏底部视图
- (void)loadGameView:(CGRect)frame
{
    self.layer.cornerRadius = 5;
    for (int i = 0; i < ROW; i++)
    {
        for (int j = 0; j < COLUMNN; j++)
        {
            CGFloat x = LENTHOFINTERVAL + j*(LENTHOFBLOCK + LENTHOFINTERVAL);
            
            CGFloat y = ( i*4 + j)/4*(LENTHOFBLOCK + LENTHOFINTERVAL) + LENTHOFINTERVAL;
            
            blockCenterLocationX[i][j] = x+LENTHOFBLOCK/2.0;
            
            blockCenterLocationY[i][j] = y+LENTHOFBLOCK/2.0;
            
            UIView * blockView = [[UIView alloc]initWithFrame:CGRectMake(x, y, LENTHOFBLOCK, LENTHOFBLOCK)];
            
            blockView.layer.cornerRadius = 3;
            
            blockView.backgroundColor = [UIColor colorWithNumber:0];
            
            [self addSubview:blockView];
        }
    }
}

#pragma mark - 加载游戏方块,值为2或者4(游戏开始的时候需要加载两次)
- (void)loadNumberOnTheGameBoard
{
    NSString * randomNumber;
    //产生2或4的随机Block,由于2出现的概率比较大,so....
    if (arc4random()%5==4)
    {
        randomNumber = @"4";
    }
    else
    {
        randomNumber = @"2";
    }
    //游戏结束的判定(这个判定是不正确的,不过不想改了)
    if ([_noNumberBlockLocation count] == 0)
    {
        UIView * endView = [[UIView alloc]initWithFrame:self.bounds];
        
        endView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:248.0/255.0 blue:239.0/255.0 alpha:0.3];
        
        [self addSubview:endView];
        return;
    }
    
    int random = arc4random()%[_noNumberBlockLocation count];
    
    CGPoint randomEmptyLocation = CGPointFromString(_noNumberBlockLocation[random]);
    
    CGFloat x = blockCenterLocationX[(int)randomEmptyLocation.x][(int)randomEmptyLocation.y];
    CGFloat y = blockCenterLocationY[(int)randomEmptyLocation.x][(int)randomEmptyLocation.y];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 0, 0)];
    
    label.tag = (int)randomEmptyLocation.x*4 + randomEmptyLocation.y +1;
    
    label.backgroundColor = [UIColor colorWithNumber:[randomNumber intValue]];
    
    [label setText:randomNumber];
    
    [label setTextColor:[UIColor whiteColor]];
    
    label.font = [UIFont boldSystemFontOfSize:25];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.layer.cornerRadius = 3;
    
    label.layer.masksToBounds = YES;
    
    [UIView animateWithDuration:0.25f animations:^{
        label.frame = CGRectMake(x-LENTHOFBLOCK/2.0, y-LENTHOFBLOCK/2.0, LENTHOFBLOCK, LENTHOFBLOCK);
    }];
    
    [self addSubview:label];
    //设置新的数值分布
    numberValueDistribution[(int)randomEmptyLocation.x][(int)randomEmptyLocation.y] = [randomNumber intValue];
    
    //将拥有方块的位置从数组中移除
    [_noNumberBlockLocation removeObjectAtIndex:random];
    
}
#pragma mark - 添加新的数值方块
- (void)addNewBlock
{
    [self loadNumberOnTheGameBoard];
}

#pragma mark - 初始化数值(每个Block单前存放的数字)分布0表示这个块上当前没有存放任何数值
- (void)initNumberValueDistribution
{
    
    for (int i = 0; i < ROW; i++)
    {
        for (int j = 0; j< COLUMNN; j++)
        {
            CGPoint exmptyBlockIndex;
            exmptyBlockIndex.x = i;
            exmptyBlockIndex.y = j;
            numberValueDistribution[i][j] = 0;
            [_noNumberBlockLocation addObject:NSStringFromCGPoint(exmptyBlockIndex)];
            [self addSwipeGesture];
        }
    }
}

#pragma mark - 给游戏添加上下左右滑动手势
- (void)addSwipeGesture
{
    UISwipeGestureRecognizer * swipeGesture;
    //上
    swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipeGesture];
    //下
    swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:swipeGesture];
    //左
    swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeGesture];
    //右
    swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self addGestureRecognizer:swipeGesture];
    
}


- (void)swipeUp:(UISwipeGestureRecognizer *)swipe
{
    [self beforeMoveNumberDistribute];
    //这四个值分别记录靠近底部的地方有多少个空的Block
    for (int i = 0; i < COLUMNN; i++)
    {
        emptyColumnn[i] = 0;
    }
    
    for (int i = 0; i < ROW; i++)
    {
        for (int j = 0; j < COLUMNN; j++)
        {
            if (numberValueDistribution[i][j] == 0)
            {
                emptyColumnn[j]++;
            }
            
            if (numberValueDistribution[i][j]&&emptyColumnn[j])
            {
                UILabel * label = (UILabel *)[self viewWithTag:i*4+j+1];
                
                label.tag = label.tag - emptyColumnn[j]*4;
                numberValueDistribution[i][j] = 0;//移动后的位置要置0
                numberValueDistribution[i-emptyColumnn[j]][j] = (int)[label.text integerValue];//将要移动到的位置我们要置相应的数值
                //将将要移动的位置进行回收
            }
        }
    }
    
    [self combineBlock:swipe.direction];
}

- (void)swipeDown:(UISwipeGestureRecognizer *)swipe
{
    [self beforeMoveNumberDistribute];
    for (int i = 0; i < COLUMNN; i++)
    {
        emptyColumnn[i] = 0;
    }
    
    for (int i = ROW - 1; i >= 0 ; i--)
    {
        for (int j = 0; j < COLUMNN; j++)
        {
            if (numberValueDistribution[i][j] == 0)
            {
                emptyColumnn[j]++;
            }
            
            if (numberValueDistribution[i][j]&&emptyColumnn[j])
            {
                UILabel * label = (UILabel *)[self viewWithTag:i*4+j+1];
                
                label.tag = label.tag + emptyColumnn[j]*4;
                
                numberValueDistribution[i][j] = 0;//移动后的位置要置0
                
                numberValueDistribution[i+emptyColumnn[j]][j] = [label.text intValue];//将要移动到的位置我们要置相应的数值
                
            }
            
        }
        
    }
    [self combineBlock:swipe.direction];
}


- (void)swipeLeft:(UISwipeGestureRecognizer *)swipe
{
    [self beforeMoveNumberDistribute];
    //水平方向有多少个个空的Block
    for (int i = 0; i < ROW; i++)
    {
        emptyRow[i] = 0;
    }
    
    for (int i = 0; i < COLUMNN; i++)
    {
        for (int j = 0; j < ROW; j++)
        {
            if (numberValueDistribution[j][i] == 0)
            {
                emptyRow[j]++;
            }
            
            if (numberValueDistribution[j][i]&&emptyRow[j])
            {
                UILabel * label = (UILabel *)[self viewWithTag:j*4+i+1];
                label.tag = label.tag - emptyRow[j];
                
                numberValueDistribution[j][i] = 0;//移动后的位置要置0
                numberValueDistribution[j][i-emptyRow[j]] = [label.text intValue];//将要移动到的位置我们要置相应的数值
            }
        }
    }
    
    [self combineBlock:swipe.direction];

}


- (void)swipeRight:(UISwipeGestureRecognizer *)swipe
{
    [self beforeMoveNumberDistribute];
    for (int i = 0; i < ROW; i++)
    {
        emptyRow[i] = 0;
    }
    
    for (int i = COLUMNN - 1; i >= 0; i--)
    {
        for (int j = 0; j < ROW; j++)
        {
            if (numberValueDistribution[j][i] == 0)
            {
                emptyRow[j]++;
            }
            
            if (numberValueDistribution[j][i]&&emptyRow[j])
            {
                
                UILabel * label = (UILabel *)[self viewWithTag:j*4+i+1];
                
                label.tag = label.tag + emptyRow[j];
                numberValueDistribution[j][i] = 0;//移动后的位置要置0
                numberValueDistribution[j][i+emptyRow[j]] = [label.text intValue];//将要移动到的位置我们要置相应的数值
            }
        }
    }
    
    [self combineBlock:swipe.direction];
    //要等移动结束后才能添加新的非空(带有数字)Block
}

- (void)beforeMoveNumberDistribute
{
    for (int i = 0; i < ROW; i++)
    {
        for (int j = 0; j < COLUMNN; j++)
        {
            currentNumberDistribution[i][j] = numberValueDistribution[i][j];
        }
    }
}

- (BOOL)isLegalMove
{
    BOOL isLegal = NO;
    for (int i = 0; i < ROW; i++)
    {
        for (int j = 0; j < COLUMNN; j++)
        {

            if (currentNumberDistribution[i][j]!=moveandCombineArray[i][j]) {
                NSLog(@"nohaoa");
                isLegal = YES;
                break;
            }
            
        }
        if (isLegal) {
            break;
        }
    }

    return isLegal;
}

#pragma mark - 通过遍历移动后的数组(Label的物理位置我们不要改动)对数字进行合并,大大简化了编程难度,我们只要对数组内的Label进行移动即可
- (void)combineBlock:(UISwipeGestureRecognizerDirection)swipDirection
{
    moveAndCombineArrayMethod(numberValueDistribution, swipDirection);

    if (![self isLegalMove]) {
        return;
    }
    if (swipDirection == UISwipeGestureRecognizerDirectionUp)
    {
        [self combineUp];
    }
    else if (swipDirection == UISwipeGestureRecognizerDirectionDown)
    {
        [self combineDown];
    }
    else if (swipDirection == UISwipeGestureRecognizerDirectionLeft)
    {
        [self combineLeft];
    }
    else
    {
        [self combineRight];
    }
    
    //重新布局
    [self performSelector:@selector(addNewBlock) withObject:nil afterDelay:0.17];
    [self performSelector:@selector(newLayOut) withObject:nil afterDelay:0.16];
}

/**向上合并*/
- (void)combineUp
{
    for (int i = 0; i < ROW; i++)
    {
        int successCount = 0;
        
        for (int j = 0; j < COLUMNN; j++)
        {
            if (moveandCombineArray[j-successCount][i]!=numberValueDistribution[j][i])//从不相等开始合并
            {
                UILabel * label1 = [self getLabelWithTag:j*4+i+1];
                UILabel * label2 = [self getLabelWithTag:j*4+i+5];
                
                CGFloat x = blockCenterLocationX[j][i];
                CGFloat y = blockCenterLocationY[j][i];
                
                CGPoint location = CGPointMake(x, y-successCount*MOVEINTERVAL);
                
                int tag = (j-successCount)*4+i+1;
                
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    label1.center = location;
                    label2.center = location;
                    
                } completion:^(BOOL finished) {
                    
                    [self setLabelNumberWithTag:label1.tag removeLabelWIthTag:label2.tag];
                    //这里有一个值得关注的地方就是我们在动画完成后才会移除label2,而此时如果如果label2下方还有一个label,它会立即将tag值变得和label2一样,所以我们在else中执行的tag复制语句,一定要添加延迟
                    
                    [self changeLabel:label1 TagValue:tag];
                }];
                
                j++;
                successCount++;
                [_delegate setNewScroe:[label1.text intValue]];
            }
            else
            {
                UILabel * label1 = [self getLabelWithTag:j*4+i+1];
                
                if (label1 == nil)
                {
                    continue;
                }
                
                CGFloat x = blockCenterLocationX[j][i];
                CGFloat y = blockCenterLocationY[j][i];
                
                //label1.tag = (j-successCount)*4+i+1;(原本此句子放在此处,怎么调也调不出来(该label会莫名消失),后来才想起有一个上面动画延迟,在动画没有执行完毕,词句赋值将会导致该label和label2一样被移除掉!!!
                int tag = (j-successCount)*4+i+1;
                CGPoint location = CGPointMake(x, y-successCount*MOVEINTERVAL);
                
                NSLog(@"successCount:%d",successCount);
                
                NSLog(@"%@",NSStringFromCGPoint(location));
                
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    label1.center = location;
                    
                } completion:^(BOOL finished) {
                    [self changeLabel:label1 TagValue:tag];
                }];
            }
        }
    }

}
/**向下合并*/
-(void)combineDown
{
    for (int i = 0; i < ROW; i++)
    {
        int successCount = 0;
        for (int j = COLUMNN - 1; j >=0; j--)
        {
            if (moveandCombineArray[j+successCount][i]!=numberValueDistribution[j][i])//从不相等开始合并
            {
                UILabel * label1 = [self getLabelWithTag:j*4+i+1];
                UILabel * label2 = [self getLabelWithTag:j*4+i+1-4];
                NSLog(@"%@ %@",label1.text,label2.text);
                CGFloat x = blockCenterLocationX[j][i];
                CGFloat y = blockCenterLocationY[j][i];
                
                CGPoint location = CGPointMake(x, y+successCount*MOVEINTERVAL);

                int tag = (j+successCount)*4+i+1;
                
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    label1.center = location;
                    label2.center = location;
                    
                } completion:^(BOOL finished) {
                    
                    [self setLabelNumberWithTag:label1.tag removeLabelWIthTag:label2.tag];
                    [self changeLabel:label1 TagValue:tag];
                }];
                
                j--;
                successCount++;
                [_delegate setNewScroe:[label1.text intValue]];
            }
            else
            {
                UILabel * label1 = [self getLabelWithTag:j*4+i+1];
                if (label1 == nil)
                {
                    continue;
                }
                CGFloat x = blockCenterLocationX[j][i];
                CGFloat y = blockCenterLocationY[j][i];
                
                CGPoint location = CGPointMake(x, y+successCount*MOVEINTERVAL);
                
                int tag = (j+successCount)*4+i+1;
                
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    label1.center = location;
                    
                } completion:^(BOOL finished) {
                    [self changeLabel:label1 TagValue:tag];
                }];
            }
        }
    }

}
/**向左合并*/
- (void)combineLeft
{
    for (int i = 0; i < ROW; i++)
    {
        int successCount = 0;
        for (int j = 0; j < COLUMNN; j++)
        {
            if (moveandCombineArray[i][j-successCount]!=numberValueDistribution[i][j])//从不相等开始合并
            {
                
                UILabel * label1 = [self getLabelWithTag:i*4+j+1];
                UILabel * label2 = [self getLabelWithTag:i*4+j+1+1];
                
                NSLog(@"%@ %@",label1.text,label2.text);
                
                CGFloat x = blockCenterLocationX[i][j];
                CGFloat y = blockCenterLocationY[i][j];
                
                CGPoint location = CGPointMake(x-successCount*MOVEINTERVAL, y);
                
                int tag = i*4+j+1-successCount;
                
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    label1.center = location;
                    label2.center = location;
                    
                } completion:^(BOOL finished) {
                    [self setLabelNumberWithTag:label1.tag removeLabelWIthTag:label2.tag];
                    [self changeLabel:label1 TagValue:tag];
                }];
                
                j++;
                successCount++;
                [_delegate setNewScroe:[label1.text intValue]];
            }
            else
            {
                UILabel * label1 = [self getLabelWithTag:i*4+j+1];
                if (label1 == nil)
                {
                    continue;
                }
                CGFloat x = blockCenterLocationX[i][j];
                CGFloat y = blockCenterLocationY[i][j];
                
                int tag = i*4+j+1-successCount;
                
                CGPoint location = CGPointMake(x-successCount*MOVEINTERVAL, y);
                
                NSLog(@"successCount:%d",successCount);
                NSLog(@"%@",NSStringFromCGPoint(location));
                
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    label1.center = location;
                    
                } completion:^(BOOL finished) {
                    [self changeLabel:label1 TagValue:tag];
                }];
                
            }
        }
    }

}
/**向左合并*/
- (void)combineRight
{
    for (int i = 0; i < ROW; i++)
    {
        int successCount = 0;
        for (int j = COLUMNN - 1; j >=0; j--)
        {
            if (moveandCombineArray[i][j+successCount]!=numberValueDistribution[i][j])
            {
                UILabel * label1 = [self getLabelWithTag:i*4+j+1];
                UILabel * label2 = [self getLabelWithTag:i*4+j+1-1];
                
                NSLog(@"%@ %@",label1.text,label2.text);
                
                CGFloat x = blockCenterLocationX[i][j];
                CGFloat y = blockCenterLocationY[i][j];
                
                CGPoint location = CGPointMake(x+successCount*MOVEINTERVAL, y);
                
                int tag = i*4+j+1+successCount;
                
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    label1.center = location;
                    label2.center = location;
                    
                } completion:^(BOOL finished) {
                    [self setLabelNumberWithTag:label1.tag removeLabelWIthTag:label2.tag];
                    
                    [self changeLabel:label1 TagValue:tag];
                    
                }];
                j--;
                successCount++;
                [_delegate setNewScroe:[label1.text intValue]];
            }
            else
            {
                UILabel * label1 = [self getLabelWithTag:i*4+j+1];
                if (label1 == nil)
                {
                    continue;
                }
                CGFloat x = blockCenterLocationX[i][j];
                CGFloat y = blockCenterLocationY[i][j];
                
                int tag = i*4+j+1+successCount;
                
                CGPoint location = CGPointMake(x+successCount*MOVEINTERVAL, y);
                
                [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    label1.center = location;
                    
                } completion:^(BOOL finished) {
                    [self changeLabel:label1 TagValue:tag];
                }];
            }
        }
    }

}

- (void)changeLabel:(UILabel *)label TagValue:(int)tag
{
    label.tag = tag;
}

#pragma mark - 修改block数字,并删除合并后的第二个Label

- (void)setLabelNumberWithTag:(NSInteger)tag1 removeLabelWIthTag:(NSInteger)tag2
{
    UILabel * label1 = [self getLabelWithTag:(int)tag1];
    
    label1.text=[NSString stringWithFormat:@"%d",[label1.text intValue]*2];
    
    label1.backgroundColor = [UIColor colorWithNumber:[label1.text intValue]];
    
    UILabel * label2 = [self getLabelWithTag:(int)tag2];

    [label2 removeFromSuperview];
    
}

#pragma mark - 重新布局

- (void)newLayOut
{
    [_noNumberBlockLocation removeAllObjects];
    
    for (int i = 0; i < ROW ; i++)
    {
        for (int j = 0; j < COLUMNN; j++)
        {
            numberValueDistribution[i][j] = moveandCombineArray[i][j];
            if (numberValueDistribution[i][j] == 0)
            {
                CGPoint exmptyBlockIndex;
                exmptyBlockIndex.x = i;
                exmptyBlockIndex.y = j;
                [_noNumberBlockLocation addObject:NSStringFromCGPoint(exmptyBlockIndex)];
            }
        }
    }
}

#pragma mark - 用tag获得label

- (UILabel *)getLabelWithTag:(int)tag
{
    UILabel * label = (UILabel *)[self viewWithTag:tag];
    return label;
}


@end

