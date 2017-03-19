//
//  EMainPresenter.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EMainPresenter.h"
#import "PasteBoardManager.h"
#import "MCManager.h"
#import "MainEntry.h"
#import "EMainInteractor.h"
#import "IMainView.h"
#import "UIImageEX.h"
#import "ESharedUserDefault.h"
#import "BTClient.h"
#import "EMainPresenter+Bluetooth.h"

@interface EMainPresenter () <PasteBoardManagerDelegate, MCManagerDelegate>

@end

@implementation EMainPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [_Paste monitorPasteBoard];
        _Paste.delegate = self;
    }
    return self;
}

- (void)renderInitialUI
{
    self.entries = @[].mutableCopy;
    MainEntry* entry = nil;
    
    entry = [[MainEntry alloc] initWithEntryType:EntryTypeSectionEmpty entryName:nil];
    [_entries addObject:entry];
    entry = [[MainEntry alloc] initWithEntryType:EntryTypeSectionHeader entryName:NSLocalizedString(@"HeaderInfo", nil)];
    [_entries addObject:entry];
    entry = [[MainEntry alloc] initWithEntryType:EntryTypeKeyboardGuide entryName:NSLocalizedString(@"CellGuide", nil)];
    [_entries addObject:entry];
    entry = [[MainEntry alloc] initWithEntryType:EntryTypeReview entryName:NSLocalizedString(@"CellReview", nil)];
    [_entries addObject:entry];
    
    entry = [[MainEntry alloc] initWithEntryType:EntryTypeSectionEmpty entryName:nil];
    [_entries addObject:entry];
    NSString* deviceSearchText = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"HeaderDevices", nil), NSLocalizedString(@"DeviceSearching", nil)];
    entry = [[MainEntry alloc] initWithEntryType:EntryTypeSectionHeader entryName:deviceSearchText];
    [_entries addObject:entry];

    [self.adapter setAdapterArray:_entries];
    
    //show first tip
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showTipForMacEnd];
    });
}

- (void)showTipForMacEnd
{
    if ([[ESharedUserDefault sharedInstance] isMacEndTipShown]) {
        return;
    }
    
    [[ESharedUserDefault sharedInstance] setMacEndTipShown:true];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TKeyboard"
                                                    message:NSLocalizedString(@"tipMacApp", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"txtOK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)autoDetectBluetoothDevices
{
    [self beginBluetoothFlow];
}

- (void)autoDetectMPC {
    _MC.delegate = self;
    [_MC beginAdvertisingForiOS];
}

- (void)didSelectCellData:(id)cellData
{
    MainEntry* entry = cellData;
    if (entry.entryType == EntryTypeKeyboardGuide) {
        C(self.context.interactor, IMainInteractor, gotoKeyboardGuide);
    }
    else if (entry.entryType == EntryTypeAboutUs) {
        C(self.context.interactor, IMainInteractor, gotoAbout);
    }
    else if (entry.entryType == EntryTypeReview) {
        C(self.context.interactor, IMainInteractor, gotoReview);
    }
    else if (entry.entryType == EntryTypeAvailableDevice) {
        entry.deviceEnabled = !entry.deviceEnabled;
        [[ESharedUserDefault sharedInstance] setBTDeviceEnabled:entry.entryName enabled:entry.deviceEnabled];
        C(self.context.view, IMainView, reloadMainView);
    }
}


#pragma mark - MCManagerDelegate
- (void)didReceiveImage:(NSURL*)image {
	
}

- (void)didReceiveText:(NSString*)text {
	
}

- (void)onPeerStateUpdate:(MCSessionState)state host:(NSString*)host {
    
    NSString* chosenHost = [[ESharedUserDefault sharedInstance] getSyncHost];
    if ([chosenHost isEqualToString:host] == false) {
        return;
    }
    
    MainEntry* entry = nil;
    NSArray* entries = [self.context.presenter.adapter getAdapterArray];
    for (MainEntry* en in entries) {
        if (en.entryType == EntryTypeChooseSyncHost) {
            entry = en;
            break;
        }
    }
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
        targetStr = [NSString stringWithFormat:@"%@", host];
    }
    entry.entryName = targetStr;
    C(self.context.view, IMainView, reloadMainView);
}



#pragma mark- PasteBoardManagerDelegate

- (void)onPasteChanged:(NSString*)str {
    [self sharePasteboard:str];
}

- (void)onPasteImageChanged:(UIImage*)img {
	//save image to disk
//    NSString* filePath = [img saveToDocument];
//    [self sharePasteboardImage:[NSURL fileURLWithPath:filePath]];
}



- (void)sharePasteboard:(NSString*)str {
    if (str.length == 0) {
        return;
    }
    [_MC sendMessage:str];
}

- (void)sharePasteboardImage:(NSURL*)url {
    if (url) {
        [_MC sendImage:url];
    }
}





@end
