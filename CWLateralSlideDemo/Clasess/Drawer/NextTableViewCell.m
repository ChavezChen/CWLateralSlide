//
//  NextTableViewCell.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/8.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "NextTableViewCell.h"

@implementation NextTableViewCell
{
    __weak IBOutlet UIImageView *imageV;
    __weak IBOutlet UILabel *titleLable;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    imageV.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLable.text = title;
}


@end
