//
//  RightViewController.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "RightViewController.h"

#import "UIViewController+CWLateralSlide.h"

#import "NextTableViewCell.h"

#import "NextViewController.h"

@interface RightViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation RightViewController



- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",@"personal_myservice_icons",@"personal_news_icons",@"personal_order_icons",@"personal_preview_icons",@"personal_service_icons"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"了解会员特权",@"钱包",@"个性装扮",@"我的收藏",@"我的相册",@"我的文件"];
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
    
    
//    [self setupbackImage];
    
    [self setupTableView];
    
    
}

- (void)setupTableView {
    // 因为present出来的视图是全屏布局的，所以在这里 tableview的x原点要向右边偏移一定距离（屏幕的宽度 减去之前设置的distance 默认为屏幕的0.75）
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kCWSCREENWIDTH * (1 - 0.75), 300, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
        tableView.backgroundColor = [UIColor clearColor];
    _tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"NextTableViewCell" bundle:nil] forCellReuseIdentifier:@"NextCell"];
}

- (void)setupbackImage {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"image.jpg"];
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
        cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NextViewController *vc = [NextViewController new];

    [self cw_pushViewController:vc ];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
