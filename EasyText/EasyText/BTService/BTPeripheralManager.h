//
//  BTPeripheralManager.h
//  EasyText
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _Peripheral [BTPeripheralManager sharedInstance]

@protocol BTPeripheralManagerDelegate <NSObject>

- (void)onBluetoothOff;
- (void)onCentralSubscribed:(NSString*)clientID;
- (void)onCentralUnSubscribed:(NSString*)clientID;
- (void)onSendTextFinished;
- (void)onSendTextFailed;
- (void)onReceivedText:(NSString*)text centralID:(NSString*)centralID;

@end

@interface BTPeripheralManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<BTPeripheralManagerDelegate>     delegate;

- (void)startAdvertising;
- (void)stopAdvertising;

- (void)sendText:(NSString*)text toCentral:(NSString*)centralID;
- (void)sendAction:(NSString*)action toCentral:(NSString*)centralID;

@end
