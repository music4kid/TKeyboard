//
//  VView.m
//  vpnchiefosx
//
//  Created by gao feng on 2017/3/3.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import "VView.h"

@interface VView ()


@end

@implementation VView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (_backgroundColor) {
        [_backgroundColor setFill];
    } else {
        [[NSColor whiteColor] setFill];
    }
    
    NSRectFill(dirtyRect);
    
    [super drawRect:dirtyRect];
}

@end
