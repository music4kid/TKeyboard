//
//  EMainInteractor.m
//  PIXY
//
//  Created by gao feng on 16/4/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EMainInteractor.h"
#import "EMultiPeerController.h"
#import "MCManager.h"
#import "KeyboardGuideController.h"
#import "ESyncHostController.h"

@import MultipeerConnectivity;

NSString *const RateAlertURL = @"itms-apps://itunes.apple.com/app/id1168383839";

@implementation EMainInteractor

- (void)gotoKeyboardGuide
{
    KeyboardGuideController* ctrl = [KeyboardGuideController new];
    [self.baseController.navigationController pushViewController:ctrl animated:true];
}

- (void)gotoSyncPeer
{
    ESyncHostController* ctrl = [ESyncHostController new];
    [self.baseController.navigationController pushViewController:ctrl animated:true];
}

- (void)gotoAbout {
    
}

- (void)gotoReview {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RateAlertURL]];
}





@end
