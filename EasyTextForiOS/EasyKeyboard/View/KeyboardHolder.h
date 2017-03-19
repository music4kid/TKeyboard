//
//  KeyboardHolder.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKeyboardHeight  216

@protocol KeyboardHolderDelegate <NSObject>

- (void)onSyncClick;
- (void)onTextInsert:(NSString*)text;
- (void)onDelete;

@end

@class EAdapter;

@interface KeyboardHolder : UIView

@property (nonatomic, weak) UIInputViewController*                 controller;
@property (nonatomic, weak) id<KeyboardHolderDelegate>             delegate;


- (void)initHolderView:(EAdapter*)adapter;

- (void)startLoading;
- (void)stopLoading;

- (void)refreshHolderView;

- (void)showKeyboardInfo:(NSString*)str;
- (void)showKeyboardInfo:(NSString*)str autoHide:(BOOL)hide;

@end
