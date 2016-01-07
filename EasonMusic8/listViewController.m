//
//  ViewController.m
//  EasonMusic8
//
//  Created by qingyun on 15/12/10.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "listViewController.h"
#import "songsModel.h"
#import "songlistTableViewCell.h"
#import "resultTableViewController.h"
#import "songplayViewController.h"

#define QYScreenW [UIScreen mainScreen].bounds.size.width

@interface listViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) songplayViewController *playViewController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation listViewController
static NSString *identifier = @"songCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self addSubViewsForTableView:_tableView];
    _playViewController = [[songplayViewController alloc] init];
    _songs = [NSMutableArray arrayWithArray:_playViewController.mutableArray];
    NSLog(@"%@",_songs);
    
}
//设置tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100,375, 567) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    _tableView = tableView;
    //设置数据源和代理
    tableView.dataSource = self;
    tableView.delegate = self;
    //注册单元格
    [tableView registerNib:[UINib nibWithNibName:@"songlistTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    //设置行高
    tableView.rowHeight = 40;
    UIImageView *bgimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eason红玫瑰.jpg"]];
    tableView.backgroundView = bgimageView;
}


/*
- (void)setSearchBarForTableHeaderView
{
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    _searchController.searchResultsUpdater = self;
    self.tableView.tableHeaderView = _searchController.searchBar;
}

设置导航栏上右边的编辑
-(void)setRightBarButtonItem
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
- (IBAction)searchClick:(UIBarButtonItem *)sender {
    [self presentViewController:_searchController animated:YES completion:nil];
}
*/


//编辑  完成  切换
- (IBAction)editItemClick:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title = @"完成";
        [self.tableView setEditing:YES animated:YES];
    } else {
        sender.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
    }
}

//添加子视图
-(void)addSubViewsForTableView:(UITableView *)tableView{
    //添加表头
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    //设置contentsize
    scrollView.contentSize = CGSizeMake(QYScreenW * 3, 100);
    //分页
    scrollView.pagingEnabled = YES;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(QYScreenW * i, 0, QYScreenW, 100)];
        NSString *imageName = [NSString stringWithFormat:@"mt0%d.jpg",i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
    }
    tableView.tableHeaderView = scrollView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    songlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[songlistTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    songsModel *model = self.songs[indexPath.row];
    cell.songsmodel =  model;
    return cell;
}

#pragma mark -编辑（删除）
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.songs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _listnum = indexPath.row;
    
    NSLog(@"listnu,<%ld> >>>",(long)_listnum);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    //传值跳转到下一个页面
    songplayViewController *svc = [[songplayViewController alloc] init];
    _playViewController = svc;
    [_playViewController setValue:@(indexPath.row) forKey:@"playnum"];
    
    [self.navigationController pushViewController:_playViewController animated:YES];
    
}

@end
