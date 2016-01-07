//
//  LRCModel.h
//  EasonMusic8
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class songsModel;

@interface LRCModel : NSObject

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString *word;

+ (NSMutableArray *)lrcModelsWithlrcName:(NSString *)lrcName;

@end
