//
//  CWTableViewCell.m
//  CWLateralSlideDemo
//
//  Created by ChavezChen on 2018/6/8.
//  Copyright © 2018年 chavez. All rights reserved.
//

#import "CWTableViewCell.h"

@implementation CWTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        self.textLabel.font = [UIFont systemFontOfSize:17];
        
        self.detailTextLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

#pragma mark - setter
- (void)setCellInfo:(CWTableViewCellInfo *)cellInfo {
    
    _cellInfo = cellInfo;
    self.accessoryType = cellInfo.accessoryType;
    self.selectionStyle = cellInfo.selectionStyle;
    self.backgroundColor = cellInfo.backGroudColor;
    
    self.textLabel.text = [cellInfo getCellInfoValueForKey:@"title"];
    NSString *imageName = [cellInfo getCellInfoValueForKey:@"imageName"];
    if (imageName) {
        self.imageView.image = [UIImage imageNamed:imageName];
    }
    
}



@end
