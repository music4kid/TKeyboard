//
//  UIColor+APP.m
//  vpnchief
//
//  Created by feng gao on 17/1/4.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import "UIColor+APP.h"

@implementation NSColor (APP)
+ (NSColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [NSColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF)) / 255.0
                           alpha:alphaValue];
}

+ (NSColor *)colorWithHex:(NSInteger)hexValue {
    return [NSColor colorWithHex:hexValue alpha:1.0];
}

+ (NSColor *)commonColor {
    return [NSColor colorWithHex:0x81cafc];
}
@end
