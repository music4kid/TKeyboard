//
//  EMultiPeerController.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EMultiPeerController.h"
#import "EMultiPeerView.h"

@implementation EMultiPeerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configMVP:@"MultiPeer"];
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"MultiPeer";
    
    C(self.context.view, IMultiPeerView, buildMultiPeerView);
}



@end
