//
//  ViewController.m
//  lianxi
//
//  Created by ekhome on 16/11/28.
//  Copyright © 2016年 xiaofei. All rights reserved.
//
#define naview @"naviView"
#import "ViewController.h"
#import "TableViewCellone.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIDynamicAnimatorDelegate,UICollisionBehaviorDelegate>
{
    naviView *navi;
    UILabel  *lab;
    UITableView *tableView;
    UIWebView *imageWebView;
    BOOL isrefresh;
    BOOL INrefresh;
    BOOL isshifang;
    UIView *view;
    NSInteger num;
    
    
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *frontFillLayer;      //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
    UIView *ballItem; //动力效果元素
    
    
}


@property(nonatomic,strong) UIDynamicAnimator *animator;
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate= self;
    tableView.dataSource = self;
    lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-20, -20, 90, 20)];
    view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 90)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    isrefresh = NO;
    isshifang = NO;
    INrefresh = NO;
    num = 3;
    frontFillLayer  = [[CAShapeLayer alloc]init];
    frontFillBezierPath = [[UIBezierPath alloc]init];
    backGroundLayer = [CAShapeLayer layer];
    backGroundBezierPath = [UIBezierPath bezierPath];
//    球
    ballItem = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    ballItem.backgroundColor = [UIColor blackColor];
    ballItem.layer.cornerRadius = 10;
    ballItem.center = CGPointMake(self.view.frame.size.width/2.0, 0);
    [self.view addSubview:ballItem];
}


- (void)gravity{
    //移除之前的效果
    [self.animator removeAllBehaviors];
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[ballItem]];
    /*
     CGVector 表示方向的结构体
     CGFloat dx : X轴的方向
     CGFloat dy : Y轴的方向
     
     gravityDirection 默认是（0.0,1.0）向下每秒下降1000个像素点 受其他因素的影响（加速度 弧度）
     */
    gravity.gravityDirection = CGVectorMake(0.0, 1.0);
    
    //会影响到重力的方向
//     gravity.angle = 30*M_PI/180;
    //magnitude 会影响到下降的速度
//    gravity.magnitude = 100;
    //把重力效果添加到动力效果的操纵者上
    [self.animator addBehavior:gravity];
    
    
    
}


- (void)collision{
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[ballItem]];
    //设置 检测碰撞的模式
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    
    //以参照视图为边境范围
      collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.view.frame.size.width, 0) controlPoint:CGPointMake(self.view.frame.size.width/2, 115)];
    //    重力行为随着画的弧线的轨迹 如果重力作用对象放在在圆里面将只会在里面 反之将会随着圆弧掉落
//    [collisionBehavior addBoundaryWithIdentifier:@"round" forPath:path];
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    

}
-(UIDynamicAnimator *)animator{
    if (_animator) {
        return _animator;
    }
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _animator.delegate = self;
    
    return _animator;
}
-(void)shownavi{
    navi = [[NSBundle mainBundle] loadNibNamed:naview owner:self options:nil].firstObject;
    [self.view addSubview:navi];
    navi.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    navi.title.text = @"这是假的导航条";
    navi.title.textColor  = [UIColor blackColor];
    navi.backgroundColor = [UIColor orangeColor];
}

#pragma -mark       UITableViewDelegate  UItableViewDataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return num;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellone *cell;
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TableViewCellone" owner:self options:nil].firstObject;
    }
    return cell;
}








-(void)regisNaib{
    [tableView registerClass:[TableViewCellone class] forHeaderFooterViewReuseIdentifier:@"tableViewone"];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!(scrollView.contentOffset.y <= -90))
    {
        
    }else{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 90)];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
    }
    NSLog(@"%lf",scrollView.contentOffset.y);
    [backGroundBezierPath removeAllPoints];
    [backGroundLayer removeFromSuperlayer];
    CGPoint starPoint = CGPointMake(-20, 20);
    [backGroundBezierPath moveToPoint:starPoint];
    [backGroundBezierPath addQuadCurveToPoint:CGPointMake(self.view.frame.size.width+20, 20) controlPoint:CGPointMake(self.view.frame.size.width/2, -scrollView.contentOffset.y+44)];
    backGroundLayer.path = backGroundBezierPath.CGPath;
    backGroundLayer.fillColor = [UIColor redColor].CGColor;
    frontFillLayer.frame = self.view.bounds;
    backGroundLayer.strokeColor = [UIColor blackColor].CGColor;
    [view.layer addSublayer:backGroundLayer];
    
    [lab removeFromSuperview];
    [scrollView addSubview:lab];
    if(scrollView.contentOffset.y < -60&&!isshifang)
    {
        lab.text = @"释放刷新";
        lab.textColor = [UIColor orangeColor];
        
        [lab sizeToFit];
        NSLog(@"%@",lab.text);
    }else if(scrollView.contentOffset.y >= -90){
        
        if (isrefresh == YES)
        {
            
        }else{
            if (isshifang)
            {
                lab.text = @"正在刷新";
                lab.textColor = [UIColor orangeColor];
                [lab sizeToFit];
                [self setAnimatation:scrollView];
                [self gravity];
                [self collision];
            }
          
        }
    }else if (scrollView.contentOffset.y<-40&&!isshifang)
    {
        lab.text = @"这是测试用的";
        lab.textColor = [UIColor orangeColor];
        [lab sizeToFit];
    }
    if (INrefresh)
    {
        [scrollView setContentOffset:CGPointMake(0, -90) animated:NO];
        INrefresh = NO;
    }
    
    if (scrollView.contentOffset.y == 0){
        [imageWebView removeFromSuperview];
        [backGroundBezierPath removeAllPoints];
        [backGroundLayer removeFromSuperlayer];
        isrefresh = NO;
        [view removeFromSuperview];
        view = nil;
        isshifang = NO;
    }
    
}
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"1111111111");
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    INrefresh = YES;
    isshifang = YES;
}


-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidZoom");
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScrollToTop");
}

-(void)endRefrsh:(UIScrollView *)sender{

        [sender setContentOffset:CGPointMake(0, 0) animated:YES];
    tableView.contentOffset = CGPointMake(0, 20);
    [imageWebView removeFromSuperview];
    [backGroundBezierPath removeAllPoints];
    [backGroundLayer removeFromSuperlayer];
    isrefresh = NO;
    [view removeFromSuperview];
    view = nil;
    isshifang = NO;
    num = random()%100+1;
    [tableView reloadData];
}



-(void)setAnimatation:(UIScrollView *)sender{
    isrefresh = YES;
   

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefrsh:sender];
    });
    
    
    
}


@end
