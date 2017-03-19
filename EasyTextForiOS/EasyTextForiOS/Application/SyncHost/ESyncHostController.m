//
//  ESyncHostController.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ESyncHostController.h"
#import "ESyncHostAdapter.h"
#import "ISyncHostView.h"
#import "ISyncHostPresenter.h"

@interface ESyncHostController ()
@property (nonatomic, strong) EAdapter*                 adapter;
@end

@implementation ESyncHostController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configMVP:@"SyncHost"];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.adapter = [ESyncHostAdapter new];
    _adapter.adapterDelegate = (id<EAdapterDelegate>)self.context.presenter;
    self.context.presenter.adapter = _adapter;
    
    C(self.context.view, ISyncHostView, buildSyncHostView:_adapter);
}



@end
