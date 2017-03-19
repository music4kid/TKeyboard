//
//  ETemplateController.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 instanza. All rights reserved.
//

#import "ETemplateController.h"
#import "ETemplateAdapter.h"
#import "ITemplateView.h"
#import "ITemplatePresenter.h"

@interface ETemplateController ()
@property (nonatomic, strong) EAdapter*                 adapter;
@end

@implementation ETemplateController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configMVP:@"Template"];
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.adapter = [ETemplateAdapter new];
    _adapter.adapterDelegate = (id<EAdapterDelegate>)self.context.presenter;
    self.context.presenter.adapter = _adapter;
    
    C(self.context.view, ITemplateView, buildTemplateView:_adapter);
}



@end
