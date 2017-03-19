//
//  EPresenter.h
//  EIM
//
//  Created by gao feng on 16/5/5.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDDContext.h"

@interface EPresenter : CDDPresenter

- (void)observeTable:(NSString*)table event:(NSString*)event selector:(SEL)sel;
- (void)unobserveTable:(NSString*)table event:(NSString*)event;

- (void)postLoading;
- (void)hideLoading;

- (void)postImageToast:(NSString *)toast;
- (void)postToast:(NSString *)toast;

@end
