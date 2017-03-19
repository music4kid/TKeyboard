//
//  IMainInteractor.h
//  PIXY
//
//  Created by gao feng on 16/4/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#ifndef IMainInteractor_h
#define IMainInteractor_h


@protocol IMainInteractor <NSObject>

- (void)gotoKeyboardGuide;
- (void)gotoSyncPeer;
- (void)gotoAbout;
- (void)gotoReview;

@end

#endif /* IMainInteractor_h */
