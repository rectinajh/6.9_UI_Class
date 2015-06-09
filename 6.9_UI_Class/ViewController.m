//
//  ViewController.m
//  6.9_UI_Class
//
//  Created by rimi on 15/6/9.
//  Copyright (c) 2015年 rectinajh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property(nonatomic ,strong)NSMutableArray      *imageArray; //图片数组
@property(nonatomic, strong)UIScrollView        *scollView; //滚动视图

- (void)initializeUserInterface;
- (void)initializeDatasource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDatasource];
    [self initializeUserInterface];
}
//初始化数据
- (void)initializeDatasource
{
    //初始化数组
    self.imageArray = [NSMutableArray array];
    //循环添加图片
    for (int i = 0; i < 5; i ++) {
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
    //2.1 设置内容大小
    _scollView.contentSize = CGSizeMake(5 * width, height);
    
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
    for (int i = 0; i <self.imageArray.count; i ++) {
        //3.1创建imageview
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        //3.2关联图片
        imageview.image = self.imageArray[i];
        //3.3添加到scollview上
        [_scollView addSubview:imageview];
        //3.4设置图片缩放方式
        imageview.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    //4,添加到父视图
    [self.view addSubview:_scollView];


}
#pragma mark - UIScollView方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
