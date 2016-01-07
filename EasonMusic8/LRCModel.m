//
//  LRCModel.m
//  EasonMusic8
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "LRCModel.h"

@implementation LRCModel

+ (NSMutableArray *)lrcModelsWithlrcName:(NSString *)lrcName
{
    NSMutableArray *lrcModels = [NSMutableArray array];
    NSURL *url = [[NSBundle mainBundle] URLForResource:lrcName withExtension:nil];
    NSString *lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lrcSepra = [lrcStr componentsSeparatedByString:@"\n"];
    
    [lrcSepra enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LRCModel *lrcModel = [[LRCModel alloc] init];
        [lrcModels addObject:lrcModel];
    }];
    
    
    return lrcModels;
    
}

@end
