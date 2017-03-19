//
//  BTCentralService.m
//  EasyText
//
//  Created by gao feng on 2016/10/23.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "BTCentralService.h"

@implementation BTCentralService

+ (instancetype)sharedInstance
{
    static BTCentralService* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BTCentralService new];
    });

    return instance;
}


#define kPreviousDiscoveredPeripheralID @"kPreviousDiscoveredPeripheralID"
- (void)savePreviousDiscoveredPeripheralID:(NSString*)identifier {
	[[NSUserDefaults standardUserDefaults] setObject:identifier forKey:kPreviousDiscoveredPeripheralID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)getPreviousDiscoveredPeripheralID {
	NSString* identifier = [[NSUserDefaults standardUserDefaults] objectForKey:kPreviousDiscoveredPeripheralID];
    return identifier;
}

- (void)closePreviousConnection
{
    
}


@end
