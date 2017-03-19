//
//  BTClient.m
//  EasyText
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "BTClient.h"
#import "BTCentralManager.h"

#define kMsgCheckInterval           0.01f

@interface BTClient () <BTCentralManagerDelegate>
@property (nonatomic, strong) NSMutableArray*                 serverList;
@property (nonatomic, strong) NSMutableArray*                 msgQueue;
@property (nonatomic, strong) NSTimer*                        msgTimer;


@end

@implementation BTClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _Central.delegate = self;
        
        self.serverList = @[].mutableCopy;
        self.msgQueue = @[].mutableCopy;
    }
    return self;
}

- (void)startScan {
    [_Central startScan];
}

- (void)connectToServer:(NSString*)serverID {
    [_Central connectToPeripheral:serverID];
}

- (void)sendText:(NSString*)text withAction:(NSString*)action {
    if (text == nil) {
        return;
    }
    NSString* fullStr = [NSString stringWithFormat:@"%@%@", action, text];
    [_Central sendTextToPeripheral:fullStr];
}

- (NSString*)retrievePreviousServer {
    NSString* serverName = nil;
    serverName = [_Central retrievePreviousServer];
    return serverName;
}

- (void)startMsgCheckTimer
{
    if (self.msgTimer != nil) {
        return;
    }
    self.msgTimer = [NSTimer scheduledTimerWithTimeInterval:kMsgCheckInterval target:self selector:@selector(onMsgTimeout) userInfo:nil repeats:false];
}

- (void)onMsgTimeout
{
    if (_msgQueue.count > 0) {
        NSString* text;
        @synchronized (self) {
            text = _msgQueue[0];
            [_msgQueue removeObjectAtIndex:0];
        }
        [_delegate onServerReceivedText:text];
    }
    
    [self cancelMsgTimer];
    if (_msgQueue.count > 0) {
        [self startMsgCheckTimer];
    }
}

- (void)cancelMsgTimer
{
    [_msgTimer invalidate];
    self.msgTimer = nil;
}

#pragma mark - BTCentralManagerDelegate

- (void)onPeripheralReceivedText:(NSString*)text {
    if (self.delegate) {
        
        @synchronized (self) {
            [_msgQueue addObject:text];
        }
        if (_msgTimer == nil) {
            [self startMsgCheckTimer];
        }
    }
}

- (void)onPeripheralReceivedAction:(NSString*)action {
    if (self.delegate) {
        [_delegate onServerReceivedAction:action];
    }
}

- (void)onPeripheralDiscoverd:(NSString*)name {
    
    if ([_serverList containsObject:name] == false) {
        [_serverList addObject:name];
    }
    
    if (self.delegate) {
        [_delegate onServerDiscovered:name];
    }
}

- (void)onPeripheralStateError:(NSString*)err {
    if (self.delegate) {
        [_delegate onClientError:err];
    }
}

- (void)onPeripheralConnected:(NSString*)name {
    if (self.delegate) {
        [_delegate onServerConnected:name];
    }
}

- (void)onPeripheralDisconnected:(NSString*)name {
    if (self.delegate) {
        [_delegate onServerDisconnected:name];
    }
}

- (void)onBluetoothOff
{
    if (self.delegate) {
        [_delegate onBluetoothOff];
    }
}

- (void)onScanStarted
{
    if (self.delegate) {
        [_delegate onScanStarted];
    }
}

- (void)closePreviousConnection {
    [_Central closePreviousConnection];
}




@end
