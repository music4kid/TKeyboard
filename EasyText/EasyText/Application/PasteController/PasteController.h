//
//  PasteController.h
//  EasyText
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface PasteController : NSObject

@property (nonatomic, strong) NSStatusBarButton*                    anchorBtn;

+ (instancetype)sharedInstance;

- (void)monitorPaste;

@end
