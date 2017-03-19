//
//  BTClient.h
//  EasyText
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTClientDelegate <NSObject>

- (void)onClientError:(NSString*)err;
- (void)onScanStarted;
- (void)onBluetoothOff;
- (void)onServerDiscovered:(NSString*)server;

- (void)onServerConnected:(NSString*)serverID;
- (void)onServerDisconnected:(NSString*)serverID;

- (void)onServerReceivedText:(NSString*)text;
- (void)onServerReceivedAction:(NSString*)action;

@end

@interface BTClient : NSObject

@property (nonatomic, weak) id<BTClientDelegate>                 delegate;

- (void)startScan;

- (void)connectToServer:(NSString*)serverID;
- (void)sendText:(NSString*)text withAction:(NSString*)action;

- (NSString*)retrievePreviousServer;
- (void)closePreviousConnection;

@end
