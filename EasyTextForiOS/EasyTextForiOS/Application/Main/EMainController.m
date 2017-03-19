//
//  EMainController.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EMainController.h"
#import "IMainView.h"
#import "IMainPresenter.h"
#import "EAdapter.h"
#import "EMainAdapter.h"

@interface EMainController ()
@property (nonatomic, strong) EMainAdapter*                 adapter;

@end

@implementation EMainController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configMVP:@"Main"];
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"TKeyboard";
    
    self.adapter = [EMainAdapter new];
    _adapter.adapterDelegate = (id<EAdapterDelegate>)self.context.presenter;
    self.context.presenter.adapter = _adapter;
    
    C(self.context.view, IMainView, buildMainView:_adapter);
    C(self.context.presenter, IMainPresenter, autoDetectMPC);
    C(self.context.presenter, IMainPresenter, autoDetectBluetoothDevices);
    C(self.context.presenter, IMainPresenter, renderInitialUI);
    
    
}



@end
