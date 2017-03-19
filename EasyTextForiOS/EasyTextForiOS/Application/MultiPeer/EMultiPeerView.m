//
//  EMultiPeerView.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EMultiPeerView.h"
#import "IMultiPeerPresenter.h"


@interface EMultiPeerView ()
@property (nonatomic, strong) UIButton*                 btnBrowser;

@end

@implementation EMultiPeerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)buildMultiPeerView
{
    self.backgroundColor = [UIColor colorWithHex:0xffffff];
    
    UIButton *btn = [UIButton new];
    [btn setBackgroundColor:[UIColor colorWithHex:0x333333]];
    [btn setTitle:@"Browser" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnBrowserClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.btnBrowser = btn;
    btn.frame = CGRectMake(100, 100, 100, 40);
}

- (void)btnBrowserClick
{
    C(self.context.presenter, IMultiPeerPresenter, beginBrowsing);
}

@end
