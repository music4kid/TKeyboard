//
//  InputWindowController.m
//  EasyText
//
//  Created by gao feng on 2016/10/24.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "InputWindowController.h"
#import "TextViewFormatter.h"
#import "TransferService.h"
#import "VView.h"
#import "UIColor+APP.h"
#import "TextSession.h"

@interface InputWindowController ()<NSTextViewDelegate, NSControlTextEditingDelegate, CustomTextViewDelegate, NSWindowDelegate>
@property (weak) IBOutlet VView *bgView;
@property (weak) IBOutlet VView *holderView;
@property (weak) IBOutlet NSButton *btnSend;
@property (weak) IBOutlet NSTextField *lbTitle;
@property (weak) IBOutlet NSTextField *lbStatus;
@property (weak) IBOutlet NSTextField *lbTip;

@end

@implementation InputWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.delegate = self;
    self.window.styleMask |= NSWindowStyleMaskFullSizeContentView;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = true;
    self.window.title = @"";
    
    _txtInput.delegate = self;
    _txtInput.keyDelegate = self;
    
    _bgView.backgroundColor = [NSColor colorWithHex:0x000000 alpha:0.6];
    _holderView.backgroundColor = [NSColor whiteColor];
    
    NSFont* font = [NSFont systemFontOfSize:16];
    [_txtInput setFont:font];
    [_txtInput setTextColor:[NSColor colorWithWhite:0.2 alpha:1]];
    
    [self showTipText:NSLocalizedString(@"CmdEnterSend", nil)];
}


- (void)showTipText:(NSString*)text
{
    _lbTip.alphaValue = 1;
    _lbTip.stringValue = text;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            context.duration = 0.5f;
            _lbTip.animator.alphaValue = 0;
        } completionHandler:^{

        }];
    });
}

- (void)awakeFromNib
{
    [self setButtonTitleFor:_btnSend toString:NSLocalizedString(@"BtnTextSend", nil) withColor:[NSColor colorWithWhite:1 alpha:1]];
}

- (void)updateClientName:(NSString*)name {
    if (name.length > 0) {
        _lbTitle.stringValue = name;
    }
}

- (void)updateContent:(NSString*)content {
    [_txtInput setString:content];
}

- (void)clearContent {
    [_txtInput setString:@""];
}

- (void)updateCentralStatus {
	_lbStatus.stringValue = @"";
    if (_session.centralStatus == CentralStatusDisconnected) {
        _lbStatus.stringValue = NSLocalizedString(@"StatusConnecting", nil);
    }
    else if(_session.centralStatus == CentralStatusConnected) {
        _lbStatus.stringValue = NSLocalizedString(@"StatusConnected", nil);
    }
}

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    BOOL handled = true;
    
    if (self.delegate) {
        
        TextPayload* p = [TextPayload new];
        p.text = [replacementString stringByReplacingOccurrencesOfString:@"\n" withString:@"\r"];
        p.range = affectedCharRange;
        p.affectedText = [[_txtInput string] substringWithRange:affectedCharRange];
        NSString* encoded = [TextViewFormatter encodeTextPayload:p];
        
        [_delegate onContentInserted:encoded];
        
        if (replacementString.length == 0 && affectedCharRange.length != 0) {
            NSLog(@"clearing content");
        }
        
    }
    
    return handled;
}

//- (NSRange)textView:(NSTextView *)textView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange
//{
//    NSString* text = [_txtInput string];
//    if (oldSelectedCharRange.location == newSelectedCharRange.location &&
//        oldSelectedCharRange.length == newSelectedCharRange.length) {
//        return newSelectedCharRange;
//    }
//    
//    //disable range selection
//    if (newSelectedCharRange.location < text.length) {
//        return oldSelectedCharRange;
//    }
//    
//    return newSelectedCharRange;
//}

- (void)onBackspaceDown {
    NSString* curText = [_txtInput string];
    if (curText.length == 0) {
        [_delegate onActionTriggered:kPacketActionDeleteBackward];
    }
}

- (void)onCmdEnterDown {
    [self btnSendClick:nil];
}

- (IBAction)btnCloseClick:(id)sender {
    if (self.delegate) {
        [_delegate onCloseClick];
    }
}

- (IBAction)btnSendClick:(id)sender {
    if (self.delegate) {
        NSString* text = [_txtInput string];
        if (text.length == 0) {
            NSLog(@"empty text");
            return;
        }
        
        //send content
        text = @"\n";
        TextPayload* p = [TextPayload new];
        p.text = text;
        p.range = NSMakeRange([_txtInput string].length, text.length);
        NSString* encoded = [TextViewFormatter encodeTextPayload:p];
        [_delegate onContentInserted:encoded];
        
        _txtInput.string = @"";
        
    }
}

- (void)setButtonTitleFor:(NSButton*)button toString:(NSString*)title withColor:(NSColor*)color
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:title attributes:attrsDictionary];
    [button setAttributedTitle:attrString];
}


@end
