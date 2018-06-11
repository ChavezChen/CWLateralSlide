//
//  CWTableViewInfo.m
//  CWLateralSlideDemo
//
//  Created by ChavezChen on 2018/6/8.
//  Copyright © 2018年 chavez. All rights reserved.
//

#import "CWTableViewInfo.h"
#import "CWTableViewCell.h"

@interface CWTableViewInfo ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CWTableViewInfo
{
    UITableView *_tableView;
    NSMutableArray *_cellInfoArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        [self setupTableViewWithFrame:frame style:style];
        _cellInfoArray = [NSMutableArray array];
    }
    return self;
}


- (void)setupTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:style];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - public Method
- (NSUInteger)getDataArrayCount {
    return _cellInfoArray.count;
}

- (UITableView *)getTableView {
    return _tableView;
}


- (void)addCell:(CWTableViewCellInfo *)cellInfo {
    [_cellInfoArray addObject:cellInfo];
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%zd",_cellInfoArray.count);
    return _cellInfoArray.count;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReusaId"];
    CWTableViewCellInfo *cellInfo = _cellInfoArray[indexPath.row];
    
    if (cell == nil) {
        cell = [[CWTableViewCell alloc] initWithStyle:cellInfo.cellStyle reuseIdentifier:@"CellReusaId"];
    }
    
    cell.cellInfo = cellInfo;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CWTableViewCellInfo *cellInfo = _cellInfoArray[indexPath.row];
    
    id target = cellInfo.actionTarget;
    SEL selector = cellInfo.actionSel;
    
    if (cellInfo.selectionStyle) {
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector withObject:cellInfo];
        }
    }
    
}


@end
