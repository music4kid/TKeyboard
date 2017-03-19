//
//  PasteBoardManager.h
//  EasyText
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _Paste [PasteBoardManager sharedInstance]

@protocol PasteBoardManagerDelegate <NSObject>

- (void)onPasteChanged:(NSString*)str;
#if TARGET_OS_IOS
- (void)onPasteImageChanged:(UIImage*)img;
#endif


@end

@interface PasteBoardManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<PasteBoardManagerDelegate>         delegate;

- (void)monitorPasteBoard;

- (void)detectPasteboardTextChange;
- (void)detectPasteboardImageChange;

@end
