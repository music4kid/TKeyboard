//
//  PasteTextController.h
//  EasyText
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PasteTextController : NSViewController

@property (nonatomic, weak) NSPopover*                              parentPopover;

- (void)updateText:(NSString*)text;

- (IBAction)onSearchClick:(id)sender;
- (IBAction)onCloseClick:(id)sender;

@end
