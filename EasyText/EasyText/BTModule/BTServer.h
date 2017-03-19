//
//  BTServer.h
//  EasyText
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    InputCommandInsert,
    InputCommandDelete,
    InputCommandUpdate,
} InputCommand;

@interface AvailableClient : NSObject
@property (nonatomic, strong) NSString*                 clientName;
@property (nonatomic, strong) NSString*                 clientID;

- (NSString*)getDisplayName;
@end

@protocol BTServerDelegate <NSObject>

- (void)onBluetoothOff;
- (void)onClientSubscribed:(NSString*)clientID;
- (void)onClientUnsubscribed:(NSString*)clientID;
- (void)onServerStatusChanged;
- (void)onReceivedClientText:(NSString*)text action:(NSString*)action centralID:(NSString*)centralID;

@end

@interface BTServer : NSObject

@property (nonatomic, weak) id<BTServerDelegate>     delegate;

- (void)startAdvertising;
- (void)stopAdvertising;

- (void)sendContent:(NSString*)str centralID:(NSString*)centralID;
- (void)sendAction:(NSString*)action centralID:(NSString*)centralID;

@end
