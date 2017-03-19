//
//  MCManager.h
//  EasyText
//
//  Created by gao feng on 2016/10/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transcript.h"
@import MultipeerConnectivity;

#define _MC [MCManager sharedInstance]

#define Notif_MCPeer_Connected @"Notif_MCPeer_Connected"

@protocol MCManagerDelegate <NSObject>
- (void)onPeerStateUpdate:(MCSessionState)state host:(NSString*)host;

@optional
- (void)didReceiveText:(NSString*)text;
- (void)didReceiveImage:(NSURL*)image;

- (void)didSentText:(NSString*)text;
- (void)didSentImage:(NSURL*)image;

@end

@interface MCManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<MCManagerDelegate>         delegate;

- (void)beginAdvertisingForiOS;
- (void)beginBrowsingForMac;

- (Transcript *)sendMessage:(NSString *)message;
- (Transcript *)sendImage:(NSURL *)imageUrl;

- (NSArray*)getConnectedPeers;

@end
