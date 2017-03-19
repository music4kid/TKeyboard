//
//  TodayViewController.m
//  TkeyboardToday
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "MCManager.h"
#import "UIImageEX.h"

@interface TodayViewController () <NCWidgetProviding, MCManagerDelegate>
@property (nonatomic, strong) NSString*                 peerName;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _btnSend.layer.cornerRadius = 10;
    _btnSend.layer.masksToBounds = true;
    [_btnSend addTarget:self action:@selector(btnSendClick) forControlEvents:UIControlEventTouchUpInside];
    
    _lbStatus.text = @"Searching...";
    _lbStatus.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    _MC.delegate = self;
    [_MC beginAdvertisingForiOS];
}

- (void)btnSendClick
{
    //send image
    UIImage* img = [[UIPasteboard generalPasteboard] image];
    if (img) {
        NSString* filePath = [img saveToDocument];
        NSURL* url = [NSURL fileURLWithPath:filePath];
        if (url) {
            [_MC sendImage:url];
        }
    }
    
    NSString* targetStr = [NSString stringWithFormat:@"Sending to %@", _peerName];
    _lbStatus.text = targetStr;
    
    //send text
}

#pragma mark - MCManagerDelegate
- (void)didSentImage:(NSURL*)image {
	NSString* targetStr = [NSString stringWithFormat:@"Image sent to %@", _peerName];
    _lbStatus.text = targetStr;
}

- (void)didSentText:(NSString*)text {
	
}

- (void)onPeerStateUpdate:(MCSessionState)state host:(NSString*)host {
    NSString* targetStr = nil;
    if (state == MCSessionStateNotConnected) {
        targetStr = [NSString stringWithFormat:@"Disconnected"];
    }
    else if(state == MCSessionStateConnecting)
    {
        targetStr = [NSString stringWithFormat:@"Connecting..."];
    }
    else if(state == MCSessionStateConnected)
    {
        targetStr = [NSString stringWithFormat:@"%@", host];
    }
    _lbStatus.text = targetStr;
    self.peerName = host;
}




- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
