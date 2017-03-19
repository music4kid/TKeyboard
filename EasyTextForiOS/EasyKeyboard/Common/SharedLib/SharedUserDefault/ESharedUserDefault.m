//
//  ESharedUserDefault.m
//  EasyCode
//
//  Created by gao feng on 2016/10/20.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ESharedUserDefault.h"

#define KeySharedContainerGroup @"group.com.music4kid.tkeyboard"


@interface ESharedUserDefault ()
@property (nonatomic, strong) NSUserDefaults*                   sharedUD;

@end

@implementation ESharedUserDefault

+ (instancetype)sharedInstance
{
    static ESharedUserDefault* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ESharedUserDefault new];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initSharedUD];
    }
    return self;
}

- (void)initSharedUD
{
    self.sharedUD = [[NSUserDefaults alloc] initWithSuiteName:KeySharedContainerGroup];
}


#define KeySyncHost @"KeySyncHost"
- (void)setSyncHost:(NSString*)host {
    [_sharedUD setObject:host forKey:KeySyncHost];
    [_sharedUD synchronize];
}

- (NSString*)getSyncHost {
    NSString* host = [_sharedUD objectForKey:KeySyncHost];
    return host;
}

#define KeyBTDeviceEnable @"KeyBTDeviceEnable"
- (void)setBTDeviceEnabled:(NSString*)deviceName enabled:(BOOL)enable {
    NSString* key = [NSString stringWithFormat:@"%@-%@", KeyBTDeviceEnable, deviceName];
    [_sharedUD setObject:@(enable) forKey:key];
    [_sharedUD synchronize];
}

- (BOOL)isBTDeviceEnabled:(NSString*)deviceName {
	NSString* key = [NSString stringWithFormat:@"%@-%@", KeyBTDeviceEnable, deviceName];
    NSNumber* enabled = [_sharedUD objectForKey:key];
    if (enabled == nil) {
        return true;
    }
    else
    {
        return enabled.boolValue;
    }
}

#define KeyMacEndTipShown @"KeyMacEndTipShown"
- (BOOL)isMacEndTipShown
{
    NSNumber* enabled = [_sharedUD objectForKey:KeyMacEndTipShown];
    if (enabled == nil) {
        return false;
    }
    else
    {
        return enabled.boolValue;
    }
}

- (void)setMacEndTipShown:(BOOL)shown
{
    [_sharedUD setObject:@(shown) forKey:KeyMacEndTipShown];
    [_sharedUD synchronize];
}



@end
