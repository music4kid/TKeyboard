//
//  ESyncHostView.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ESyncHostView.h"
#import "ESyncHostPresenter.h"

@interface ESyncHostView ()
@property (nonatomic, strong) EAdapter *adapter;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ESyncHostView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)reloadSyncHostView {
	[self.tableView reloadData];
}

- (void)buildSyncHostView:(EAdapter*)adapter {
    
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"SyncHost" owner:self options:nil];
    UIView* syncRoot = [views objectAtIndex:0];
    [self addSubview:syncRoot];
    
    for (UIView* v in syncRoot.subviews) {
        if ([v isKindOfClass:[UITableView class]]) {
            self.tableView = (UITableView*)v;
        }
    }
    
    self.tableView.dataSource = adapter;
    self.tableView.delegate = adapter;
    
    C(self.context.presenter, ISyncHostPresenter, refreshConnectedPeers);
}




@end
