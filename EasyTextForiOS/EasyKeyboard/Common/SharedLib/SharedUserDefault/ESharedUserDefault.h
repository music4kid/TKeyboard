//
//  ESharedUserDefault.h
//  EasyCode
//
//  Created by gao feng on 2016/10/20.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESharedUserDefault : NSObject

+ (instancetype)sharedInstance;

- (NSString*)getSyncHost;
- (void)setSyncHost:(NSString*)host;

- (BOOL)isBTDeviceEnabled:(NSString*)deviceName;
- (void)setBTDeviceEnabled:(NSString*)deviceName enabled:(BOOL)enable;

- (BOOL)isMacEndTipShown;
- (void)setMacEndTipShown:(BOOL)shown;

@end
