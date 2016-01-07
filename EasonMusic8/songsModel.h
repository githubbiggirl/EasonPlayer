//
//  songsModel.h
//  EasonMusic5
//
//  Created by qingyun on 15/12/9.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface songsModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lrcName;
@property (nonatomic, strong) NSString *time;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
