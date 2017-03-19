//
//  UIColor+APP.h
//  vpnchief
//
//  Created by feng gao on 17/1/4.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSColor (APP)
+ (NSColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (NSColor*)colorWithHex:(NSInteger)hexValue;

+ (NSColor*)commonColor;
@end
