//
//  TextSession.h
//  EasyText
//
//  Created by gao feng on 2016/10/24.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "BTServer.h"
#import "InputWindowController.h"

typedef enum : NSUInteger {
    CentralStatusConnected,
    CentralStatusDisconnected,
} CentralConnectStatus;

@interface TextSession : NSObject

@property (nonatomic, strong) AvailableClient*                  connectedCentral;
@property (nonatomic, strong) InputWindowController*            inputCtrl;
@property (nonatomic, weak) BTServer*                           btServer;
@property (nonatomic, assign) CentralConnectStatus              centralStatus;


- (void)initSession;
- (void)showPopup:(id)sender;
- (void)hidePopup;


@end
