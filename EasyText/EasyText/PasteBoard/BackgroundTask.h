//
//  BackgroundTask.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundTask : NSObject

+ (instancetype)sharedInstance;

- (void)beginBackgroundTask;

@end
