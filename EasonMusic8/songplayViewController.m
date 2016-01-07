//
//  songplayViewController.m
//  EasonMusic8
//
//  Created by qingyun on 15/12/11.
//  Copyright © 2015年 qingyun. All rights reserved.
//s

#import "songplayViewController.h"
#import "UIView+Extension.h"
#import "songsModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMetadataItem.h>
#import "listViewController.h"

@interface songplayViewController ()<AVAudioPlayerDelegate, UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) AVAudioPlayer *Player;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *lrcView;
@end

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

@implementation songplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    NSLog(@"%ld",(long)_playnum);
    
    [self setplaymusicView];
    [self setupBtns];
    [self AddprogressView];
    [self loadMusic:_smodel.name AndType:@"mp3"];
    
}
//设置播放按钮
- (void)setupBtns
{
    CGFloat space= 80;
    CGFloat width = 40;
    CGFloat height = 40;
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake(KScreenW/2 - width/2, 620, width, height);
    [self.view addSubview:_playBtn];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playSong) forControlEvents:UIControlEventTouchUpInside];

    UIButton *forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardBtn.frame = CGRectMake(space, 620, width, height);
    [self.view addSubview:forwardBtn];
    [forwardBtn setBackgroundImage:[UIImage imageNamed:@"后退.png"] forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(forwardSong) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(KScreenW - space - width, 620, width, height);
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"前进.png"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextSong) forControlEvents:UIControlEventTouchUpInside];
    
    //设置播放背景
    UIImageView *bgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 60)];
    bgView.image = [UIImage imageNamed:@"BG_Img.png"];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
    
}
//添加播放时间
- (void)AddprogressView
{
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenH - 60, 375, 3)];
    [self.view addSubview:_progressView];
    _progressView.backgroundColor = [UIColor yellowColor];
    //时间滑块
    _slider = [[UIButton alloc] initWithFrame:CGRectMake(-2, KScreenH - 70, 40, 20)];
    [self.view addSubview:_slider];
    [_slider setBackgroundImage:[UIImage imageNamed:@"process_thumb@2x"] forState:UIControlStateNormal];
}

//添加定时器
- (void)addCurrentTimer
{
    if (![self.Player isPlaying]) return;
    
        //在新增定时器之前，先移除之前的定时器
    [self removeCurrentTimer];
    [self updateCurrentTimer];
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];

}

//移除定时器
- (void)removeCurrentTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

//触发定时器
- (void)updateCurrentTimer
{
    double temp = self.Player.currentTime / self.Player.duration;
    self.slider.x = temp * (self.view.width - self.slider.width);
    [self.slider setTitle:[self stringWithTime:self.Player.currentTime] forState:UIControlStateNormal];
    [_slider setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _slider.titleLabel.font = [UIFont systemFontOfSize:10 weight:40];
    self.progressView.width = self.slider.center.x;

}

#pragma mark ----私有方法
/**
 *  将时间转化为合适的字符串
 *
 */
- (NSString *)stringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute, second];
}


- (NSMutableArray *)mutableArray
{
    if (_mutableArray == nil) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"EasonMusic" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            songsModel *model = [[songsModel alloc] initWithDictionary:dict];
            [array1 addObject:model];
        }
        _mutableArray = array1;
    }
    return _mutableArray;
}
//配置播放页面
- (void)setplaymusicView
{
    songsModel *songmodel1 = self.mutableArray[_playnum];
    _smodel = songmodel1;
    
    listViewController *num = [[listViewController alloc]init];
    _playnum = num.listnum;
    
    //显示歌名
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130,200,120,20)];
    _nameLabel.textColor = [UIColor redColor];
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];

    //显示歌手
    _singerName = [[UILabel alloc] initWithFrame:CGRectMake(130,230,120, 20)];
    _singerName.textColor = [UIColor yellowColor];
    _singerName.font = [UIFont systemFontOfSize:18];
     _singerName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_singerName];
    //显示专辑名称
    _albumName = [[UILabel alloc] initWithFrame:CGRectMake(90, 260, 210, 20)];
    _albumName.textColor = [UIColor yellowColor];
    _albumName.font = [UIFont systemFontOfSize:15];
    _albumName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_albumName];
    //显示每首歌的封面
    _iconimageView = [[UIImageView alloc] initWithFrame:CGRectMake(100,290, 180, 180)];
    [self.view addSubview:_iconimageView];
    
    //歌曲总时间
    _songTime = [[UILabel alloc]initWithFrame:CGRectMake(335, KScreenH - 55, 40, 20)];
    [self.view addSubview:_songTime];
    _songTime.font = [UIFont systemFontOfSize:12];
    _songTime.textAlignment = NSTextAlignmentCenter;
    [_songTime setTextColor:[UIColor whiteColor]];
    
    //词图转换的按钮
    _lrcORphotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(330, 80, 40, 40)];
    [self.view addSubview:_lrcORphotoBtn];
    [_lrcORphotoBtn setTitle:@"歌词" forState:UIControlStateNormal];
    [_lrcORphotoBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    //lrc的View
    _lrcView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 60)];
    [self.view addSubview:_lrcView];
    _lrcView.backgroundColor = [UIColor clearColor];
    _lrcView.hidden = YES;
    [self.view insertSubview:_lrcORphotoBtn aboveSubview:_lrcView];

    

    //显示歌词的tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 80, 275, 500) style:UITableViewStylePlain];
    [_lrcView addSubview:_tableView];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha = 0.5;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.allowsSelection = YES;
    
}

- (void)clickBtn:(UIButton *)sender
{
    if (self.lrcView.isHidden) {
        self.lrcView.hidden = NO;
        sender.selected = YES;
        [sender setTitle:@"歌曲" forState:UIControlStateNormal];
    }else{
        self.lrcView.hidden = YES;
        sender.selected = NO;
        [sender setTitle:@"歌词" forState:UIControlStateNormal];
        
    }}

//加载歌曲和mp3的素材
- (void)loadMusic:(NSString *)name AndType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *fileURl = [NSURL fileURLWithPath:path];
    
    _Player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURl error:nil];
    _Player.delegate = self;
    
    _Player.volume = 0.5;
    [_Player prepareToPlay];
    
    AVURLAsset *avURLAsset = [[AVURLAsset alloc] initWithURL:fileURl options:nil];
    for (NSString *format in [avURLAsset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [avURLAsset metadataForFormat:format]) {
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                UIImage *coverImage = [[UIImage alloc] initWithData:(NSData *)metadataItem.value];
                _iconimageView.image = coverImage;
            }
            if ([metadataItem.commonKey isEqualToString:@"title"]) {
                NSString *title = (NSString *)metadataItem.value;
                _nameLabel.text = title;
            }
            if ([metadataItem.commonKey isEqualToString:@"artist"]) {
                NSString *singer = (NSString *)metadataItem.value;
                _singerName.text = singer;
            }
            if ([metadataItem.commonKey isEqualToString:@"albumName"]) {
                NSString *albumName = (NSString *)metadataItem.value;
                _albumName.text = albumName;
            }
            //歌曲时长
            _songTime.text = _smodel.time;
        }
    }
}
//开始和暂停
- (void)playSong
{
    if ([_Player isPlaying]) {
        [_Player pause];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
       
    }
    else{
        [_Player play];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
         [self addCurrentTimer];
       // [self removeCurrentTimer];

    }

}
//上一曲
- (void)forwardSong
{

    if (_playnum == 0) {
        _playnum = [_mutableArray count]-1;
        _smodel = self.mutableArray[_playnum];
        [self loadMusic:_smodel.name AndType:@"mp3"];
        [_Player play];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"暂停.png"]  forState:UIControlStateNormal];
    } else {
        _playnum --;
        _smodel = self.mutableArray[_playnum];
        [self loadMusic:_smodel.name AndType:@"mp3"];
        [_Player play];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"暂停.png"]  forState:UIControlStateNormal];
    }
}
//下一曲
- (void)nextSong
{
    if (_playnum == [_mutableArray count] - 1) {
        _playnum = 0;
         _smodel = self.mutableArray[_playnum];
        [self loadMusic:_smodel.name AndType:@"mp3"];
        [_Player play];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"暂停.png"]  forState:UIControlStateNormal];
    } else{
           _playnum ++;
           _smodel = self.mutableArray[_playnum];
          [self loadMusic:_smodel.name AndType:@"mp3"];
          [_Player play];
          [_playBtn setBackgroundImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
    }
}

//是否播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self nextSong];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
