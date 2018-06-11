//
//  CWTableViewCell.h
//  CWLateralSlideDemo
//
//  Created by ChavezChen on 2018/6/8.
//  Copyright © 2018年 chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWTableViewCellInfo.h"

@interface CWTableViewCell : UITableViewCell

@property (nonatomic, weak) CWTableViewCellInfo *cellInfo;

@end
