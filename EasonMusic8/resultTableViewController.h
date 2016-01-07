//
//  resultTableViewController.h
//  EasonMusic8
//
//  Created by qingyun on 15/12/10.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultTableViewController : UITableViewController<UISearchResultsUpdating>

@property (nonatomic, strong) NSArray *array;

@end
