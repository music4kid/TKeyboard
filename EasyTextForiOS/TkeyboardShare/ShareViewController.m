//
//  ShareViewController.m
//  TkeyboardShare
//
//  Created by gao feng on 2016/10/29.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ShareViewController.h"
#import "MCManager.h"

@interface ShareViewController () <MCManagerDelegate>

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lbStatus.text = @"Searching...";
    _lbStatus.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    _holder.layer.cornerRadius = 10;
    _holder.layer.masksToBounds = true;
    _holder.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    _MC.delegate = self;
    [_MC beginAdvertisingForiOS];
}

- (void)didSentImage:(NSURL*)image {
    NSLog(@"didSentImage finished");
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
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
        targetStr = [NSString stringWithFormat:@"Sending to %@...", host];
        
        //send image
        [self beginSendAttachment];
    }
    _lbStatus.text = targetStr;
}

- (void)beginSendAttachment
{
    for (NSItemProvider* itemProvider in ((NSExtensionItem*)self.extensionContext.inputItems[0]).attachments ) {
        
        if([itemProvider hasItemConformingToTypeIdentifier:@"public.png"]) {
            NSLog(@"itemprovider = %@", itemProvider);
            
            [itemProvider loadItemForTypeIdentifier:@"public.png" options:nil completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
                
                NSData *imgData;
                if([(NSObject*)item isKindOfClass:[NSURL class]]) {
                    NSURL* url = (NSURL*)item;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [_MC sendImage:url];
                    });
                }
                if([(NSObject*)item isKindOfClass:[UIImage class]]) {
                    imgData = UIImagePNGRepresentation((UIImage*)item);
                }
            }];
        }
    }
    
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
