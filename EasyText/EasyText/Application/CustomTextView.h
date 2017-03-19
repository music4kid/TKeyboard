//
//  CustomTextView.h
//  EasyText
//
//  Created by gao feng on 2016/10/23.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CustomTextViewDelegate <NSObject>

- (void)onBackspaceDown;
- (void)onCmdEnterDown;

@end

@interface CustomTextView : NSTextView

@property (nonatomic, weak) id<CustomTextViewDelegate>                 keyDelegate;


@end
