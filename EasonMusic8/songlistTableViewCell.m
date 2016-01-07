//
//  songlistTableViewCell.m
//  EasonMusic5
//
//  Created by qingyun on 15/12/9.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "songlistTableViewCell.h"
#import "songsModel.h"
@interface songlistTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end;

@implementation songlistTableViewCell

- (void)setSongsmodel:(songsModel *)songsmodel
{
    _songsmodel = songsmodel;
    
    _titleLabel.text = songsmodel.name;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
