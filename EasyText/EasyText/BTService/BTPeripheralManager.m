//
//  BTPeripheralManager.m
//  EasyText
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "BTPeripheralManager.h"
#import "TransferService.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTPeripheralService.h"


@interface BTPeripheralManager () <CBPeripheralManagerDelegate>
@property (strong, nonatomic) CBPeripheralManager       *peripheral;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristicPad;

@property (nonatomic, strong) NSTimer*                  heartbeatTimer;

@property (nonatomic, strong) NSMutableArray*                 subscribedCentrals;
@property (nonatomic, strong) NSData*                   characteristicData;


@end

@implementation BTPeripheralManager

+ (instancetype)sharedInstance
{
    static BTPeripheralManager* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BTPeripheralManager new];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _peripheral = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        
        self.subscribedCentrals = @[].mutableCopy;
        self.characteristicData = [NSData new];
    }
    return self;
}

- (void)stopAdvertising {
	[self.peripheral stopAdvertising];
}

- (void)startAdvertising {
    
#if TARGET_OS_OSX
    NSHost* host = [NSHost currentHost];
    NSString* hostName = [host localizedName];
    if (hostName.length == 0) {
        hostName = @"My Mac";
    }
    
    [self.peripheral startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]],
                                         CBAdvertisementDataLocalNameKey : hostName}];
#endif
}


- (void)startHeartbeat
{
    [self stopHeartbeat];
    self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onHeartbeatTimeout) userInfo:nil repeats:true];
}

- (void)stopHeartbeat
{
    if (self.heartbeatTimer) {
        [self.heartbeatTimer invalidate];
    }
}

- (void)onHeartbeatTimeout
{
//    [self sendText:@""];
}

#pragma mark - Peripheral Methods
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
#if TARGET_OS_MAC
    if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        if (self.delegate) {
            [_delegate onBluetoothOff];
        }
    }
    
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
#endif
    
    NSLog(@"self.peripheralManager powered on.");

    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                                     properties:CBCharacteristicPropertyNotify|CBCharacteristicPropertyWrite|CBCharacteristicPropertyWriteWithoutResponse
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
    
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
                                                                       primary:YES];
    transferService.characteristics = @[self.transferCharacteristic];
    [self.peripheral addService:transferService];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central subscribed to characteristic:%@", central.identifier.UUIDString);

    [self addCentralToConnectedList:central];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central unsubscribed from characteristic");
    [self stopHeartbeat];
    
    if (self.delegate) {
        [_delegate onCentralUnSubscribed:central.identifier.UUIDString];
    }
    
    CentralObject* targetCO = nil;
    for (CentralObject* co in self.subscribedCentrals) {
        if ([co.central.identifier.UUIDString isEqualToString:central.identifier.UUIDString]) {
            targetCO = co;
            break;
        }
    }
    if (targetCO) {
        [_subscribedCentrals removeObject:targetCO];
    }
}

- (void)addCentralToConnectedList:(CBCentral*)central
{
    if (self.delegate) {
        [_delegate onCentralSubscribed:central.identifier.UUIDString];
    }
    [self startHeartbeat];
    
    BOOL exists = false;
    for (CentralObject* co in self.subscribedCentrals) {
        if ([co.central.identifier.UUIDString isEqualToString:central.identifier.UUIDString]) {
            exists = true;
            co.central = central;
        }
    }
    if (exists == false) {
        CentralObject* co = [CentralObject new];
        co.central = central;
        co.peripheral = self.peripheral;
        co.transferCharacteristic = self.transferCharacteristic;
        [_subscribedCentrals addObject:co];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests
{
    for (CBATTRequest* req in requests) {
        NSData* data = req.value;
        if (data.length > 0) {
            
            BOOL exists = false;
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            for (CentralObject* co in _subscribedCentrals) {
                if ([co.central.identifier.UUIDString isEqualToString:req.central.identifier.UUIDString]) {
                    exists = true;
                }
            }
            
            if (exists == false) {
                NSLog(@"text message: %@ from unknown central:%@", str, req.central.identifier.UUIDString);
                
                //central gets disconnected somehow, add it to connected list
                [self addCentralToConnectedList:req.central];
            }
            
            if ([req.characteristic.UUID isEqual:self.transferCharacteristic.UUID] == false
//                || req.offset > self.transferCharacteristic.value.length
                )
            {
                NSLog(@"invalid write request");
                continue;
            }
//            self.transferCharacteristic.value = req.value;
//            [peripheral respondToRequest:[requests objectAtIndex:0] withResult:CBATTErrorSuccess];
            [peripheral respondToRequest:req withResult:CBATTErrorSuccess];
            
            if (str.length > 0) {
                if (self.delegate) {
                    NSString* clientID = req.central.identifier.UUIDString;
                    [_delegate onReceivedText:str centralID:clientID];
                }
            }
        }
        
    }
}

- (void)sendText:(NSString*)text toCentral:(NSString*)centralID
{
    for (CentralObject* co in _subscribedCentrals) {
        if ([co.central.identifier.UUIDString isEqualToString:centralID]) {
            [co sendText:text];
            break;
        }
    }
}

- (void)sendAction:(NSString*)action toCentral:(NSString*)centralID {
    for (CentralObject* co in _subscribedCentrals) {
        if ([co.central.identifier.UUIDString isEqualToString:centralID]) {
            [co sendAction:action];
            break;
        }
    }
}


/** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
 *  This is to ensure that packets will arrive in the order they are sent
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    // Start sending again
    for (CentralObject* co in _subscribedCentrals) {
        [co sendData];
    }
}



@end
