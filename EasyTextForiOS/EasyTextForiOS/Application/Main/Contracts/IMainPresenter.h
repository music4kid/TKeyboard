//
//  IMainPresenter.h
//  PIXY
//
//  Created by gao feng on 16/4/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#ifndef IMainPresenter_h
#define IMainPresenter_h

@protocol IMainPresenter <NSObject>

- (void)autoDetectBluetoothDevices;
- (void)autoDetectMPC;
- (void)sharePasteboard:(NSString*)str;
- (void)sharePasteboardImage:(NSURL*)url;
- (void)renderInitialUI;

@end


#endif /* IMainPresentor_h */
