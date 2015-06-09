//
//  DetailViewController.m
//  6.9_UI_Class
//
//  Created by rimi on 15/6/9.
//  Copyright (c) 2015年 rectinajh. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UIScrollViewDelegate>

@property(nonatomic ,strong)NSMutableArray      *imageArray; //图片数组
@property(nonatomic, strong)UIScrollView        *scollView; //滚动视图

@property(nonatomic, assign)NSInteger           currentIndex; //当前图片显示下标
@property(nonatomic, strong)NSMutableArray      *imageViewArray; //图片视图数组
@property(nonatomic ,strong)UIPageControl       *pageControl;//小圆点


- (void)initializeUserInterface;
- (void)initializeDatasource;

- (void)pageLeft;
- (void)pageRight;
- (void)dynamicLoadingImage;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeDatasource];
    [self initializeUserInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化数据
- (void)initializeDatasource
{
    //初始化数组
    self.imageArray = [NSMutableArray array];
    self.imageViewArray = [NSMutableArray array];
    //循环添加图片
    for (int i = 0; i < 8; i ++) {
        NSLog(@"%@",[NSBundle mainBundle]);
        //2.1 获取图片名字
        NSString *imageName = [NSString stringWithFormat:@"%d.png",i];
        //2.2 获取图片的完整路径
        NSString *path = [[NSBundle mainBundle]pathForAuxiliaryExecutable:imageName];
        //2.3 通过路径获取图片
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        //2.4 添加图片到数组里面
        [self.imageArray addObject:image];
    }
    
}
//初始化界面
- (void)initializeUserInterface
{
    //0.设置自动调整scollview边界值
    self.automaticallyAdjustsScrollViewInsets = NO;
    //1,创建scollview
    self.scollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //2, 获取滚动视图的宽高
    CGFloat width = CGRectGetWidth(self.scollView.bounds);
    CGFloat height = CGRectGetHeight(self.scollView.bounds);
    //设置属性
    //2.1 设置内容大小(8改为3)
    _scollView.contentSize = CGSizeMake(3 * width, height);
    
    //2.2添加分页效果
    _scollView.pagingEnabled = YES;
    //2.3设置横向指示条是否显示
    _scollView.showsHorizontalScrollIndicator = YES;
    //2.4设置纵向指示条是否显示
    _scollView.showsVerticalScrollIndicator = YES;
    //2.5设置代理
    _scollView.delegate = self;
    
#pragma mark - UIScollViewDelegate方法
    //3 关联子视图
    for (int i = 0; i <3; i ++) {
        //3.1创建imageview
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        //3.2关联图片
        imageview.image = self.imageArray[i];
        //3.3添加到scollview上
        [_scollView addSubview:imageview];
        //3.4设置图片缩放方式
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        
        //3.5 添加到图片视图数组中
        [self.imageViewArray addObject:imageview];
    }
    
    //4,添加到父视图
    [self.view addSubview:_scollView];
    
    // 循环滚动步骤
    // 1,改变UIImageView的数量(3),并且内容视图为3 * width
    // 2,设置scrollView的偏移量（width，0）
    // 3,创建imageView数组，用以获取imageView
    // 4,根据下标动态的设置正确的视图
    self.scollView.contentOffset = CGPointMake(width, 0);
    
    self.currentIndex = 0;
    // 正确调整位置
    [self dynamicLoadingImage];
    
    // 5. 创建pageControl
    self.pageControl = [[UIPageControl alloc]init];
    // 5.1 设置大小
    _pageControl.bounds = CGRectMake(0, 0, 300, 30);
    // 5.2 设置中心点
    _pageControl.center = CGPointMake(width / 2, 450);
    // 5.2 设置背景颜色
    _pageControl.pageIndicatorTintColor = [UIColor redColor];
    // 5.3 设置当前指示器颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    // 5.4 当前数量
    _pageControl.numberOfPages = self.imageArray.count;
    // 5.5 设置当前下标
    _pageControl.currentPage =self.currentIndex;
    // 5.6 添加到父视图
    [self.view addSubview:_pageControl];
}
#pragma mark - UIScollViewDelegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    //偏移量 《=0说明用户滑动界面在左边的位置
    //偏移量  》=2 * width说明用户滑动界面在右边位置
    
    if (scrollView.contentOffset.x <= 0) {
        [self pageLeft];
        
    }else if (scrollView.contentOffset.x >= 2 * CGRectGetWidth(scrollView.bounds)) {
        [self pageRight];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s",__func__);
}

#pragma mark - 循环滚动逻辑
- (void)pageLeft
{
    _currentIndex = (--_currentIndex + self.imageArray.count) % self.imageArray.count;
    
    [self dynamicLoadingImage];
    
}

- (void)pageRight
{
    _currentIndex = (++_currentIndex + self.imageArray.count) % self.imageArray.count;
    [self dynamicLoadingImage];
}

- (void)dynamicLoadingImage
{
    //1，设置当前pageControl下标
    self.pageControl.currentPage = self.currentIndex;
    //2, 循环配置图片
    for (int i = -1; i < 1; i ++) {
        //获取当前正确的下标
        // 7:(-1+8) % 8;    0:(8 % 8)  1:(1 + 8) % 8
        NSInteger index = (_currentIndex + i + _imageArray.count) % _imageArray.count;
        //取出相应地imageview
        UIImageView *imageView = self.imageViewArray[i + 1];
        //进行图片关联
        imageView.image = self.imageArray[index];
    }
    // 将偏移量返回
    [self.scollView setContentOffset:CGPointMake(CGRectGetWidth(_scollView.bounds), 0) animated:NO];

}

@end
