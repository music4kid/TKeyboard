//
//  BTCentralService.h
//  EasyText
//
//  Created by gao feng on 2016/10/23.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCentralService : NSObject

+ (instancetype)sharedInstance;

- (void)savePreviousDiscoveredPeripheralID:(NSString*)identifier;
- (NSString*)getPreviousDiscoveredPeripheralID;

- (void)closePreviousConnection;

@end
