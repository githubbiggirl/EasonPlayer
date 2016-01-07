//
//  songplayViewController.h
//  EasonMusic8
//
//  Created by qingyun on 15/12/11.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "songsModel.h"
@interface songplayViewController : UIViewController
@property (nonatomic, strong) UILabel *nameLabel;//放歌名的label
@property (nonatomic, strong) UILabel *singerName;//歌手名
@property (nonatomic, strong) UILabel *albumName;//专辑名称
@property (nonatomic, strong) UIImageView *iconimageView;//歌手图片
@property (nonatomic) NSInteger  playnum;//数组索引

@property (nonatomic, strong) UIButton *playBtn;//播放按钮
@property (nonatomic, strong) UITableView *tableView;//放歌词的view
@property (nonatomic, strong) songsModel *smodel;
@property (nonatomic, strong) NSMutableArray *mutableArray;

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIButton *slider;
@property (nonatomic, strong) UILabel *songTime;
@property (nonatomic, strong) UIButton *lrcORphotoBtn;

@end
