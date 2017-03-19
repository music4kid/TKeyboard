//
//  EMainPresenter.h
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "CDDContext.h"
#import "IMainPresenter.h"
#import "EPresenter.h"
#import "EAdapter.h"

@import MultipeerConnectivity;
#import "BTClient.h"

@interface EMainPresenter : EPresenter <IMainPresenter, EAdapterDelegate>

@property (nonatomic, strong) BTClient*                       client;
@property (nonatomic, strong) NSMutableArray*                 entries;

@end
