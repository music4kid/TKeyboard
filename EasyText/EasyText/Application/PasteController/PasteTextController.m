//
//  PasteTextController.m
//  EasyText
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "PasteTextController.h"

@interface PasteTextController ()
@property (weak) IBOutlet NSTextField *lbText;
@property (weak) IBOutlet NSButton *btnSearch;
@property (weak) IBOutlet NSButton *btnClose;

@end

@implementation PasteTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)updateText:(NSString*)text {
    _lbText.stringValue = text;
}

- (IBAction)onSearchClick:(id)sender {
    NSString* targetUrl = [NSString stringWithFormat:@"http://www.google.com?q=%@&gws_rd=cr,ssl", _lbText.stringValue];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:targetUrl]];
    
    if (self.parentPopover) {
        [_parentPopover close];
    }
}

- (IBAction)onCloseClick:(id)sender {
    if (self.parentPopover) {
        [_parentPopover close];
    }
}



@end
