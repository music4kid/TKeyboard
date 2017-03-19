//
//  BTPeripheralService.h
//  EasyText
//
//  Created by gao feng on 2016/10/23.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CentralObject : NSObject

@property (strong, nonatomic) NSMutableData*                    dataToSend;
@property (nonatomic, readwrite) NSInteger                      sendDataIndex;
@property (nonatomic, strong) CBCentral*                        central;
@property (nonatomic, weak) CBPeripheralManager*                peripheral;
@property (nonatomic, weak) CBMutableCharacteristic*            transferCharacteristic;

- (void)sendText:(NSString*)text;
- (void)sendAction:(NSString*)action;
- (void)sendData;

@end






@interface BTPeripheralService : NSObject

+ (instancetype)sharedInstance;

@end
