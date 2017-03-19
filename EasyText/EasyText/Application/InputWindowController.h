//
//  InputWindowController.h
//  EasyText
//
//  Created by gao feng on 2016/10/24.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomTextView.h"

@class TextSession;

@protocol InputViewControllerDelegate <NSObject>

- (void)onCloseClick;
- (void)onContentInserted:(NSString*)str;
- (void)onActionTriggered:(NSString*)action;

@end

@interface InputWindowController : NSWindowController

@property (nonatomic, strong) IBOutlet CustomTextView*           txtInput;

- (IBAction)btnCloseClick:(id)sender;
- (IBAction)btnSendClick:(id)sender;

@property (nonatomic, weak) id<InputViewControllerDelegate>                 delegate;
@property (nonatomic, weak) TextSession*                         session;


- (void)updateClientName:(NSString*)name;
- (void)updateContent:(NSString*)content;
- (void)updateCentralStatus;
- (void)clearContent;

@end
