//
//  EMainPresenter+Bluetooth.h
//  TKeyboardForiOS
//
//  Created by gao feng on 2017/3/7.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import "EMainPresenter.h"
#import "BTClient.h"

@interface EMainPresenter (Bluetooth) <BTClientDelegate>

- (void)beginBluetoothFlow;

@end
