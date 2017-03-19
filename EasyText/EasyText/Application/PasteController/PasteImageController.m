//
//  PasteImageController.m
//  EasyText
//
//  Created by gao feng on 2016/10/29.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "PasteImageController.h"

@interface PasteImageController ()

@end

@implementation PasteImageController

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

- (void)updateDisplayImage:(NSURL*)url {
    NSImage* img = [[NSImage alloc] initWithContentsOfURL:url];
    self.imgView.image = img;
    
    NSRect e = [[NSScreen mainScreen] frame];
    int H = (int)e.size.height;
    int W = (int)e.size.width;
    float maxW = W*2/3;
    float maxH = H*2/3;
    
    float displayW = 0;
    int displayH = 0;
    float imgW = img.size.width;
    float imgH = img.size.height;
    if (imgW >= imgH) {
        displayW = MIN(imgW, maxW);
        displayH = displayW * imgH / imgW;
    }
    else
    {
        displayH = MIN(imgH, maxH);
        displayW = displayH * imgW / imgH;
    }
    
    NSRect frame = self.window.frame;
    frame.size.width = displayW;
    frame.size.height = displayH + 20;
    [self.window setFrame:frame display:true animate:true];
    
    
    frame = _imgView.frame;
    frame.size.width = displayW;
    frame.size.height = displayH;
    _imgView.frame = frame;
}



@end
