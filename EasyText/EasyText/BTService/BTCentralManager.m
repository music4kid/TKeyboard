//
//  BTCentralManager.m
//  EasyText
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "BTCentralManager.h"
#import "TransferService.h"
#import "BTCentralService.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BTCentralManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (strong, nonatomic) CBCentralManager      *central;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (nonatomic, strong) CBCharacteristic      *discoveredCharacterstic;

@property (strong, nonatomic) NSMutableData         *data;

@property (nonatomic, strong) NSMutableArray*                 peripherals;

@end

@implementation BTCentralManager

+ (instancetype)sharedInstance
{
    static BTCentralManager* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BTCentralManager new];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        _data = [[NSMutableData alloc] init];
        
        self.peripherals = @[].mutableCopy;
    }
    return self;
}

- (void)startScan {
    if ([self isCentralStateOn] == false) {
        return;
    }
    
    [self.central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
                                         options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    
    if (self.delegate) {
        [_delegate onScanStarted];
    }
}

#pragma mark - Central
- (void)closePreviousConnection
{
    NSArray<CBPeripheral *>* servers = nil;
    servers = [_central retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
    
    for (CBPeripheral* per in servers) {
        [_central cancelPeripheralConnection:per];
    }
}

- (NSString*)retrievePreviousServer {
    NSString* name = nil;
    NSArray<CBPeripheral *>* servers = nil;
    
    NSString* prevPeripheralID = [[BTCentralService sharedInstance] getPreviousDiscoveredPeripheralID];
    if (prevPeripheralID.length > 0) {
//        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:prevPeripheralID];
//        servers = [_central retrievePeripheralsWithIdentifiers:@[uuid]];
    }
    
    if (servers.count == 0) {
        servers = [_central retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
    }
    
    if (servers.count > 0) {
        CBPeripheral* peripheral = [servers firstObject];
        [_peripherals addObject:peripheral];
        
        NSLog(@"Peripheral Retrieved");
        if (self.delegate) {
            [_delegate onPeripheralDiscoverd:peripheral.name];
        }
        name = peripheral.name;
    }
    
    return name;
}

- (BOOL)isCentralStateOn
{
#if TARGET_OS_IOS
    if (self.central.state != CBManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        if (self.delegate) {
            NSString* err = @"";
            switch (self.central.state) {
                case CBManagerStateUnknown:
                    err = @"CBManagerStateUnknown";
                    break;
                case CBManagerStateResetting:
                    err = @"CBManagerStateResetting";
                    break;
                case CBManagerStateUnsupported:
                    err = NSLocalizedString(@"OpenAccessDisabled", nil);
                    break;
                case CBManagerStateUnauthorized:
                    err = @"CBManagerStateUnauthorized";
                    break;
                case CBManagerStatePoweredOff:
                    err = NSLocalizedString(@"BluetoothPoweredOff", nil);
                    break;
                default:
                    break;
            }
            [_delegate onPeripheralStateError:err];
        }
        return false;
    }
#endif
    return true;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
#if TARGET_OS_IOS
    NSLog(@"centralManagerDidUpdateState:%d", (int)central.state);
    if (central.state == CBManagerStatePoweredOff) {
        if (self.delegate) {
            [_delegate onBluetoothOff];
        }
    }
    
    if ([self isCentralStateOn] == false) {
        return;
    }
#endif
    
    [self startScan];
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict
{
    NSLog(@"centralManager willRestoreState: %@", dict);
}

/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    // Reject any where the value is above reasonable range
//    if (RSSI.integerValue > -15) {
//        return;
//    }
    
//    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
//    if (RSSI.integerValue < -100) { //-35
//        return;
//    }
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    BOOL exists = false;
    for (CBPeripheral* p in self.peripherals) {
        if ([p.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            exists = true;
        }
    }
    if (exists == false) {
        [_peripherals addObject:peripheral];
        [[BTCentralService sharedInstance] savePreviousDiscoveredPeripheralID:peripheral.identifier.UUIDString];
    }
    
    if (self.delegate) {
        NSString* peerName = peripheral.name;
        if (peerName.length == 0) {
            peerName = peripheral.identifier.UUIDString;
        }
        if (peerName.length > 0) {
            [_delegate onPeripheralDiscoverd:peerName];
        }
    }
}

- (void)connectToPeripheral:(NSString*)name {
    CBPeripheral* targetPeripheral = nil;
    
    for (CBPeripheral* p in self.peripherals) {
        if ([p.name isEqualToString:name] || [p.identifier.UUIDString isEqualToString:name]) {
            targetPeripheral = p;
            break;
        }
    }
    
    if (targetPeripheral != nil) {

        self.discoveredPeripheral = targetPeripheral;

        if (targetPeripheral.state != CBPeripheralStateConnected) {
            NSLog(@"Connecting to peripheral %@", targetPeripheral);
            [self.central connectPeripheral:targetPeripheral options:nil];
        }
        else
        {
            //sync once
            if (self.delegate) {
                NSLog(@"tap on already connected peripheral");
                [_delegate onPeripheralConnected:targetPeripheral.name];
            }
        }
    }
}



/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}

/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.data setLength:0];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}

/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.discoveredPeripheral = nil;
    
    if (self.delegate) {
        [_delegate onPeripheralDisconnected:peripheral.name];
    }
    
    // We're disconnected, so start scanning again
    [self startScan];
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices
{
    BOOL ourServiceInvalidated = false;
    for (CBService* service in invalidatedServices) {
        if ([service.UUID.UUIDString isEqualToString:TRANSFER_SERVICE_UUID]) {
            ourServiceInvalidated = true;
            break;
        }
    }
    
    if (ourServiceInvalidated) {
        [self closeConnection];
    }
}

/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}

/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
            self.discoveredCharacterstic = characteristic;
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            
            NSLog(@"Peripheral Connected");
            if (self.delegate) {
                [_delegate onPeripheralConnected:peripheral.name];
                
                [self.central stopScan];
                NSLog(@"Scanning stopped");
            }

        }
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}

- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
{
    
}

- (void)sendTextToPeripheral:(NSString*)text {
    if (self.discoveredCharacterstic && self.discoveredPeripheral && text.length > 0) {
        NSLog(@"sendTextToPeripheral:%@", text);
        NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
        [self.discoveredPeripheral writeValue:data forCharacteristic:self.discoveredCharacterstic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
    }
    else
    {
        NSLog(@"write characteristic succeed.");
    }
}

/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    //append data
    [self.data appendData:characteristic.value];
    
    while (self.data.length > 0) {
        //check for complete packet
        NSString *stringFromData = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        if (stringFromData.length < 4) { //minimal packet length
            return;
        }
        
        NSString* headerStr = [stringFromData substringWithRange:NSMakeRange(0, 2)];
        BOOL validHeader = false;
        if ([headerStr isEqualToString:kPacketActionHeader] == true ||
            [headerStr isEqualToString:kPacketContentHeader] == true) {
            validHeader = true;
        }
        if (validHeader == false) {
            NSLog(@"err: wrong packet!");
        }
        
        
        NSString* lengthStr = [stringFromData substringWithRange:NSMakeRange(2, 2)];
        NSString* payloadStr = [stringFromData substringFromIndex:4];
        int payloadLength = [lengthStr intValue];
        if (payloadStr.length < payloadLength) {  //packet is incomplete
            return;
        }
        
        NSLog(@"received valid text: %@", stringFromData);
        
        NSString* receivedText = [payloadStr substringWithRange:NSMakeRange(0, payloadLength)];
        int handledLength = (int)[[receivedText dataUsingEncoding:NSUTF8StringEncoding] length] + 2 + 2;

        //remove from data
        NSData* d = [NSData dataWithBytes:self.data.bytes + handledLength length:self.data.length-handledLength];
        [self.data setData:d];
        
        //heartbeat text is ""
        if (receivedText.length > 0 && self.delegate) {
            
            if ([headerStr isEqualToString:kPacketActionHeader] == true) {
                [_delegate onPeripheralReceivedAction:receivedText];
            }
            else if ([headerStr isEqualToString:kPacketContentHeader] == true)
            {
                [_delegate onPeripheralReceivedText:receivedText];
            }
            
        }
        
//        NSLog(@"Received: %@", stringFromData);
    }
    
}

- (void)closeConnection {
    // Cancel our subscription to the characteristic
    [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:self.discoveredCharacterstic];
    
    // and disconnect from the peripehral
    [self.central cancelPeripheralConnection:self.discoveredPeripheral];

    self.discoveredCharacterstic = nil;
    self.discoveredPeripheral = nil;
}

/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.central cancelPeripheralConnection:peripheral];
    }
}


/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (self.discoveredPeripheral.state != CBPeripheralStateConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.central cancelPeripheralConnection:self.discoveredPeripheral];
}


@end
