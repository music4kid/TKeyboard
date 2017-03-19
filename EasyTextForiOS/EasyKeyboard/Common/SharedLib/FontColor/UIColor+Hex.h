//
//  UIColor+Hex.h
//  CocoVoice
//
//  Created by feng gao on 13-10-19.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue;
@end
