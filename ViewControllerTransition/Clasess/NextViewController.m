//
//  NextViewController.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/27.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "NextViewController.h"

#import "UIViewController+CWLateralSlide.h"

#import "NextTableViewCell.h"

@interface NextViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation NextViewController

- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",@"personal_myservice_icons",@"personal_news_icons",@"personal_order_icons",@"personal_preview_icons",@"personal_service_icons"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"啦啦啦啦",@"囖囖囖囖",@"呵呵呵呵",@"嘿嘿嘿嘿",@"哈哈哈哈",@"嘻嘻嘻嘻"];
    }
    return _titleArray;
}


- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHeader];
    
    [self setupTableView];
    
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
//    tableView.backgroundColor = [UIColor clearColor];
    _tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"NextTableViewCell" bundle:nil] forCellReuseIdentifier:@"NextCell"];
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"0.jpg"];
    [self.view addSubview:imageV];
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NextCell"];
    cell.imageName = self.imageArray[indexPath.row];
    cell.title = self.titleArray[indexPath.row];
//    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NextViewController *vc = [NextViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
