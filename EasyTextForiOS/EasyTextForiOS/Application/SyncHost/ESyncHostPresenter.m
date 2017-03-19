//
//  ESyncHostPresenter.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ESyncHostPresenter.h"
#import "MCManager.h"
#import "ESyncHostAdapter.h"
#import "ISyncHostView.h"
#import "ESharedUserDefault.h"

@interface ESyncHostPresenter () <EAdapterDelegate>

@end

@implementation ESyncHostPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectPeersConnected:) name:Notif_MCPeer_Connected object:nil];
    }
    return self;
}


- (void)refreshConnectedPeers
{
    NSArray* peers = [_MC getConnectedPeers];
    
    ESyncHostAdapter* adapter = self.context.presenter.adapter;
    [adapter setAdapterArray:peers];
    C(self.context.view, ISyncHostView, reloadSyncHostView);
}

- (void)detectPeersConnected:(NSNotification*)notif
{
    [self refreshConnectedPeers];
}

- (void)didSelectCellData:(id)cellData {
    [[ESharedUserDefault sharedInstance] setSyncHost:cellData];
    
    [self refreshConnectedPeers];
}



@end
