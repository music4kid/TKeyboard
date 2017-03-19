//
//  CDDContext.m
//  CDDDemo
//
//  Created by gao feng on 16/2/3.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDContext.h"

@implementation CDDPresenter
@end

@implementation CDDInteractor
@end

@implementation CDDView
- (void)dealloc
{
    self.context = nil;
}
@end

@implementation CDDContext

- (void)dealloc
{
    NSLog(@"context being released");
}

@end
