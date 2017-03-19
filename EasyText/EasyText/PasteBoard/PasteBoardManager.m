//
//  PasteBoardManager.m
//  EasyText
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "PasteBoardManager.h"

#if TARGET_OS_IOS
#import "MSWeakTimer.h"
#import "BackgroundTask.h"
#import "UIImageEX.h"
#endif

@interface PasteBoardManager ()
#if TARGET_OS_IOS
    @property (nonatomic, strong) MSWeakTimer*                  pasteTimer;
#endif
@property (nonatomic, strong) NSString*                     curPaste;
#if TARGET_OS_IOS
@property (nonatomic, strong) UIImage*                      curPasteImage;
#endif


@end

@implementation PasteBoardManager

+ (instancetype)sharedInstance
{
    static PasteBoardManager* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PasteBoardManager new];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)monitorPasteBoard {
#if TARGET_OS_IOS
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectPasteboardChange) name:UIPasteboardChangedNotification object:nil];
#endif

    self.curPaste = nil;
    #if TARGET_OS_IOS
    self.curPaste = [UIPasteboard generalPasteboard].string;
    self.curPasteImage = [UIPasteboard generalPasteboard].image;
    
//    self.pasteTimer = [MSWeakTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onPasteTimeout) userInfo:nil repeats:true dispatchQueue:
//                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    #endif
    
    
//    UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"imageName"]];
//    [[UIPasteboard generalPasteboard]setImage:image];
    
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    [pasteboard setData:data forPasteboardType:@"public.png"];
}

- (void)onPasteTimeout
{
//    #if TARGET_OS_IOS
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
//        return;
//    }
//
//    NSString* copyClip = [UIPasteboard generalPasteboard].string;
//    NSLog(@"checking pasteboard:%@", copyClip);
//    if (copyClip.length > 0 && [copyClip isEqualToString:self.curPaste] == false) {
//        self.curPaste = copyClip;
//        [self detectPasteboardTextChange];
//    }
//    
//    UIImage* copyImg = [UIPasteboard generalPasteboard].image;
//    if (copyImg != 0 && [copyImg isEqualToImage:_curPasteImage] == false) {
//        self.curPasteImage = copyImg;
//        [self detectPasteboardImageChange];
//    }
//    #endif

}


- (void)detectPasteboardTextChange
{
    NSString *copyClip = nil;
    #if TARGET_OS_IOS
    copyClip = [UIPasteboard generalPasteboard].string;
    #endif
    
    if (self.delegate && copyClip.length > 0) {
        [_delegate onPasteChanged:copyClip];
    }
    
    NSLog(@"Clip = %@",copyClip);
}

- (void)detectPasteboardImageChange
{
    #if TARGET_OS_IOS
    UIImage* copyImg = [UIPasteboard generalPasteboard].image;
    if (self.delegate && copyImg != nil) {
        [_delegate onPasteImageChanged:copyImg];
    }
    #endif
}

@end
