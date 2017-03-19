//
//  KeyboardContentProvider.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _Provider [KeyboardContentProvider sharedInstance]

@interface KeyboardContentProvider : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString*                 fullContent;
@property (nonatomic, assign) NSUInteger                curLocation;


- (void)syncCompleteString:(id <UITextDocumentProxy>)doc complete:(void (^)())completion;

- (void)handleReceivedText:(NSString*)text doc:(id <UITextDocumentProxy>)doc;

@end
