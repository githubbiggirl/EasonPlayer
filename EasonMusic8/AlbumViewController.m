//
//  AlbumViewController.m
//  EasonMusic8
//
//  Created by qingyun on 15/12/14.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "AlbumViewController.h"
#import "EasonScrollView.h"

#define kScreenW    [UIScreen mainScreen].bounds.size.width
#define kScreenH    [UIScreen mainScreen].bounds.size.height
#define imageViewCount 5


@interface AlbumViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation AlbumViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"美图";
    [self setupScrollView];
    [self addSubScrollViews];
    
    
}

- (void)setupScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW + 30, kScreenH)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake((kScreenW + 30) * imageViewCount, kScreenH);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
}

- (void)addSubScrollViews
{
    for (int i = 0; i < imageViewCount; i++) {
        EasonScrollView *imgScrollView = [[EasonScrollView alloc] initWithFrame:CGRectMake(i*(kScreenW+30), 0, kScreenW, kScreenH)];
        NSString *imageName = [NSString stringWithFormat:@"Eason%d.jpg",i+1];
        imgScrollView.imageView.image = [UIImage imageNamed:imageName];
        [_scrollView addSubview:imgScrollView];
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UIScrollView *sView in _scrollView.subviews) {
        if ([sView isKindOfClass:[UIScrollView class]]) {
            sView.zoomScale = 1.0;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
