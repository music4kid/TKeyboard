//
//  CustomTextView.m
//  EasyText
//
//  Created by gao feng on 2016/10/23.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView

- (void)keyDown:(NSEvent *)theEvent
{
    if(theEvent.keyCode == 51)
    {
        NSLog(@"key backspace down");
        if (self.keyDelegate) {
            [_keyDelegate onBackspaceDown];
        }
    }
    if (([theEvent modifierFlags] & NSEventModifierFlagCommand) && theEvent.keyCode == 36) {
        if (self.keyDelegate) {
            [_keyDelegate onCmdEnterDown];
        }
    }
    
    [super keyDown:theEvent];
}

@end
