//
//  PasteController.m
//  EasyText
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "PasteController.h"
#import "MCManager.h"
#import "PasteTextController.h"
#import "PasteImageController.h"

@interface PasteController () <MCManagerDelegate>
@property (nonatomic, strong) NSMutableArray*                 pops;

@end

@implementation PasteController

+ (instancetype)sharedInstance
{
    static PasteController* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PasteController new];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pops = @[].mutableCopy;
    }
    return self;
}

- (void)monitorPaste {
    _MC.delegate = self;
}

#pragma mark - MCManagerDelegate
- (void)didReceiveText:(NSString*)text {
    if (text.length == 0) {
        return;
    }
    
    NSPopover* pop = [[NSPopover alloc] init];
    [_pops addObject:pop];
    
    PasteTextController* ctrl = [[PasteTextController alloc] initWithNibName:@"PasteTextController" bundle:nil];
    pop.contentViewController = ctrl;
    [pop showRelativeToRect:_anchorBtn.bounds ofView:_anchorBtn preferredEdge:NSMinYEdge];
    [ctrl updateText:text];
    ctrl.parentPopover = pop;
}

- (void)didReceiveImage:(NSURL*)image {
    PasteImageController* ctrl = [[PasteImageController alloc] initWithWindowNibName:@"PasteImageController"];
    [_pops addObject:ctrl];
    [ctrl showWindow:self];
    [ctrl.window makeKeyAndOrderFront:ctrl];
    [NSApp activateIgnoringOtherApps:YES];
    [ctrl updateDisplayImage:image];
}

- (void)onPeerStateUpdate:(MCSessionState)state host:(NSString*)host {
    NSString* targetStr = nil;
    if (state == MCSessionStateNotConnected) {
        targetStr = [NSString stringWithFormat:@"Disconnected"];
    }
    else if(state == MCSessionStateConnecting)
    {
        targetStr = [NSString stringWithFormat:@"Connecting..."];
    }
    else if(state == MCSessionStateConnected)
    {
        targetStr = [NSString stringWithFormat:@"Connected to %@...", host];
    }
    NSLog(@"%@", targetStr);
    
}

@end
