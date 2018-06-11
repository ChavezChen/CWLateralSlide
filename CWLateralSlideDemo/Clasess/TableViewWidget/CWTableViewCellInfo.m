//
//  CWTableViewCellInfo.m
//  CWLateralSlideDemo
//
//  Created by ChavezChen on 2018/6/8.
//  Copyright © 2018年 chavez. All rights reserved.
//

#import "CWTableViewCellInfo.h"

@implementation CWTableViewCellInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.cellStyle = UITableViewCellStyleValue1;
    }
    return self;
}

+ (instancetype)cellInfoWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target sel:(SEL)sel {
    CWTableViewCellInfo *cellInfo = [self new];
    
    cellInfo.actionTarget = target;
    cellInfo.actionSel = sel;
    
    [cellInfo addCellInfoValue:title forKey:@"title"];
    [cellInfo addCellInfoValue:imageName forKey:@"imageName"];
    
    return cellInfo;
}


- (void)addCellInfoValue:(id)value forKey:(NSString *)key {
    if (_dataInfo == nil) {
        _dataInfo = [NSMutableDictionary dictionary];
    }
    
    if (value && key) {
        [_dataInfo setObject:value forKey:key];
    }
}

- (id)getCellInfoValueForKey:(NSString *)key {

    return [_dataInfo objectForKey:key];
}

@end
