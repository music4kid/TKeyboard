//
//  ETemplateView.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 instanza. All rights reserved.
//

#import "ETemplateView.h"

@interface ETemplateView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EAdapter *adapter;
@end

@implementation ETemplateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)reloadTemplateView {
	[self.tableView reloadData];
}

- (void)buildTemplateView:(EAdapter*)adapter {
    [self addSubview:self.tableView];
    self.tableView.dataSource = adapter;
    self.tableView.delegate = adapter;
    
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
