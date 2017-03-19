//
//  TextSession.m
//  EasyText
//
//  Created by gao feng on 2016/10/24.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "TextSession.h"
#import "InputWindowController.h"

@interface TextSession ()<InputViewControllerDelegate>

@end

@implementation TextSession

- (void)initSession {

    self.inputCtrl = [[InputWindowController alloc] initWithWindowNibName:@"InputWindowController"];
    self.inputCtrl.delegate = self;
    
    self.connectedCentral = [AvailableClient new];
    self.centralStatus = CentralStatusDisconnected;
}

- (void)showPopup:(id)sender
{
    [self.inputCtrl showWindow:self];
    [_inputCtrl.window makeKeyAndOrderFront:_inputCtrl];
    _inputCtrl.session = self;
    [_inputCtrl updateCentralStatus];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)hidePopup
{
    [self.inputCtrl close];
}


#pragma mark - InputViewControllerDelegate
- (void)onCloseClick {
	[self hidePopup];
}

- (void)onContentInserted:(NSString*)str {
    NSLog(@"sending text: %@ to: %@", str, self.connectedCentral.clientID);
    [_btServer sendContent:str centralID:self.connectedCentral.clientID];
}


- (void)onActionTriggered:(NSString*)action {
    [_btServer sendAction:action centralID:self.connectedCentral.clientID];
}


@end
