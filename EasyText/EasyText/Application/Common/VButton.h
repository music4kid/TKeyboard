//
//  VButton.h
//  vpnchiefosx
//
//  Created by gao feng on 2017/3/3.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VButton : NSButton

@property (nonatomic, strong) NSColor*                 titleColor;

- (void)setButtonTitle:(NSString*)title;
- (void)setButtonTitle:(NSString*)title withColor:(NSColor*)color;

@end
