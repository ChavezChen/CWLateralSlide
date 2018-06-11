//
//  CWTableViewInfo.h
//  CWLateralSlideDemo
//
//  Created by ChavezChen on 2018/6/8.
//  Copyright © 2018年 chavez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CWTableViewCellInfo.h"

@interface CWTableViewInfo : NSObject

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (NSUInteger)getDataArrayCount;
- (UITableView *)getTableView;

- (void)addCell:(CWTableViewCellInfo *)cellInfo;


@end
