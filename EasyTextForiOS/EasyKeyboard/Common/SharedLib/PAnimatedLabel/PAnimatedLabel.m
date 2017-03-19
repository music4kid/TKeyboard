//
//  PAnimatedLabel.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "PAnimatedLabel.h"

#define PAnimatedLabel_ShowDuration       0.25f
#define PAnimatedLabel_HideDuration       1.0f

@interface PAnimatedLabel ()
@property (nonatomic, strong) NSTimer*                 fadeoutTimer;

@end

@implementation PAnimatedLabel

- (void)startFadeoutTimer
{
    [self stopFadeoutTimer];

    self.fadeoutTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onFadeoutTimeout) userInfo:nil repeats:false];
}

- (void)onFadeoutTimeout
{
    [self showFadeoutAnimation];
}

- (void)stopFadeoutTimer
{
    if (self.fadeoutTimer) {
        [_fadeoutTimer invalidate];
        self.fadeoutTimer = nil;
    }
}

- (void)showText:(NSString*)text {
    [self showText:text autoHide:false];
}

- (void)showText:(NSString*)text autoHide:(BOOL)hide {
    self.text = text;
    
    [self showFadeinAnimation];
    if (hide) {
        [self startFadeoutTimer];
    }
}

- (void)showFadeinAnimation
{
    [UIView animateWithDuration:PAnimatedLabel_ShowDuration animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showFadeoutAnimation
{
    [UIView animateWithDuration:PAnimatedLabel_HideDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
