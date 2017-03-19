//
//  EMainPresenter+Bluetooth.m
//  TKeyboardForiOS
//
//  Created by gao feng on 2017/3/7.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import "EMainPresenter+Bluetooth.h"
#import "MainEntry.h"
#import "ESharedUserDefault.h"
#import "IMainView.h"


@implementation EMainPresenter (Bluetooth)

#pragma mark - BTClientDelegate
- (void)beginBluetoothFlow {
    if (self.client == nil) {
        self.client = [BTClient new];
        self.client.delegate = self;
    }
    
    [self.client startScan];
}


- (void)onScanStarted {
    
}

- (void)onBluetoothOff {
    NSLog(@"bluetooth is off");
    
//    [_holder showKeyboardInfo:NSLocalizedString(@"BluetoothPoweredOff", @"")];
}

- (void)onClientError:(NSString*)err {
//    [_holder showKeyboardInfo:err];
}

- (void)onServerDiscovered:(NSString*)serverName {
    //onServerDiscovered will be entered multi times
    NSLog(@"onServerDiscovered: %@", serverName);
    
    BOOL exists = false;
    NSMutableArray* existingServers = @[].mutableCopy;
    for (MainEntry* e in self.entries) {
        if (e.entryType == EntryTypeAvailableDevice) {
            [existingServers addObject:e];
        }
    }
    
    for (MainEntry* server in existingServers) {
        if ([server.entryName isEqualToString:serverName] == true) {
            exists = true;
            break;
        }
    }
    if (exists == false) {
        MainEntry* s = [MainEntry new];
        s.entryName = serverName;
        s.entryType = EntryTypeAvailableDevice;
        s.deviceEnabled = [[ESharedUserDefault sharedInstance] isBTDeviceEnabled:serverName];
        [existingServers addObject:s];
    }
    
    NSMutableArray* freshServers = @[].mutableCopy;
    for (MainEntry* e in self.entries) {
        if (e.entryType != EntryTypeAvailableDevice) {
            [freshServers addObject:e];
        }
    }
    for (MainEntry* e in existingServers) {
        [freshServers addObject:e];
    }
    [self.adapter setAdapterArray:freshServers];
    
    C(self.context.view, IMainView, reloadMainView);
}


@end
