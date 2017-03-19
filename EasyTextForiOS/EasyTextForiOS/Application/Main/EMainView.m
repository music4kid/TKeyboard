//
//  EMainView.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EMainView.h"
#import "IMainPresenter.h"
#import "EMainInteractor.h"
#import "EAdapter.h"
#import "MainEntry.h"

@interface EMainView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EAdapter *adapter;


@end

@implementation EMainView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)buildMainView:(EAdapter*)adapter
{
    [self addSubview:self.tableView];
    self.tableView.dataSource = adapter;
    self.tableView.delegate = adapter;
    
    [self.tableView reloadData];
}

- (void)reloadMainView {
    [self.tableView reloadData];
}



- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect frame = self.bounds;
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.clipsToBounds = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
