//
//  AppDelegate.m
//  EasyText
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "AppDelegate.h"
#import "BTServer.h"
#import "TransferService.h"
#import "TextSession.h"
#import "MCManager.h"
#import "PasteController.h"

@interface AppDelegate () <BTServerDelegate>

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSStatusItem*                 statusItem;
@property (nonatomic, strong) NSMenu*                       contentMenu;
@property (nonatomic, strong) BTServer*                     btServer;
@property (nonatomic, strong) NSMutableArray*               sessions;

@property (nonatomic, strong) TextSession*                  testSession;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.sessions = @[].mutableCopy;
    [self createStatusBarIcon];
    [self createServer];
    
    [_MC beginBrowsingForMac];
    [[PasteController sharedInstance] monitorPaste];
    
    
//    _testSession = [TextSession new];
//    [_testSession initSession];
//    [_testSession showPopup:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (void)createStatusBarIcon
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    _statusItem.button.image = [NSImage imageNamed:@"StatusImage"];
    _statusItem.button.action = @selector(onStatusItemClicked);
    
    self.contentMenu = [NSMenu new];
    [self refreshMenuItems];
    
    _statusItem.menu = _contentMenu;
    
    [PasteController sharedInstance].anchorBtn = _statusItem.button;
}

- (void)createServer
{
    self.btServer = [BTServer new];
    _btServer.delegate = self;
    [_btServer startAdvertising];
}

- (void)refreshMenuItems
{
    [_contentMenu removeAllItems];
    
    NSMenuItem* item = nil;
    item = [[NSMenuItem alloc] initWithTitle:@"Searching..." action:nil keyEquivalent:@""];
    [_contentMenu addItem:item];
    
    for (int i = 0; i < _sessions.count; i ++) {
        TextSession* session = _sessions[i];
        NSString* clientName = [session.connectedCentral getDisplayName];
        item = [[NSMenuItem alloc] initWithTitle:clientName action:@selector(onClientClicked:) keyEquivalent:@""];
        item.tag = i;
        [_contentMenu addItem:item];
    }
    [_contentMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(onExitClicked) keyEquivalent:@"q"]];
    [_contentMenu addItem:[NSMenuItem separatorItem]];
}

- (void)onStatusItemClicked
{
    NSLog(@"onStatusItemClicked");
}

- (void)onExitClicked
{
    [[NSApplication sharedApplication] terminate:self];
}

- (void)onClientClicked:(id)sender
{
    NSInteger tag = ((NSMenuItem*)sender).tag;
    if (tag <= _sessions.count-1) {
        TextSession* session = _sessions[tag];
        [session showPopup:self];
    }
}

#pragma mark- BTServerDelegate
- (void)onServerStatusChanged {
    [self refreshMenuItems];
}

- (void)onPopupCommandReceived:(NSString*)centralID
{
    for (TextSession* session in _sessions) {
        if ([session.connectedCentral.clientID isEqualToString:centralID] == false) {
            continue;
        }
        
        AvailableClient* conntectedClient = session.connectedCentral;
        if (conntectedClient != nil) {
            [session showPopup:self];
            [session.inputCtrl updateClientName:[conntectedClient getDisplayName]];
        }
    }
}

- (void)onBluetoothOff {
    NSLog(@"onBluetoothOff");
}

- (void)onScanStarted
{
    NSLog(@"onScanStarted");
}

- (void)onClientSubscribed:(NSString*)clientID {
    BOOL exists = false;
    for (TextSession* session in _sessions) {
        if ([session.connectedCentral.clientID isEqualToString:clientID] == true) {
            exists = true;
            session.centralStatus = CentralStatusConnected;
            break;
        }
    }
    if (exists == false) {
        TextSession* session = [TextSession new];
        [session initSession];
        session.btServer = self.btServer;
        session.connectedCentral.clientID = clientID;
        session.centralStatus = CentralStatusConnected;
        [session.inputCtrl updateCentralStatus];
        [_sessions addObject:session];
        [session showPopup:self];
    }
    [self refreshMenuItems];
}

- (void)onClientUnsubscribed:(NSString*)clientID {
	[self refreshMenuItems];
    
    for (TextSession* session in _sessions) {
        if ([session.connectedCentral.clientID isEqualToString:clientID] == true) {
            session.centralStatus = CentralStatusDisconnected;
            [session.inputCtrl updateCentralStatus];
        }
    }
}

- (void)onReceivedClientText:(NSString*)text action:(NSString*)action centralID:(NSString*)centralID {
    
    for (TextSession* session in _sessions) {
        if ([session.connectedCentral.clientID isEqualToString:centralID] == true) {
            
            NSLog(@"onReceivedClientText:%@ action:%@ from:%@", text, action, [session.connectedCentral getDisplayName]);
            if ([action isEqualToString:kActionCentralName]) {
                [session.inputCtrl updateClientName:text];
                
                AvailableClient* connectedCentral = session.connectedCentral;
                connectedCentral.clientName = text;
                [self refreshMenuItems];
            }
            else if([action isEqualToString:kActionCentralContent])
            {
                [session.inputCtrl updateContent:text];
            }
            else if([action isEqualToString:kActionCentralShowPopup])
            {
                [session showPopup:self];
            }
            else if([action isEqualToString:kActionCentralHidePopup])
            {
                [session hidePopup];
            }
        }
    }
}





@end
