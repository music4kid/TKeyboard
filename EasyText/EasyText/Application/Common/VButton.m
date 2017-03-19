//
//  VButton.m
//  vpnchiefosx
//
//  Created by gao feng on 2017/3/3.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import "VButton.h"

@interface VButton ()


@end

@implementation VButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setButtonTitle:(NSString*)title {
    [self setButtonTitle:title withColor:_titleColor];
}

- (void)setButtonTitle:(NSString*)title withColor:(NSColor*)color
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSCenterTextAlignment];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:title attributes:attrsDictionary];
    [self setAttributedTitle:attrString];
}




@end
