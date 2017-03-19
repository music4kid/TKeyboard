//
//  BackgroundTask.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "BackgroundTask.h"

@implementation BackgroundTask

+ (instancetype)sharedInstance
{
    static BackgroundTask* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BackgroundTask new];
    });

    return instance;
}

- (void)beginBackgroundTask
{
    UIApplication *application = [UIApplication sharedApplication];

    
    //start background task
    __block UIBackgroundTaskIdentifier background_task;
    
    //background task running time differs on different iOS versions.
    //about 10 mins on early iOS, but only 3 mins on iOS7.
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^{
        
        CCLog(@"task expired...");
        [application endBackgroundTask:background_task];
        background_task = UIBackgroundTaskInvalid;
      
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while (true) {
            float remainingTime = [application backgroundTimeRemaining];
            CCLog(@"remaining background time:%f", remainingTime);
            
            [NSThread sleepForTimeInterval:1.0];
            
            __block BOOL inForeground = false;
  
            if (remainingTime <= 3.0 || inForeground) {
                break;
            }
        }
        
        [application endBackgroundTask:background_task];
        background_task = UIBackgroundTaskInvalid;
    });
}


@end
