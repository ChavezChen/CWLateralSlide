//
//  CWTableViewCellInfo.h
//  CWLateralSlideDemo
//
//  Created by ChavezChen on 2018/6/8.
//  Copyright © 2018年 chavez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWTableViewCellInfo : NSObject

@property (nonatomic, strong) NSMutableDictionary *dataInfo;

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, assign) UITableViewCellStyle cellStyle;
@property (nonatomic, strong) UIColor *backGroudColor;

@property (nonatomic, assign) SEL actionSel;
@property (nonatomic, weak) id actionTarget;

@property (nonatomic, assign) CGFloat fCellHeight;
@property (nonatomic, strong) NSIndexPath *indexPath;


- (void)addCellInfoValue:(id)value forKey:(NSString *)key;
- (id)getCellInfoValueForKey:(NSString *)key;

+ (instancetype)cellInfoWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target sel:(SEL)sel;

@end
