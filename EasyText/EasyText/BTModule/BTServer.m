//
//  BTServer.m
//  EasyText
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "BTServer.h"
#import "BTPeripheralManager.h"

@implementation AvailableClient

- (NSString*)getDisplayName {
    if (self.clientName.length > 0) {
        return _clientName;
    }
    
    return _clientID;
}

@end

@interface BTServer () <BTPeripheralManagerDelegate>

@end

@implementation BTServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _Peripheral.delegate = self;
    }
    return self;
}

- (void)startAdvertising {
    [_Peripheral startAdvertising];
}

- (void)stopAdvertising {
    [_Peripheral stopAdvertising];
}

- (void)sendContent:(NSString*)str centralID:(NSString*)centralID {
    [_Peripheral sendText:str toCentral:centralID];
}

- (void)sendAction:(NSString*)action centralID:(NSString*)centralID {
    [_Peripheral sendAction:action toCentral:centralID];
}


#pragma mark- BTPeripheralManagerDelegate

- (void)onSendTextFailed {
	
}

- (void)onSendTextFinished {
	
}


- (void)onBluetoothOff {
    if (self.delegate) {
        [_delegate onBluetoothOff];
    }
}

- (void)onCentralSubscribed:(NSString*)clientID {
    
    NSLog(@"onCentralSubscribed: %@", clientID);
    if (self.delegate) {
        [_delegate onClientSubscribed:clientID];
    }
}

- (void)onCentralUnSubscribed:(NSString*)clientID {

    NSLog(@"onCentralUnSubscribed: %@", clientID);
    if (self.delegate) {
        [_delegate onClientUnsubscribed:clientID];
    }
}

- (void)onReceivedText:(NSString*)text centralID:(NSString *)centralID {
    NSString* action = [text substringWithRange:NSMakeRange(0, 2)];
    NSString* content = [text substringFromIndex:2];
    if (self.delegate) {
        [_delegate onReceivedClientText:content action:action centralID:centralID];
    }
}



@end
