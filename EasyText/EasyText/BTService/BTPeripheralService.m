//
//  BTPeripheralService.m
//  EasyText
//
//  Created by gao feng on 2016/10/23.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "BTPeripheralService.h"
#import "TransferService.h"

@implementation CentralObject
{
    BOOL isSending;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataToSend = [NSMutableData new];
        _sendDataIndex = 0;
        isSending = false;
    }
    return self;
}

- (void)sendAction:(NSString*)action {
    NSString* packetLength = [NSString stringWithFormat:@"%02d", (int)action.length];
    NSString* packetString = [NSString stringWithFormat:@"%@%@%@", kPacketActionHeader, packetLength, action];
    NSData* packetData = [packetString dataUsingEncoding:NSUTF8StringEncoding];
    
    @synchronized (self) {
        [self.dataToSend appendData:packetData];
    }
    [self sendData];
}

- (void)sendText:(NSString*)text {
    if (text.length > 99) {
        NSLog(@"err: %@ is too long", text);
        return;
    }
    NSString* packetLength = [NSString stringWithFormat:@"%02d", (int)text.length];
    NSString* packetString = [NSString stringWithFormat:@"%@%@%@", kPacketContentHeader, packetLength, text];
    NSData* packetData = [packetString dataUsingEncoding:NSUTF8StringEncoding];
    
    @synchronized (self) {
        [self.dataToSend appendData:packetData];
    }
    [self sendData];
}


- (void)sendData
{
    if (isSending) {
        return;
    }
    
    if (self.sendDataIndex >= self.dataToSend.length) {
        isSending = false;
        return;
    }
    
    isSending = true;
    
    BOOL didSend = YES;
    while (didSend) {
        
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        amountToSend = MIN(amountToSend, NOTIFY_MTU);
        
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        didSend = [self.peripheral updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:@[self.central]];
        
        //wait for next time sendData is triggered
        if (!didSend) {
            isSending = false;
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        
        self.sendDataIndex += amountToSend;
        
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            @synchronized (self) {
                //clear
                self.sendDataIndex = 0;
                [self.dataToSend setLength:0];
            }
            
            isSending = false;
            return;
        }
    }
}

@end

@implementation BTPeripheralService

+ (instancetype)sharedInstance
{
    static BTPeripheralService* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BTPeripheralService new];
    });

    return instance;
}



@end
