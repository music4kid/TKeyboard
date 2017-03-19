//
//  PasteImageController.h
//  EasyText
//
//  Created by gao feng on 2016/10/29.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PasteImageController : NSWindowController

@property (nonatomic, strong) IBOutlet NSImageView*                 imgView;

- (void)updateDisplayImage:(NSURL*)url;

@end
