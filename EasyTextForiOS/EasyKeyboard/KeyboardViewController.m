//
//  KeyboardViewController.m
//  EasyKeyboard
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "KeyboardViewController.h"
#import "BTClient.h"
#import "KeyboardHolder.h"
#import "KeyboardAdapter.h"
#import "AvailableServer.h"
#import "TextViewFormatter.h"
#import "TransferService.h"
#import "KeyboardContentProvider.h"
#import "ESharedUserDefault.h"

@interface KeyboardViewController () <BTClientDelegate, EAdapterDelegate, KeyboardHolderDelegate>

@property (nonatomic, strong) BTClient*                     client;
@property (nonatomic, strong) KeyboardHolder*               holder;

@property (nonatomic, strong) KeyboardAdapter*              adapter;
@property (nonatomic, strong) NSString*                     curFullContent;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kKeyboardHeight]];
    
    if (self.holder == nil) {
        self.adapter = [KeyboardAdapter new];
        _adapter.adapterDelegate = self;
        
        self.holder = [[[NSBundle mainBundle] loadNibNamed:@"KeyboardView" owner:nil options:nil] firstObject];
        self.inputView = self.holder;
        _holder.controller = self;
        _holder.delegate = self;
        [_holder initHolderView:_adapter];
    }
    
    if (self.client == nil) {
        self.client = [BTClient new];
        _client.delegate = self;
    }
    
    //cancel previous connection, if there is any
    [_client closePreviousConnection];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL retrieveSuccess = [self retrievePreviousServer];
    if (retrieveSuccess == false) {
        [self detectRemoteServers];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //hide connected Mac window
    [_client sendText:@"F" withAction:kActionCentralHidePopup];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)selectionWillChange:(nullable id <UITextInput>)textInput
{

}

- (void)selectionDidChange:(nullable id <UITextInput>)textInput
{

}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    
    NSString* txt = [self getFullContent];
    if (txt.length == 0) {
        //sync with mac again
        //[_client sendText:txt withAction:kActionCentralContent];
    }
}

- (void)onSyncClick {
    [self syncContent];
}

#pragma mark - Remote Keyboard Event
- (BOOL)retrievePreviousServer
{
    BOOL success = false;
    NSString* previousServerName = [_client retrievePreviousServer];
    if (previousServerName.length > 0) {
        success = true;
    }
    return success;
}

- (void)detectRemoteServers
{
    [_client startScan];
}

#pragma mark - AdapterDelegate
- (void)didSelectCellData:(id)cellData {
    AvailableServer* server = cellData;
    [_client connectToServer:server.serverName];
    
    if (server.status == ServerStatusConnected) {
        //show popup
        [_client sendText:@"F" withAction:kActionCentralShowPopup];
//        [self syncContent];
    }
}

#pragma mark - BTClientDelegate
- (void)onScanStarted {
    [_holder startLoading];
}

- (void)onBluetoothOff {
    NSLog(@"bluetooth is off");
    
    [_holder showKeyboardInfo:NSLocalizedString(@"BluetoothPoweredOff", @"")];
}

- (void)onClientError:(NSString*)err {
	[_holder showKeyboardInfo:err];
}

- (void)onServerDiscovered:(NSString*)serverName {
    //onServerDiscovered will be entered multi times
    NSLog(@"onServerDiscovered:%@", serverName);
    
    //check if it's enabled
    if ([[ESharedUserDefault sharedInstance] isBTDeviceEnabled:serverName] == false) {
        return;
    }
    
    AvailableServer* existingServer = nil;
    BOOL exists = false;
    NSMutableArray* existingServers = [_adapter getAdapterArray];
    for (AvailableServer* server in existingServers) {
        if ([server.serverName isEqualToString:serverName] == true) {
            exists = true;
            existingServer = server;
            break;
        }
    }
    if (exists == false) {
        AvailableServer* s = [AvailableServer new];
        s.serverName = serverName;
        s.status = ServerStatusNormal;
        [existingServers addObject:s];
        existingServer = s;
    }
    
    [_holder refreshHolderView];
    
    //if server has been used before,  connect directly
    if (existingServer.autoConnected == false) {
        existingServer.autoConnected = true;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:serverName] != nil) {
            [_client connectToServer:serverName];
        }
    }
}

- (void)onServerDisconnected:(NSString*)serverID {
    NSLog(@"onServerDisconnected");
    
    for (AvailableServer* server in [_adapter getAdapterArray]) {
        if ([server.serverName isEqualToString:serverID]) {
            server.status = ServerStatusNormal;
        }
    }
    
    [_holder refreshHolderView];
}

- (void)onServerConnected:(NSString*)serverID {
    NSLog(@"onServerConnected");
    
    [_holder stopLoading];
    
    [[NSUserDefaults standardUserDefaults] setObject:serverID forKey:serverID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AvailableServer* targetServer = nil;
    BOOL exist = false;
    for (AvailableServer* server in [_adapter getAdapterArray]) {
        if ([server.serverName isEqualToString:serverID]) {
            exist = true;
            targetServer = server;
            break;
        }
    }
    if (targetServer && targetServer.contentSynced == false) {
        //send initial content, only send once, onServerConnected may enter multi times
        [_Provider syncCompleteString:self.textDocumentProxy complete:^{
            //content may not be complete, due to API limitation
            NSString* fullContent = [self getFullContent];
            [_client sendText:fullContent withAction:kActionCentralContent];
            _Provider.curLocation = (int)fullContent.length;
        }];
        
        //send client name
        NSString* deviceName = [UIDevice currentDevice].name;
        if (deviceName.length > 0) {
            [_client sendText:deviceName withAction:kActionCentralName];
        }
        
        //wakeup popup
        [_client sendText:@"F" withAction:kActionCentralShowPopup];
        
        targetServer.contentSynced = true;
    }
    
    if (exist == false) {
        AvailableServer* s = [AvailableServer new];
        s.serverName = serverID;
        s.status = ServerStatusConnected;
        
        NSMutableArray* arr = [_adapter getAdapterArray].mutableCopy;
        [arr addObject:s];
        [_adapter setAdapterArray:arr];
    }
    
    for (AvailableServer* server in [_adapter getAdapterArray]) {
        if ([server.serverName isEqualToString:serverID]) {
            server.status = ServerStatusConnected;
        }
    }
    
    [_holder refreshHolderView];
    
    NSString* connectedStr = [NSString stringWithFormat:NSLocalizedString(@"Connected", @""), serverID];
    [_holder showKeyboardInfo:connectedStr autoHide:true];
}

- (void)onServerReceivedAction:(NSString*)action {
//	NSLog(@"onServerReceivedAction:%@", action);
    
    if ([action isEqualToString:kPacketActionDeleteBackward]) {
        [self.textDocumentProxy deleteBackward];
//        [self syncContent];
    }
}

- (void)onServerReceivedText:(NSString*)text {
    [_Provider handleReceivedText:text doc:self.textDocumentProxy];
    return;
}

- (BOOL)isReturnSupported
{
    BOOL supported = true;
    
    [self.textDocumentProxy insertText:@"\n"];
    [self.textDocumentProxy insertText:@"\n"];
    NSString* leftHalf = [self.textDocumentProxy documentContextBeforeInput];
    if ([leftHalf containsString:@"\n\n"] == false) {
        supported = false;
    }
    [self.textDocumentProxy deleteBackward];
    if (supported) {
        [self.textDocumentProxy deleteBackward];
    }
    
    return supported;
}

- (NSString*)getFullContent
{
    NSString* leftHalf = [self.textDocumentProxy documentContextBeforeInput];
    NSString* rightHalf = [self.textDocumentProxy documentContextAfterInput];
    NSString* fullContent = [NSString stringWithFormat:@"%@%@", leftHalf?leftHalf:@"", rightHalf?rightHalf:@""];
    return fullContent;
}

- (NSString*)getCompleteStr
{
    NSMutableString* completeStr = [NSMutableString new];
    
//    NSString* leftHalf = [self.textDocumentProxy documentContextBeforeInput];
//    NSString* rightHalf = [self.textDocumentProxy documentContextAfterInput];
//    while (true) {
//        [self.textDocumentProxy deleteBackward];
//        leftHalf = [self.textDocumentProxy documentContextBeforeInput];
//        rightHalf = [self.textDocumentProxy documentContextAfterInput];
//    }
    
    return completeStr;
}

- (void)syncContent
{
    NSString* fullContent = [self getFullContent];
    [_client sendText:fullContent withAction:kActionCentralContent];
    _Provider.curLocation = fullContent.length;
}

- (void)onTextInsert:(NSString*)text {
    [self.textDocumentProxy insertText:text];
    
    _Provider.fullContent = [_Provider.fullContent stringByAppendingString:text];
    [self syncContent];
}

- (void)onDelete {
    [self.textDocumentProxy deleteBackward];
    [self syncContent];
    
//    [[KeyboardContentProvider sharedInstance] syncCompleteString:self.textDocumentProxy complete:^() {
//        [self syncContent];
//    }];
}



@end
